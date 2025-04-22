import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  String? _recordingPath;
  int _sampleRate = 44100;
  Completer<void>? _initCompleter;

  // 建構函數
  AudioRecorder();

  // 獲取錄音路徑
  String? get recordingPath => _recordingPath;

  // 初始化錄音機
  Future<void> init() async {
    // 如果已經在初始化中，返回相同的 Future
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<void>();

    try {
      if (_isRecorderInitialized) {
        _initCompleter!.complete();
        return _initCompleter!.future;
      }

      _audioRecorder = FlutterSoundRecorder();
      print('創建 FlutterSoundRecorder 實例');

      // 請求錄音權限
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('麥克風權限未授予');
      }
      print('麥克風權限已授予');

      // 開啟錄音機
      await _audioRecorder!.openRecorder();
      print('錄音機已開啟');

      _isRecorderInitialized = true;
      _initCompleter!.complete();
    } catch (e) {
      print('初始化錄音機失敗: $e');
      _initCompleter!.completeError(e);
    }

    return _initCompleter!.future;
  }

  // 開始錄音
  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      await init();
    }

    // 確保錄音機已初始化
    if (!_isRecorderInitialized) {
      throw RecordingPermissionException('錄音機未初始化');
    }

    // 如果已經在錄音，先停止
    if (_isRecording) {
      await stopRecording();
    }

    // 創建檔案路徑
    final directory = await getApplicationDocumentsDirectory();
    _recordingPath = '${directory.path}/rsst_recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    print('檔案將保存至: $_recordingPath');

    try {
      // 開始錄音
      await _audioRecorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.pcm16WAV,
        sampleRate: _sampleRate,
        numChannels: 1, // 單聲道
      );

      print('錄音開始');
      _isRecording = true;
    } catch (e) {
      print('開始錄音失敗: $e');
      throw Exception('開始錄音失敗: $e');
    }
  }

  // 停止錄音
  Future<String?> stopRecording() async {
    if (!_isRecording) {
      return _recordingPath;
    }

    try {
      print('正在停止錄音...');
      await _audioRecorder!.stopRecorder();
      _isRecording = false;
      print('錄音完成，檔案儲存於: $_recordingPath');
      return _recordingPath;
    } catch (e) {
      print('停止錄音出錯: $e');
      _isRecording = false;
      return _recordingPath;
    }
  }

  // 釋放資源
  Future<void> dispose() async {
    try {
      if (_isRecording) {
        await stopRecording();
      }

      if (_isRecorderInitialized) {
        await _audioRecorder!.closeRecorder();
        _audioRecorder = null;
        _isRecorderInitialized = false;
        print('錄音機資源已釋放');
      }
    } catch (e) {
      print('釋放錄音機資源時出錯: $e');
    }
  }
}

// 自定義例外
class RecordingPermissionException implements Exception {
  final String message;
  RecordingPermissionException(this.message);

  @override
  String toString() => 'RecordingPermissionException: $message';
}