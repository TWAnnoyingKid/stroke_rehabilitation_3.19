import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'audio_processor.dart';

class SwallowDetector {
  late final OrtSession _session;
  bool _initialized = false;

  final double _threshold      = 0.6;  // 吞嚥判定閾值
  final double _minStartTime   = 1.0;  // 忽略前 1 秒
  final double _cooldownPeriod = 1.0;  // 冷卻期長度

  /// 初始化 ONNX Runtime 環境並載入模型
  Future<void> init() async {
    if (_initialized) return;
    // 1) 初始化 ORT 環境（無回傳值）
    OrtEnv.instance.init();  // :contentReference[oaicite:1]{index=1}

    // 2) 讀取模型 bytes
    final raw = await rootBundle.load(
        'assets/model/rsst_integrated_2k2_cnn_att2_2_ir9.onnx'
    );
    final modelBytes = raw.buffer.asUint8List();

    // 3) 建立 Session
    _session = OrtSession.fromBuffer(
      modelBytes,
      OrtSessionOptions(),
    );
    _initialized = true;
  }

  /// 針對一系列 AudioSegment 執行吞嚥偵測
  Future<Map<String, dynamic>> detectSwallows(
      List<AudioSegment> segments
      ) async {
    await init();

    List<double> swallowTimes = [];
    List<double> swallowProbs = [];
    bool inCooldown = false;
    double cooldownEnd = 0.0;

    for (var seg in segments) {
      final ts = seg.startTime;
      if (ts < _minStartTime) continue;
      if (inCooldown && ts < cooldownEnd) continue;
      inCooldown = false;

      // 1) 讀取並解析 PCM
      final bytes = await File(seg.path).readAsBytes();
      final wavInfo = AudioProcessor.parseWavHeader(bytes);
      final pcm = bytes.sublist(wavInfo['headerSize'] as int);
      final floatData = AudioProcessor.convertPcmToFloat(
        pcm,
        wavInfo['channels'] as int,
        wavInfo['bitsPerSample'] as int,
      );
      final List<double> dbl = floatData.toList();

      // 2) 建立輸入張量
      final tensor = OrtValueTensor.createTensorWithDataList(
        Float32List.fromList(dbl.map((e) => e.toDouble()).toList()),
        [1, dbl.length],
      );

      // 3) 非同步推論
      final inputs = <String, OrtValue>{'input': tensor};
      final runOpts = OrtRunOptions();
      final outputs = await _session.runAsync(runOpts, inputs) ?? [];
      runOpts.release();

      if (outputs.isEmpty) {
        tensor.release();
        throw Exception('模型無輸出');
      }

      // 4) 取回結果並 sigmoid
      final outVal = outputs[0] as OrtValueTensor;
      final resultData = outVal.value as List<dynamic>;
      double raw;

// 檢查實際類型並正確提取值
      if (resultData[0] is List) {
        // 如果是嵌套列表，提取第一個元素
        raw = (resultData[0] as List<dynamic>)[0].toDouble();
      } else if (resultData[0] is num) {
        // 如果直接是數字，直接轉換
        raw = (resultData[0] as num).toDouble();
      } else {
        // 記錄未知類型情況
        throw Exception('意外的模型輸出類型: ${resultData[0].runtimeType}');
      }

      final prob = 1 / (1 + exp(-raw));

      // 5) 釋放資源
      tensor.release();
      outVal.release();

      // 6) 閾值與冷卻邏輯
      if (prob > _threshold) {
        swallowTimes.add(ts);
        swallowProbs.add(prob);
        inCooldown = true;
        cooldownEnd = ts + _cooldownPeriod;
      }
    }

    return {
      'swallowTimes': swallowTimes,
      'swallowProbs': swallowProbs,
      'swallowCount': swallowTimes.length,
    };
  }

  /// 釋放資源
  void dispose() {
    if (_initialized) {
      _session.release();
      OrtEnv.instance.release();
    }
  }
}
