import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../trainmouth/trainmouth_widget.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../../flutter_flow/flutter_flow_util.dart';

/// **第一個畫面：讓使用者選擇 PA、TA、KA**
class speech extends StatefulWidget {
  const speech({super.key});

  @override
  State<speech> createState() => _speechState();
}

class _speechState extends State<speech> {
  // 用於追蹤已完成的音素測試
  final Map<String, int> completedPhonemes = {
    "PA": 0,
    "TA": 0,
    "KA": 0
  };

  void _navigateToDetectionScreen(BuildContext context, String phoneme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SoundDetectionScreen(
          selectedPhoneme: phoneme,
          onComplete: (wordCount) {
            setState(() {
              completedPhonemes[phoneme] = wordCount;
            });
          },
        ),
      ),
    );
  }

  // 檢查是否已完成所有測試
  bool _allTestsCompleted() {
    return completedPhonemes.values.every((count) => count > 0);
  }

  // 顯示結果畫面
  void _showResults(BuildContext context) {
    // 計算總字數
    int totalWordCount = completedPhonemes.values.reduce((a, b) => a + b);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetectionResultScreen(detectedWordCount: totalWordCount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 上方藍色標題區塊
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20), // 增加垂直間距
            color: Colors.blue[500]!,
            child: Row(
              children: [
                // 左邊的圖示
                Image.asset(
                  'assets/images/58.png', // 你的圖片路徑
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                // 右邊的標題文字
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "訓練音節",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 主內容區塊
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "請依序測試以下三個音節",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPhonemeButton(context, "PA"),
                      const SizedBox(width: 20),
                      _buildPhonemeButton(context, "TA"),
                      const SizedBox(width: 20),
                      _buildPhonemeButton(context, "KA"),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // 顯示已完成的測試
                  Text(
                    "已完成：${completedPhonemes.entries.where((e) => e.value > 0).map((e) => e.key).join(', ')}",
                    style: TextStyle(fontSize: 18, color: Colors.blue[700]),
                  ),
                  const SizedBox(height: 20),
                  // 顯示查看結果按鈕，只有在完成所有測試後才啟用
                  ElevatedButton(
                    onPressed: _allTestsCompleted()
                        ? () => _showResults(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("查看最終結果"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhonemeButton(BuildContext context, String phoneme) {
    // 已完成的按鈕使用不同顏色顯示
    final bool isCompleted = completedPhonemes[phoneme]! > 0;

    return GestureDetector(
      onTap: () => _navigateToDetectionScreen(context, phoneme),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green[300]! : Colors.blue[300]!,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(2, 4), // 陰影方向
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                phoneme,
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              if (isCompleted)
                Icon(Icons.check, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// **第二個畫面：偵測聲音**
class SoundDetectionScreen extends StatefulWidget {
  final String selectedPhoneme;
  final Function(int) onComplete; // 新增回調函數，用於報告完成狀態

  const SoundDetectionScreen({
    super.key,
    required this.selectedPhoneme,
    required this.onComplete,
  });

  @override
  State<SoundDetectionScreen> createState() => _SoundDetectionScreenState();
}

class _SoundDetectionScreenState extends State<SoundDetectionScreen>
    with SingleTickerProviderStateMixin {
  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  bool _isListening = false;
  double _soundLevel = 0.0;
  int _wordCount = 0;
  bool _hasAddedWord = false;
  double _dBThreshold = 80.0;

  // 動畫控制
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // 倒數計時
  Timer? _countdownTimer;
  int _remainingTime = 5; // 設定倒數 10 秒

  @override
  void initState() {
    super.initState();
    _requestPermissions();/// 請求麥克風權限

    // 動畫：讓氣泡變大縮小
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),// 動畫時間 500ms
      lowerBound: 1.0,
      upperBound: 2,// 放大 2 倍
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(_animationController);///開始後大小
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _startListening() {
    if (_isListening) return;

    _resetValues();// 重置計數與變數
    _noiseMeter ??= NoiseMeter();

    try {// 開始監聽音量
      _noiseSubscription = _noiseMeter!.noiseStream.listen((noiseEvent) {
        setState(() {
          _soundLevel = noiseEvent.meanDecibel;//更新音量數據

          if (_soundLevel > _dBThreshold) {
            if (!_hasAddedWord) {
              _wordCount++;
              _hasAddedWord = true;
            }
            _animationController.forward();// 氣泡放大
          } else {
            _hasAddedWord = false;
            _animationController.reverse();// 氣泡縮小
          }
        });
      }, onError: (e) {
        debugPrint('噪音偵測錯誤：$e');
        _stopListening();
      });

      // 開始倒數計時
      _startCountdown();
    } catch (e) {
      debugPrint('啟動偵測時發生錯誤：$e');
      _stopListening();
    }

    setState(() => _isListening = true);
  }

  void _stopListening() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
    _noiseMeter = null;
    _countdownTimer?.cancel(); // 停止倒數
    setState(() {
      _isListening = false;
    });
  }

  void _resetValues() {
    setState(() {
      _wordCount = 0;
      _soundLevel = 0.0;
      _hasAddedWord = false;
      _remainingTime = 5; // 重置倒數
    });
  }

  // **開始倒數計時**
  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 1) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _finishTest(); // 完成測試
      }
    });
  }

  // 完成測試，返回上一畫面
  void _finishTest() {
    _stopListening();
    // 回調通知完成了測試並傳遞字數
    widget.onComplete(_wordCount);
    Navigator.pop(context); // 返回上一畫面
  }

  // 計算顏色變化
  Color _getBubbleColor(double dB) {
    if (dB < 60) return Colors.blue[300]!;
    // if (dB < 80) return Colors.orange[300]!;
    return Colors.blue[300]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("測試音節: ${widget.selectedPhoneme}"),
        backgroundColor: Colors.blue[500],
      ),
      body: Column(//內容垂直排列
        mainAxisAlignment: MainAxisAlignment.center,//內容置中對齊
        children: [
          const Spacer(),
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: _getBubbleColor(_soundLevel),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.selectedPhoneme,
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Text(
                        //   "${_soundLevel.toStringAsFixed(1)} ",
                        //   style: const TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.white70,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),///PA,TA,KA按鈕距離
            child: Column(  ///垂直排列Text 和 Slider 兩個元件
              children: [
                Text(
                  "設定偵測門檻：${_dBThreshold.toStringAsFixed(0)} ",///小數店後一位
                  style: const TextStyle(fontSize: 18),///字體大小
                ),
                Slider(     ///滑桿
                  value: _dBThreshold,
                  min: 30,
                  max: 150,
                  divisions: 120,///範圍 切成 120 份，例如:31、32、33dB
                  label: _dBThreshold.toStringAsFixed(1),///滑桿的小數點後一位
                  onChanged: (value) {
                    setState(() {///更新 _dBThreshold 的數值
                      _dBThreshold = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "倒數 $_remainingTime 秒...",
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Text(
            "音節數量: $_wordCount",
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          ),
          const Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: '開始/停止偵測',
        backgroundColor: _isListening ? Colors.red : Colors.blue,
        child: Icon(
          _isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {//取消動作
    _noiseSubscription?.cancel();
    _animationController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }
}

// **偵測結果畫面**
class DetectionResultScreen extends StatelessWidget {
  final int detectedWordCount;

  const DetectionResultScreen({super.key, required this.detectedWordCount});//接收偵測到的字數，並在畫面上顯示。

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text("測試結果"),
        backgroundColor: Colors.blue[500],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/58.png', width: 150),
            const SizedBox(height: 20),
            const Text(
              "恭喜完成所有音節測試！",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '總共檢測到 $detectedWordCount 個音節',
              style: const TextStyle(fontSize: 24, color: Colors.red),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await endout9(totalWordCount: detectedWordCount); // 确保 endout9() 執行完再返回
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainmouthWidget()),
                ); // 重新加载 TrainmouthWidget
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('返回主畫面'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> endout9({required int totalWordCount}) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  var url;
  if(Face_Detect_Number==9){                //抿嘴
    url = Uri.parse(ip+"train_mouthok.php");
    print("初階,吞嚥");
  }
  final responce = await http.post(url,body:{
    "time": formattedDate,
    "account": FFAppState().accountnumber.toString(),
    // "action": FFAppState().mouth.toString(), //動作
    "action": "${FFAppState().mouth.toString()} (${totalWordCount} 次)", // 動作 + 發音練習次數
    "degree": "初階",
    "parts": "吞嚥",
    "times": "1", //動作
    "coin_add": "5",
    "total_word_count": totalWordCount.toString(),
  });
  if (responce.statusCode == 200) {
    print("ok");
  } else {
    print(responce.statusCode);
    print("no");
  }
}