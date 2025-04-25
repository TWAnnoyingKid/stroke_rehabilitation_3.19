import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fl_chart/fl_chart.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:path/path.dart' show basename;
import 'audio_processor.dart';
import 'swallow_detector.dart'; // 引入吞嚥檢測器

class RsstResultPage extends StatefulWidget {
  final int swallowCount;
  final String? recordingPath;
  final bool isFromUpload;  // 標記是否從上傳來的

  const RsstResultPage({
    super.key,
    required this.swallowCount,
    this.recordingPath,
    this.isFromUpload = false,
  });

  @override
  _RsstResultPageState createState() => _RsstResultPageState();
}

class _RsstResultPageState extends State<RsstResultPage> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  bool _uploadSuccess = false; // 設為實際上傳狀態

  // 音檔播放和波形圖相關變數
  TabController? _tabController;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isLoadingAudio = false;
  List<double> _audioWaveform = [];
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _positionTimer;
  int _sampleRate = 44100;
  bool _isSampleRateCorrect = true;
  String _audioFileDuration = "00:00";
  bool _isAudioSeekable = true;

  // 音頻處理相關變數
  bool _isProcessing = true; // 初始狀態為處理中
  bool _isInferencing = false; // 是否正在進行模型推論
  String? _denoisedFilePath;
  List<AudioSegment> _audioSegments = [];
  String? _processingErrorMessage;
  int _originalSampleRate = 44100; // 原始採樣率

  // 吞嚥檢測相關變數
  SwallowDetector _swallowDetector = SwallowDetector();
  int _detectedSwallowCount = 0; // 檢測到的吞嚥次數
  List<double> _swallowTimes = []; // 吞嚥時間點
  List<double> _swallowProbs = []; // 吞嚥概率

  @override
  void initState() {
    super.initState();

    // 初始化標籤控制器 - 只有兩個標籤：結果概覽和音檔波形
    _tabController = TabController(length: 2, vsync: this);

    // 如果有錄音文件，自動進行處理
    if (widget.recordingPath != null) {
      _processAudioFile();
    } else {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // 自動處理音檔
  Future<void> _processAudioFile() async {
    if (widget.recordingPath == null) return;

    setState(() {
      _isProcessing = true;
      _processingErrorMessage = null;
    });

    try {
      // 使用AudioProcessor處理音頻
      final result = await AudioProcessor.processAudio(widget.recordingPath!);

      if (mounted) {
        setState(() {
          _denoisedFilePath = result['denoisedFilePath'] as String;
          _audioSegments = result['segments'] as List<AudioSegment>;
          _sampleRate = result['adjustedSampleRate'] as int; // 使用調整後的採樣率
          _originalSampleRate = result['originalSampleRate'] as int; // 保存原始採樣率
          _isProcessing = false;
          _isInferencing = true; // 進入推論階段
        });

        // 處理完成後，初始化音頻播放器（使用降噪後的音頻）
        if (_denoisedFilePath != null) {
          await _initAudioPlayer(_denoisedFilePath!);
          await _loadAudioData(_denoisedFilePath!);
        }

        // 進行 ONNX 模型推論
        try {
          final inferenceResult = await _swallowDetector.detectSwallows(_audioSegments);

          // 模擬上傳結果到服務器（實際應用中應該調用真實API）
          if (!widget.isFromUpload) {
            try {
              // 這裡應該是實際的API調用
              await Future.delayed(Duration(seconds: 1)); // 模擬網絡延遲
              // 如果API調用成功，設置上傳成功狀態
              setState(() {
                _uploadSuccess = true; // 在實際應用中，這應該基於API響應
              });
            } catch (e) {
              print('上傳結果失敗: $e');
              setState(() {
                _uploadSuccess = false;
              });
            }
          }

          setState(() {
            _detectedSwallowCount = inferenceResult['swallowCount'];
            _swallowTimes = inferenceResult['swallowTimes'];
            _swallowProbs = inferenceResult['swallowProbs'];
            _isInferencing = false;
          });

          print('檢測到 $_detectedSwallowCount 次吞嚥');
        } catch (e) {
          print('模型推論失敗: $e');
          setState(() {
            _isInferencing = false;
            _processingErrorMessage = '模型推論失敗: $e';
          });
        }
      }
    } catch (e) {
      print('處理音頻文件失敗: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingErrorMessage = '音頻處理失敗: $e';
        });
      }
    }
  }

  // 初始化音頻播放器
  Future<void> _initAudioPlayer(String audioPath) async {
    setState(() {
      _isLoadingAudio = true;
    });

    _audioPlayer = AudioPlayer();
    try {
      // 檢查檔案是否存在
      File audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        print('音頻檔案不存在: $audioPath');
        setState(() {
          _isLoadingAudio = false;
        });
        return;
      }

      // 獲取檔案大小
      int fileSize = await audioFile.length();
      print('音頻檔案大小: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      try {
        // 設置音頻來源
        await _audioPlayer!.setSource(DeviceFileSource(audioPath));
        await _audioPlayer!.pause(); // 先暫停播放

        // 獲取總時長
        final duration = await _audioPlayer!.getDuration();
        if (duration != null) {
          setState(() {
            _totalDuration = duration;
            _audioFileDuration = _formatDuration(_totalDuration);
            print('音檔長度: $_audioFileDuration');
          });
        } else {
          print('無法獲取音頻長度，使用默認值');
          setState(() {
            _totalDuration = Duration.zero;
            _audioFileDuration = "00:00";
          });
        }

        // 設置位置更新監聽
        _audioPlayer!.onPositionChanged.listen((Duration position) {
          if (mounted) {
            setState(() {
              _currentPosition = position;
            });
          }
        });

        // 設置播放完成監聽
        _audioPlayer!.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _currentPosition = Duration.zero;
            });
          }
        });

        // 檢查是否可以 seek
        try {
          await _audioPlayer!.seek(Duration(milliseconds: 100));
          await _audioPlayer!.seek(Duration.zero);
          _isAudioSeekable = true;
        } catch (e) {
          print('檢查 seek 功能失敗: $e');
          _isAudioSeekable = false;
        }
      } catch (e) {
        print('設置音頻源失敗: $e');
      }

      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    } catch (e) {
      print('初始化音頻播放器失敗: $e');
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
  }

  // 載入音頻數據用於波形圖
  Future<void> _loadAudioData(String audioPath) async {
    setState(() {
      _isLoadingAudio = true;
    });

    try {
      final File audioFile = File(audioPath);
      if (await audioFile.exists()) {
        final bytes = await audioFile.readAsBytes();
        if (bytes.length < 44) {
          print('警告：音頻文件太短，無法解析頭部');
          setState(() {
            _isLoadingAudio = false;
          });
          return;
        }

        try {
          // 解析 WAV 檔案並提取波形數據
          _sampleRate = _getSampleRateFromWavHeader(bytes);
          print('從音頻文件讀取到採樣率: $_sampleRate Hz');

          _audioWaveform = _extractWaveform(bytes);

          // 如果數據太多，抽樣以減少點數
          if (_audioWaveform.length > 3000) {
            final samplingRate = (_audioWaveform.length / 3000).ceil();
            _audioWaveform = _audioWaveform
                .asMap()
                .entries
                .where((entry) => entry.key % samplingRate == 0)
                .map((entry) => entry.value)
                .toList();
          }
        } catch (e) {
          print('解析音頻數據失敗: $e');
        }
      } else {
        print('音頻文件不存在: $audioPath');
      }
    } catch (e) {
      print('加載音頻數據失敗: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
  }

  // 從WAV檔案頭部獲取採樣率
  int _getSampleRateFromWavHeader(List<int> fileBytes) {
    // WAV格式: 採樣率存儲在位置24-27
    if (fileBytes.length < 28) {
      print('警告：檔案可能不是有效的WAV檔案，太短無法讀取標頭');
      return 44100; // 使用默認採樣率
    }

    try {
      return fileBytes[24] + (fileBytes[25] << 8) + (fileBytes[26] << 16) + (fileBytes[27] << 24);
    } catch (e) {
      print('解析WAV頭部失敗: $e');
      return 44100; // 發生錯誤時使用默認採樣率
    }
  }

  // 從WAV檔案提取波形數據
  List<double> _extractWaveform(List<int> fileBytes) {
    // 跳過WAV檔案頭部（通常是44字節）
    int headerSize = 44;
    if (fileBytes.length <= headerSize) {
      return [];
    }

    try {
      List<int> pcmBytes = fileBytes.sublist(headerSize);

      // 假設是16位PCM數據（每個樣本2字節）
      List<double> waveform = [];
      for (int i = 0; i < pcmBytes.length; i += 2) {
        if (i + 1 < pcmBytes.length) {
          // 將兩個字節合併為16位有符號整數，然後標準化到 -1 到 1
          int sample = pcmBytes[i] | (pcmBytes[i + 1] << 8);
          // 處理有符號數
          if (sample > 32767) sample -= 65536;
          waveform.add(sample / 32768.0);
        }
      }

      return waveform;
    } catch (e) {
      print('提取波形數據失敗: $e');
      return [];
    }
  }

  // 切換播放/暫停
  void _togglePlay() async {
    if (_audioPlayer == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer!.pause();
        _stopPositionTimer();
      } else {
        await _audioPlayer!.resume();
        _startPositionTimer();
      }

      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      print('音頻播放操作失敗: $e');
    }
  }

  // 開始位置計時器
  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(Duration(milliseconds: 200), (timer) async {
      // 新版API獲取當前位置
      try {
        final position = await _audioPlayer?.getCurrentPosition();
        if (position != null && mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      } catch (e) {
        print('獲取播放位置失敗: $e');
      }
    });
  }

  // 停止位置計時器
  void _stopPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  // 跳轉到指定位置
  void _seekTo(double value) async {
    if (!_isAudioSeekable || _audioPlayer == null) {
      print('該音檔不支援進度條拖動功能');
      return;
    }

    if (_totalDuration.inMilliseconds <= 0) {
      print('音頻長度無效，無法進行定位');
      return;
    }

    try {
      final newPosition = Duration(milliseconds: (value * _totalDuration.inMilliseconds).round());
      await _audioPlayer?.seek(newPosition);
      setState(() {
        _currentPosition = newPosition;
      });
    } catch (e) {
      print('音頻跳轉失敗: $e');
    }
  }

  // 格式化時間
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _tabController?.dispose();

    // 確保釋放所有播放器資源
    try {
      _audioPlayer?.dispose();
    } catch (e) {
      print('釋放音頻播放器資源失敗: $e');
    }

    _positionTimer?.cancel();
    _unfocusNode.dispose();

    // 釋放 SwallowDetector 資源
    _swallowDetector.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF90BDF9),
        appBar: AppBar(
          backgroundColor: Color(0xFF90BDF9),
          automaticallyImplyLeading: false,
          title: Text(
            widget.isFromUpload ? '音檔分析結果' : 'RSST 測驗結果',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          elevation: 2,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: const [
              Tab(text: '結果概覽'),
              Tab(text: '音檔波形'),
            ],
          ),
        ),
        body: (_isProcessing || _isInferencing)
            ? _buildProcessingView()
            : TabBarView(
          controller: _tabController,
          children: [
            _buildResultOverview(),
            _buildWaveformTab(),
          ],
        ),
      ),
    );
  }

  // 處理中的視圖
  Widget _buildProcessingView() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E5AAC)),
            ),
            SizedBox(height: 20),
            Text(
              _isInferencing ? '正在進行吞嚥次數推論...' : '正在處理音檔...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5AAC),
              ),
            ),
            SizedBox(height: 10),
            Text(
              _isInferencing
                  ? '使用 ONNX 模型分析吞嚥次數，請稍候...'
                  : '正在應用降噪和分割處理，請稍候...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            if (_processingErrorMessage != null) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(height: 5),
                    Text(
                      _processingErrorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                      ),
                      child: Text('返回', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultOverview() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4DB60),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFFC50D1C),
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AutoSizeText(
                    widget.isFromUpload ? '音檔分析完成！' : '測驗完成！',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF2E5AAC),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!widget.isFromUpload) ...[
                    const SizedBox(height: 10),
                    AutoSizeText(
                      '您的吞嚥次數',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E5AAC),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$_detectedSwallowCount',  // 使用檢測到的實際數值
                          style: FlutterFlowTheme.of(context).displayLarge.override(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Icon(
                          _uploadSuccess ? Icons.check_circle : Icons.error,
                          color: _uploadSuccess ? Colors.green : Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        AutoSizeText(
                          _uploadSuccess ? '結果已儲存！獲得10點數。' : '結果儲存失敗，但您仍完成了測驗。',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            color: _uploadSuccess ? Colors.green : Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 10),
                    AutoSizeText(
                      '檢測到的吞嚥次數',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E5AAC),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$_detectedSwallowCount',  // 顯示檢測到的實際值
                          style: FlutterFlowTheme.of(context).displayLarge.override(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.audio_file,
                      size: 40,
                      color: Color(0xFF2E5AAC),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '音檔已成功處理並分析',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E5AAC),
                      ),
                    ),
                  ],

                  // 處理完成的提示
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(height: 5),
                          Text(
                            '音檔已經過降噪處理及分析完成',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 顯示吞嚥時間點（如果有檢測到）
                  if (_swallowTimes.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '檢測到的吞嚥時間點',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E5AAC),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 150,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: math.min(10, _swallowTimes.length),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '吞嚥 #${index + 1}:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${_swallowTimes[index].toStringAsFixed(2)}秒',
                                          style: TextStyle(
                                            color: Color(0xFF2E5AAC),
                                          ),
                                        ),
                                        Text(
                                          '概率: ${(_swallowProbs[index] * 100).toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            color: Colors.green.shade800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (_swallowTimes.length > 10)
                              Text(
                                '... 以及 ${_swallowTimes.length - 10} 個更多時間點',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // 顯示音檔相關資訊
                  if (_denoisedFilePath != null || widget.recordingPath != null) ...[
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text(
                      '音檔資訊',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2E5AAC),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 音檔採樣率
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '原始採樣率:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$_originalSampleRate Hz',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _originalSampleRate == 44100 ? Colors.green.shade800 : Colors.orange.shade800,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    _originalSampleRate == 44100 ? Icons.check_circle : Icons.info_outline,
                                    color: _originalSampleRate == 44100 ? Colors.green.shade800 : Colors.orange.shade800,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // 調整後採樣率
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '調整後採樣率:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$_sampleRate Hz',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade800,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // 音檔長度
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '音檔長度:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _audioFileDuration,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // 處理結果
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '分割片段數:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_audioSegments.length}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // 檔案名稱
                          Text(
                            '原始檔案:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.recordingPath != null ? basename(widget.recordingPath!) : '未知',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade800,
                              fontFamily: 'Courier',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.isFromUpload) {
                  // 返回上一頁
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4DB60),
                foregroundColor: const Color(0xFFC50D1C),
                padding: const EdgeInsetsDirectional.fromSTEB(40, 15, 40, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: AutoSizeText(
                '返回',
                style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Poppins',
                  color: const Color(0xFFC50D1C),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 波形圖頁面
  Widget _buildWaveformTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '降噪後音頻波形',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Poppins',
                      color: const Color(0xFF2E5AAC),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (_originalSampleRate != 44100)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange, size: 16),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '原始採樣率 $_originalSampleRate Hz 已自動轉換為標準的 44.1kHz',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  // 降噪提示
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.audio_file, color: Colors.green, size: 16),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '此音檔已經過巴特沃斯濾波與頻譜閘控降噪處理',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 音檔長度和播放時長顯示
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '音檔長度: ${_formatDuration(_totalDuration)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E5AAC),
                        ),
                      ),
                    ),
                  ),

                  // 標記吞嚥時間點
                  if (_swallowTimes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.water_drop, color: Colors.red, size: 16),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '在波形上標記了 ${_swallowTimes.length} 個吞嚥點',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 音頻播放控制
                  if (_denoisedFilePath != null && _audioPlayer != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 36,
                                  color: const Color(0xFF2E5AAC),
                                ),
                                onPressed: _togglePlay,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    thumbColor: const Color(0xFF2E5AAC),
                                    activeTrackColor: const Color(0xFF2E5AAC),
                                    inactiveTrackColor: Colors.grey.shade300,
                                  ),
                                  child: Slider(
                                    value: _totalDuration.inMilliseconds > 0
                                        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                                        : 0.0,
                                    onChanged: _isAudioSeekable ? _seekTo : null,
                                  ),
                                ),
                                if (!_isAudioSeekable)
                                  Positioned.fill(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '此音檔不支援進度條拖動',
                                        style: TextStyle(
                                          color: Colors.red.shade800,
                                          fontSize: 10,
                                          backgroundColor: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isLoadingAudio)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('正在載入音頻數據...'),
                        ],
                      ),
                    )
                  else if (_audioWaveform.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '無法載入音頻波形數據',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      height: 300,
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: _buildWaveformChart(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 波形圖
  Widget _buildWaveformChart() {
    if (_audioWaveform.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40),
            SizedBox(height: 10),
            Text(
              '無法載入音頻波形數據',
              style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: _audioWaveform.length.toDouble(),
        minY: -1,
        maxY: 1,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                double timeInSeconds = barSpot.x / _sampleRate;
                return LineTooltipItem(
                  '${timeInSeconds.toStringAsFixed(2)}秒\n振幅: ${barSpot.y.toStringAsFixed(3)}',
                  const TextStyle(color: Color(0xFF2E5AAC), fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 0.25,
          verticalInterval: _audioWaveform.length / 10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index % (_audioWaveform.length ~/ 10) == 0) {
                  double seconds = index / _sampleRate;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${seconds.toStringAsFixed(1)}s',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 0.5 == 0) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(_audioWaveform.length, (i) {
              return FlSpot(i.toDouble(), _audioWaveform[i]);
            }),
            isCurved: false,
            color: const Color(0xFF2E5AAC),
            barWidth: 1,
            isStrokeCapRound: false,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF2E5AAC).withOpacity(0.1),
            ),
          ),
        ],
        // 標記吞嚥時間點
        extraLinesData: ExtraLinesData(
          verticalLines: _swallowTimes.map((time) {
            // 將時間（秒）轉換為波形圖x坐標
            double x = time * _sampleRate;
            // 限制在波形範圍內
            if (x >= 0 && x < _audioWaveform.length) {
              return VerticalLine(
                x: x,
                color: Colors.red.withOpacity(0.7),
                strokeWidth: 2,
                label: VerticalLineLabel(
                  show: true,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    backgroundColor: Colors.white.withOpacity(0.7),
                  ),
                  alignment: Alignment.topCenter,
                  labelResolver: (line) => '吞嚥',
                ),
              );
            } else {
              // 如果超出範圍，返回null
              return null;
            }
          }).whereType<VerticalLine>().toList(),
        ),
      ),
    );
  }
}