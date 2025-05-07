import 'dart:async';
import 'dart:math';
import '../body_view/assembly.dart';
import 'package:audioplayers/audioplayers.dart';//播放音檔
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../app_state.dart';
import '../../trainmouth/trainmouth_widget.dart';
import '../camera_view.dart';
import '../painters/pose_painter.dart';
import 'package:http/http.dart' as http;
import '/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class head_turn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<head_turn> {
  final PoseDetector _poseDetector =
  PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  Detector_head_turn Det = Detector_head_turn();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();

    // 停止所有计时器和提醒
    Det.stopReminder();
    Det.stopReminder2();

    // 停止所有音频播放
    Det._isDisposed = true;  // 確保在Det類中添加此標誌

    // 在新版本的audioplayers中，AudioCache不再有clearAll方法
    // 而且也沒有fixedPlayer屬性
    // 正確的做法是停止和釋放AudioPlayer
    try {
      await Det._audioPlayer.stop();
      await Det._audioPlayer.dispose();
    } catch (e) {
      print('停止音頻播放失敗: $e');
    }

    // 取消所有可能正在运行的Timer
    if (Det.reminderTimer != null) {
      Det.reminderTimer!.cancel();
      Det.reminderTimer = null;
    }

    if (Det.reminderTimer2 != null) {
      Det.reminderTimer2!.cancel();
      Det.reminderTimer2 = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        CameraView(
          //相機view
          title: 'Pose',
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage) {
            processImage(inputImage);
          },
        ),
        if (!Det.changeUI) ...[
          Positioned(
            //倒數計時
              top: 180,
              child: Container(
                height: 120,
                width: 100,
                child: AutoSizeText(
                  "${Det.mathText}",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontSize: 100,
                    color: Colors.amber,
                    inherit: false,
                  ),
                ),
              )),
          Positioned(
            //開始前提醒視窗
            bottom: 100.0,
            child: Container(
              width: 1000,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                color: Color.fromARGB(132, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: AutoSizeText(
                Det.mindText,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                  backgroundColor: Colors.transparent,
                  fontSize: 25,
                  color: Colors.black,
                  height: 1.2,
                  inherit: false,
                ),
              ),
            ),
          ).animate().slide(duration: 500.ms),
          if (Det.buttom_false)
            Positioned(
              //復健按鈕
                bottom: 15.0,
                child: Container(
                  height: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      padding: EdgeInsets.all(15),
                      backgroundColor: Color.fromARGB(250, 255, 190, 52),
                    ),
                    child: AutoSizeText("Start!",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        )),
                    onPressed: () {
                      Det.startd();
                    },
                  ),
                )).animate().slide(duration: 500.ms),
        ] else if (!Det.endDetector) ...[
          Positioned(
            //計數器UI
            bottom: 10,
            right: -10,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                color: Color.fromARGB(250, 65, 64, 64),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(0),
                ),
              ),
              width: 100,
              height: 90,
              child: AutoSizeText(
                "次數\n${Det.posecounter}/${Det.poseTarget}",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(250, 255, 190, 52),
                  height: 1.2,
                  inherit: false,
                ),
              ),
            ),
          ),
          if (Det.timerui)
            Positioned(
              //計時器UI
              bottom: 10,
              left: -10,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  color: Color.fromARGB(250, 65, 64, 64),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(0),
                    right: Radius.circular(20),
                  ),
                ),
                width: 100,
                height: 90,
                child: AutoSizeText(
                  "秒數\n${Det.posetimecounter}/${Det.posetimeTarget}",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(250, 255, 190, 52),
                    height: 1.2,
                    inherit: false,
                  ),
                ),
              ),
            ),
          Positioned(
            //提醒視窗
            bottom: 100,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: new BoxDecoration(
                color: Color.fromARGB(250, 65, 64, 64),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(30),
                ),
              ),
              width: 220,
              height: 100,
              child: AutoSizeText(
                "${Det.orderText}",
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  height: 1.2,
                  inherit: false,
                ),
              ),
            ),
          )
        ],
        if (Det.endDetector)
          Positioned( //退出視窗
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(200, 65, 64, 64),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "恭喜完成!!",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          inherit: false,
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          padding: EdgeInsets.all(15),
                          backgroundColor: Color.fromARGB(250, 255, 190, 52),
                        ),
                        child: AutoSizeText(
                          "返回",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          endout10();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ).animate().slide(duration: 500.ms),
      ],
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
          poses, inputImage.metadata!.size, inputImage.metadata!.rotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

class Detector_head_turn {
  int posetimecounter = 0; //復健動作持續秒數
  int posetimeTarget = 10; //復健動作持續秒數目標
  int posecounter = 0; //復健動作實作次數
  int poseTarget = 4; //目標次數設定
  bool startdDetector = false; //偵測
  bool endDetector = false; //跳轉
  bool DetectorED = false;
  bool timerbool=true;//倒數計時器
  double? Standpoint_X = 0;
  double? Standpoint_Y = 0;
  double? Standpoint_bodymind_x = 0;//身體終點
  double? Standpoint_bodymind_y = 0;//身體終點
  String orderText = "";//目標提醒
  String mathText = "";//倒數文字
  String instructionText = ""; // 指示文本
  bool buttom_false = true;//按下按鈕消失
  bool changeUI = false;
  bool right_side =true;
  bool timerui = true;
  bool sound = true;
  String mindText = "請將全身拍攝於畫面內\n並維持手機直立\n準備完成請按「Start」";
  final AudioCache player = AudioCache();
  final AudioPlayer _audioPlayer = AudioPlayer();//播放音檔
  Timer? reminderTimer; // 用於定時提示
  Timer? reminderTimer2; // 用於定時提示
  bool _isDisposed = false;
  String _languagePreference = 'chinese'; // 預設為中文

  Future<void> initialize() async {
    await _loadLanguagePreference();
  }

  // 從 SharedPreferences 載入語言偏好設定
  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _languagePreference = prefs.getString('language_preference') ?? 'chinese';
  }

  // 獲取音頻目錄路徑
  String getAudioPath() {
    // 根據語言偏好選擇目錄
    if (_languagePreference == 'taiwanese') {
      return 'taigi_pose_audios'; // 台語
    } else {
      return 'pose_audios'; // 預設中文
    }
  }

  String getAudioDataForm() {
    // 根據語言偏好選擇目錄
    if (_languagePreference == 'taiwanese') {
      return 'wav'; // 台語
    } else {
      return 'mp3'; // 預設中文
    }
  }


  void startd(){//倒數計時
    int counter = 5;
    buttom_false = false;
    Timer.periodic(//觸發偵測timer
      const Duration(seconds: 1),
          (timer) {
        mathText = "${counter--}";
        if(counter<0){
          print("cancel timer");
          timer.cancel();
          mathText = " ";
          startD();
        }
      },
    );
  }

  void startD() {
    //開始辨識
    this.changeUI = true;
    this.startdDetector = true;
    print("startdDetector be true");
    setStandpoint();
    settimer();
    // posesounder(false);
    startReminder();
    startReminder2();
  }

  void poseDetector() {
    //偵測判定
    // if(distance(Standpoint_bodymind_x!, Standpoint_bodymind_y!,
    //     (posedata[22]!+posedata[24]!)/2, (posedata[23]!+posedata[25]!)/2)>110&&this.startdDetector){//身體中點與標準點距離
    //   this.orderText = "側傾過大";
    //   stopReminder(); // 動作不正确，停止提醒
    //   return ;
    // }
    if (this.startdDetector) {
      DetectorED = true;
      if(right_side){
        this.orderText = "請向右轉頭";
        if (this.posetimecounter == this.posetimeTarget) {
          //秒數達成
          this.startdDetector = false;
          this.posecounter++;
          this.posetimecounter = 0;
          this.orderText = "達標!";
          this.sounder(this.posecounter);
          this.right_side = false;
          startReminder();
        }
        if (xDistance(posedata[0]!, posedata[1]!, posedata[24]!, posedata[25]!) < 120
            &&(xDistance(posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
                &&this.startdDetector)) {
          //每秒目標
          this.posetimecounter++;
          print(this.posetimecounter);
          this.orderText = "請保持住!";
          sound = true;
          stopReminder();
        }
        else {
          //沒有保持
          this.posetimecounter = 0;
          this.sounder(999);
        }
      }
      else {
        this.orderText = "請向左轉頭";
        if (this.posetimecounter == this.posetimeTarget) {
          //秒數達成
          this.startdDetector = false;
          this.posecounter++;
          this.posetimecounter = 0;
          this.orderText = "達標!";
          this.sounder(this.posecounter);
          this.right_side = true;
          posesounder(true);
          startReminder();
        }
        if (xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!) < 120
            &&(xDistance(posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
                &&this.startdDetector)) {
          //每秒目標
          this.posetimecounter++;
          print(this.posetimecounter);
          this.orderText = "請保持住!";
          stopReminder();
          sound = true;
        } else {
          //沒有保持
          this.posetimecounter = 0;
          this.sounder(999);
        }
      }
    }else if (DetectorED) {
      //預防空值被訪問
      if (xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!)>230) {
        //確認復歸
        this.startdDetector = true;
        posesounder(false);
      } else {
        this.orderText = "請面對前方";
      }
    }
  }

  void setStandpoint() {
    //設定基準點(左上角為(0,0)向右下)
    this.Standpoint_X = posedata[22]! - 20;
    this.Standpoint_Y = posedata[23]! - 20;
    this.Standpoint_bodymind_x = (posedata[22]!+posedata[24]!)/2;
    this.Standpoint_bodymind_y = (posedata[23]!+posedata[25]!)/2;
  }

  void posetargetdone() {
    //完成任務後發出退出信號
    if (this.posecounter == this.poseTarget) {
      this.endDetector = true;
      stopReminder();
      stopReminder2();
      sound = false;
    }
  }

  double xDistance(double x1,double y1,double x2,double y2){
    return (x2 - x1).abs();
  }

  double distance(double x1,double y1,double x2,double y2){
    return sqrt(pow((x1-x2).abs(),2)+pow((y1-y2).abs(),2));
  }

  double angle(double x1,double y1,double x2,double y2,double x3,double y3){
    double vx1= x1-x2;
    double vy1= y1-y2;
    double vx2= x3-x2;
    double vy2= y3-y2;
    double porduct = vx1*vx2+vy1*vy2;
    double result = acos(porduct/(distance(x1, y1, x2, y2)*distance(x3, y3, x2, y2)))*57.3;
    print(result);
    return result;
  }

  void settimer(){
    Timer.periodic(//觸發偵測timer
      const Duration(seconds: 1),
          (timer) {
        poseDetector(); //偵測目標是否完成動作
        posetargetdone(); //偵測目標是否完成指定次數
        if(!this.timerbool){
          print("cancel timer");
          timer.cancel();
          stopReminder();
          stopReminder2();
        }
      },
    );
  }

  void sounder(int counter){
    if (_isDisposed) return;
    _loadLanguagePreference();
    if(counter == 999 && sound){
      if (right_side && startdDetector) {
        _audioPlayer.play(AssetSource('${getAudioPath()}/upper/TurnHead_right.${getAudioDataForm()}'));
        sound = false;
        startReminder();
      }else if(!right_side && startdDetector){
        _audioPlayer.play(AssetSource('${getAudioPath()}//upper/TurnHead_left.${getAudioDataForm()}'));
        sound = false;
        startReminder();
      }
    }else
      _audioPlayer.play(AssetSource('${getAudioPath()}/${counter}.${getAudioDataForm()}'));
  }


  Future<void> posesounder(bool BOO) async {
    await Future.delayed(Duration(seconds: 1));
    if (BOO) {
      await _loadLanguagePreference(); // 確保獲取最新設定
      String audioPath = '${getAudioPath()}/done.${getAudioDataForm()}';
      await _audioPlayer.play(AssetSource(audioPath));
    }
  }
  void startReminder() {
    // 确保之前的定时器被取消
    stopReminder();
    int counter = 0; // 新建一个计数器

    reminderTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // 播放音频
      // if(xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!)>230) {
      if (startdDetector) {
        if (right_side && xDistance(posedata[0]!, posedata[1]!, posedata[24]!, posedata[25]!)>230) {
          _audioPlayer.play(AssetSource('pose_audios/upper/TurnHead_right.mp3'));
        } else if(!right_side && xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!)>230) {
          _audioPlayer.play(AssetSource('pose_audios/upper/TurnHead_left.mp3'));
        }
      }
      // }
      // 每5秒归零并打印当前计数
      print("计数器归零前的计数: $counter");
      counter = 0; // 归零计数器

      // 如果需要，可以在这里执行其他逻辑
      print("计数器已归1");
    });
  }

  void stopReminder() {
    reminderTimer?.cancel();
    reminderTimer = null; // 确保不再使用
  }
  void startReminder2() {
    // 确保之前的定时器被取消
    stopReminder2();
    int counter = 0; // 新建一个计数器

    reminderTimer2 = Timer.periodic(const Duration(seconds: 2), (timer) async{
      // 播放音频

      if (right_side) {
        if (xDistance(
            posedata[0]!, posedata[1]!, posedata[24]!, posedata[25]!) < 120
            && (xDistance(
                posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
                && this.startdDetector)) {
          _audioPlayer.play(AssetSource('pose_audios/please_keep_it.mp3'));
        }
      }
      else {
        if(xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!) < 120
            &&(xDistance(posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
                &&this.startdDetector))
          _audioPlayer.play(AssetSource('pose_audios/please_keep_it.mp3'));
      }
      // 每5秒归零并打印当前计数
      print("计数器归零前的计数: $counter");
      counter = 0; // 归零计数器

      // 如果需要，可以在这里执行其他逻辑
      print("计数器已归2");
    });
  }
  void stopReminder2() {
    reminderTimer2?.cancel();
    reminderTimer2 = null; // 确保不再使用
  }

}

Future<void> endout10() async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  var url;
  if(Face_Detect_Number==10){                //頭側彎
    url = Uri.parse(ip+"train_mouthok.php");
    print("初階,吞嚥");
  }
  final responce = await http.post(url,body:{
    "time": formattedDate,
    "account": FFAppState().accountnumber.toString(),
    "action": FFAppState().mouth.toString(), //動作
    "degree": "初階",
    "parts": "吞嚥",
    "times": "1", //動作
    "coin_add": "5",
  });
  if (responce.statusCode == 200) {
    print("ok");
  } else {
    print(responce.statusCode);
    print("no");
  }
}



// import 'dart:async';
// import 'dart:io' as io;
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import '../../flutter_flow/flutter_flow_util.dart';
// import '../../main.dart';
// import '../../trainmouth/trainmouth_widget.dart';
// import 'camera_view.dart';
// import 'painters/label_detector_painter.dart';
// import 'package:audioplayers/audioplayers.dart';//播放音檔
// import 'package:http/http.dart' as http;
// export '../camera_view.dart';
// export '../painters/pose_painter.dart';
//
// class open_mouth extends StatefulWidget {
//   @override
//   State<open_mouth> createState() => _ImageLabelViewState();
// }
//
// class _ImageLabelViewState extends State<open_mouth>{
//   late ImageLabeler _imageLabeler;
//   bool _canProcess = false;
//   bool _isBusy = false;
//   Detector_open_mouth smile = Detector_open_mouth();
//   CustomPaint? _customPaint;
//   String? _text;
//   @override
//   void initState() {
//     super.initState();
//     _initializeLabeler();
//   }
//
//   @override
//   void dispose() {
//     _canProcess = false;
//     _imageLabeler.close();
//     smile.timerbool = false; //關閉timer
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       fit: StackFit.expand,
//       children: <Widget>[
//         CameraView(
//           title: 'Image Labeler',
//           customPaint: _customPaint,
//           text: _text,
//           onImage: processImage,
//         ),
//         if (!smile.changeUI) ...[
//           Positioned(
//             //倒數計時
//               top: 180,
//               child: Container(
//                 height: 120,
//                 width: 100,
//                 child: AutoSizeText(
//                   "${smile.mathText}",
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   style: TextStyle(
//                     backgroundColor: Colors.transparent,
//                     fontSize: 100,
//                     color: Colors.amber,
//                     inherit: false,
//                   ),
//                 ),
//               )),
//           Positioned(
//             //開始前提醒視窗
//             bottom: 100.0,
//             child: Container(
//               width: 1000,
//               padding: EdgeInsets.all(10),
//               alignment: Alignment.center,
//               decoration: new BoxDecoration(
//                 color: Color.fromARGB(132, 255, 255, 255),
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//               ),
//               child: AutoSizeText(
//                 smile.mindText,
//                 textAlign: TextAlign.center,
//                 maxLines: 3,
//                 style: TextStyle(
//                   backgroundColor: Colors.transparent,
//                   fontSize: 25,
//                   color: Colors.black,
//                   height: 1.2,
//                   inherit: false,
//                 ),
//               ),
//             ),
//           ).animate().slide(duration: 500.ms),
//           if (smile.buttom_false)
//             Positioned(
//               //復健按鈕
//                 bottom: 15.0,
//                 child: Container(
//                   height: 80,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(50)),
//                       ),
//                       padding: EdgeInsets.all(15),
//                       backgroundColor: Color.fromARGB(250, 255, 190, 52),
//                     ),
//                     child: AutoSizeText("Start!",
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontSize: 35,
//                           color: Colors.white,
//                         )),
//                     onPressed: () {
//                       smile.startd();
//                     },
//                   ),
//                 )).animate().slide(duration: 500.ms),
//         ] else if (!smile.endDetector) ...[
//           Positioned(
//             //計數器UI
//             bottom: 10,
//             right: -10,
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: new BoxDecoration(
//                 color: Color.fromARGB(250, 65, 64, 64),
//                 borderRadius: BorderRadius.horizontal(
//                   left: Radius.circular(20),
//                   right: Radius.circular(0),
//                 ),
//               ),
//               width: 100,
//               height: 90,
//               child: AutoSizeText(
//                 "次數\n${smile.posecounter}/${smile.posecounter}",
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 25,
//                   color: Color.fromARGB(250, 255, 190, 52),
//                   height: 1.2,
//                   inherit: false,
//                 ),
//               ),
//             ),
//           ),
//           if (smile.timerui)
//             Positioned(
//               //計時器UI
//               bottom: 10,
//               left: -10,
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: new BoxDecoration(
//                   color: Color.fromARGB(250, 65, 64, 64),
//                   borderRadius: BorderRadius.horizontal(
//                     left: Radius.circular(0),
//                     right: Radius.circular(20),
//                   ),
//                 ),
//                 width: 100,
//                 height: 90,
//                 child: AutoSizeText(
//                   "秒數\n${smile.posetimecounter}/${smile.posetimecounter}",
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   style: TextStyle(
//                     fontSize: 25,
//                     color: Color.fromARGB(250, 255, 190, 52),
//                     height: 1.2,
//                     inherit: false,
//                   ),
//                 ),
//               ),
//             ),
//           Positioned(
//             //提醒視窗
//             bottom: 100,
//             child: Container(
//               padding: EdgeInsets.all(30),
//               decoration: new BoxDecoration(
//                 color: Color.fromARGB(250, 65, 64, 64),
//                 borderRadius: BorderRadius.horizontal(
//                   left: Radius.circular(30),
//                   right: Radius.circular(30),
//                 ),
//               ),
//               width: 220,
//               height: 100,
//               child: AutoSizeText(
//                 "${smile.orderText}",
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 style: TextStyle(
//                   fontSize: 28,
//                   color: Colors.white,
//                   height: 1.2,
//                   inherit: false,
//                 ),
//               ),
//             ),
//           )
//               .animate(onPlay: (controller) => controller.repeat())
//               .scaleXY(end: 1.2, duration: 0.2.seconds),
//         ],
//         if (smile.endDetector)
//           Positioned( //退出視窗
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(40),
//                   decoration: new BoxDecoration(
//                     color: Color.fromARGB(200, 65, 64, 64),
//                     borderRadius: BorderRadius.all(Radius.circular(30)),
//                   ),
//                   width: 300,
//                   height: 300,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       AutoSizeText(
//                         "恭喜完成!!",
//                         maxLines: 1,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 50,
//                           color: Colors.white,
//                           inherit: false,
//                         ),
//                       ),
//                       SizedBox(height: 20,),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(50)),
//                           ),
//                           padding: EdgeInsets.all(15),
//                           backgroundColor: Color.fromARGB(250, 255, 190, 52),
//                         ),
//                         child: AutoSizeText(
//                           "返回",
//                           maxLines: 1,
//                           style: TextStyle(
//                             fontSize: 30,
//                             color: Colors.white,
//                           ),
//                         ),
//                         onPressed: () async {
//                           endout10();
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ).animate().slide(duration: 500.ms),
//       ],
//     );
//   }
//
//
//
//
//
//
//   void _initializeLabeler() async {
//     // uncomment next line if you want to use the default model
//     // _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
//
//     // uncomment next lines if you want to use a local model
//     // make sure to add tflite model to assets/ml
//     // final path = 'assets/ml/lite-model_aiy_vision_classifier_birds_V1_3.tflite';
//     final path = 'assets/ml/face_six_detector.tflite';
//     final modelPath = await _getModel(path);
//     final options = LocalLabelerOptions(modelPath: modelPath);
//     _imageLabeler = ImageLabeler(options: options);
//
//     // uncomment next lines if you want to use a remote model
//     // make sure to add model to firebase
//     // final modelName = 'bird-classifier';
//     // final response =
//     //     await FirebaseImageLabelerModelManager().downloadModel(modelName);
//     // print('Downloaded: $response');
//     // final options =
//     //     FirebaseLabelerOption(confidenceThreshold: 0.5, modelName: modelName);
//     // _imageLabeler = ImageLabeler(options: options);
//
//     _canProcess = true;
//   }
//
//   Future<void> processImage(InputImage inputImage) async { //顯示label與閥值
//     if (!_canProcess) return;
//     if (_isBusy) return;
//     _isBusy = true;
//     setState(() {
//       _text = '';
//     });
//     final labels = await _imageLabeler.processImage(inputImage);
//     if (inputImage.metadata?.size != null &&
//         inputImage.metadata?.rotation != null) {
//       final painter = LabelDetectorPainter(labels);
//       _customPaint = CustomPaint(painter: painter);
//     } else {
//       String text = 'Labels found: ${labels.length}\n\n';
//       for (final label in labels) {
//         text += 'Label: ${label.label}, '
//             'Confidence: ${label.confidence.toStringAsFixed(2)}\n\n';
//       }
//       _text = text;
//       _customPaint = null;
//     }
//     _isBusy = false;
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future<String> _getModel(String assetPath) async { //取得模型
//     if (io.Platform.isAndroid) {
//       return 'flutter_assets/$assetPath';
//     }
//     final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
//     await io.Directory(dirname(path)).create(recursive: true);
//     final file = io.File(path);
//     if (!await file.exists()) {
//       final byteData = await rootBundle.load(assetPath);
//       await file.writeAsBytes(byteData.buffer
//           .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//     }
//     return file.path;
//   }
// }
// class Detector_open_mouth {
//   int posetimecounter = 0; //復健動作持續秒數
//   int posetimeTarget = 5; //復健動作持續秒數目標
//   int posecounter = 0; //復健動作實作次數
//   int poseTarget = 4; //目標次數設定
//   bool startdDetector = false; //偵測
//   bool endDetector = false; //跳轉
//   bool DetectorED = false;
//   bool timerbool=true;//倒數計時器
//   double? Standpoint_X = 0;
//   double? Standpoint_Y = 0;
//   double? Standpoint_bodymind_x = 0;//身體終點
//   double? Standpoint_bodymind_y = 0;//身體終點
//   String orderText = "";//目標提醒
//   String mathText = "";//倒數文字
//   String instructionText = ""; // 指示文本
//   bool buttom_false = true;//按下按鈕消失
//   bool changeUI = false;
//   bool right_side =true;
//   bool timerui = true;
//   bool sound = true;
//   String mindText = "請將全身拍攝於畫面內\n並維持手機直立\n準備完成請按「Start」";
//   final AudioCache player = AudioCache();
  final AudioPlayer _audioPlayer = AudioPlayer();//播放音檔
//   Timer? reminderTimer; // 用於定時提示
//   Timer? reminderTimer2; // 用於定時提示
//   void startd(){//倒數計時
//     int counter = 5;
//     buttom_false = false;
//     Timer.periodic(//觸發偵測timer
//       const Duration(seconds: 1),
//           (timer) {
//         mathText = "${counter--}";
//         if(counter<0){
//           print("cancel timer");
//           timer.cancel();
//           mathText = " ";
//           startD();
//         }
//       },
//     );
//   }
//
//   void startD() {
//     //開始辨識
//     this.changeUI = true;
//     this.startdDetector = true;
//     print("startdDetector be true");
//     setStandpoint();
//     settimer();
//     // posesounder(false);
//     startReminder();
//     startReminder2();
//   }
//
//   void poseDetector() {
//     //偵測判定
//     // if(distance(Standpoint_bodymind_x!, Standpoint_bodymind_y!,
//     //     (posedata[22]!+posedata[24]!)/2, (posedata[23]!+posedata[25]!)/2)>110&&this.startdDetector){//身體中點與標準點距離
//     //   this.orderText = "側傾過大";
//     //   stopReminder(); // 動作不正确，停止提醒
//     //   return ;
//     // }
//     if (this.startdDetector) {
//       DetectorED = true;
//       if(right_side){
//         this.orderText = "請向右轉頭";
//         if (this.posetimecounter == this.posetimeTarget) {
//           //秒數達成
//           this.startdDetector = false;
//           this.posecounter++;
//           this.posetimecounter = 0;
//           this.orderText = "達標!";
//           this.sounder(this.posecounter);
//           this.right_side = false;
//           startReminder();
//         }
//         if (xDistance(posedata[0]!, posedata[1]!, posedata[24]!, posedata[25]!) < 120
//             &&(xDistance(posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
//                 &&this.startdDetector)) {
//           //每秒目標
//           this.posetimecounter++;
//           print(this.posetimecounter);
//           this.orderText = "請保持住!";
//           sound = true;
//           stopReminder();
//         } else {
//           //沒有保持
//           this.posetimecounter = 0;
//           this.sounder(999);
//         }
//       }else {
//         this.orderText = "請向左轉頭";
//         if (this.posetimecounter == this.posetimeTarget) {
//           //秒數達成
//           this.startdDetector = false;
//           this.posecounter++;
//           this.posetimecounter = 0;
//           this.orderText = "達標!";
//           this.sounder(this.posecounter);
//           this.right_side = true;
//           posesounder(true);
//           startReminder();
//         }
//         if (xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!) < 120
//             &&(xDistance(posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
//                 &&this.startdDetector)) {
//           //每秒目標
//           this.posetimecounter++;
//           print(this.posetimecounter);
//           this.orderText = "請保持住!";
//           stopReminder();
//           sound = true;
//         } else {
//           //沒有保持
//           this.posetimecounter = 0;
//           this.sounder(999);
//         }
//       }
//     }else if (DetectorED) {
//       //預防空值被訪問
//       if (xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!)>230) {
//         //確認復歸
//         this.startdDetector = true;
//         posesounder(false);
//       } else {
//         this.orderText = "請面對前方";
//       }
//     }
//   }
//
//   void setStandpoint() {
//     //設定基準點(左上角為(0,0)向右下)
//     this.Standpoint_X = posedata[22]! - 20;
//     this.Standpoint_Y = posedata[23]! - 20;
//     this.Standpoint_bodymind_x = (posedata[22]!+posedata[24]!)/2;
//     this.Standpoint_bodymind_y = (posedata[23]!+posedata[25]!)/2;
//   }
//
//   void posetargetdone() {
//     //完成任務後發出退出信號
//     if (this.posecounter == this.poseTarget) {
//       this.endDetector = true;
//       stopReminder();
//       stopReminder2();
//       sound = false;
//     }
//   }
//
//   double xDistance(double x1,double y1,double x2,double y2){
//     return (x2 - x1).abs();
//   }
//
//   double distance(double x1,double y1,double x2,double y2){
//     return sqrt(pow((x1-x2).abs(),2)+pow((y1-y2).abs(),2));
//   }
//
//   double angle(double x1,double y1,double x2,double y2,double x3,double y3){
//     double vx1= x1-x2;
//     double vy1= y1-y2;
//     double vx2= x3-x2;
//     double vy2= y3-y2;
//     double porduct = vx1*vx2+vy1*vy2;
//     double result = acos(porduct/(distance(x1, y1, x2, y2)*distance(x3, y3, x2, y2)))*57.3;
//     print(result);
//     return result;
//   }
//
//   void settimer(){
//     Timer.periodic(//觸發偵測timer
//       const Duration(seconds: 1),
//           (timer) {
//         poseDetector(); //偵測目標是否完成動作
//         posetargetdone(); //偵測目標是否完成指定次數
//         if(!this.timerbool){
//           print("cancel timer");
//           timer.cancel();
//           stopReminder();
//           stopReminder2();
//         }
//       },
//     );
//   }
//
//   void sounder(int counter){
//     if(counter == 999 && sound){
//       if (right_side && startdDetector) {
//         player.play('pose_audios/upper/TurnHead_right.mp3');
//         sound = false;
//         startReminder();
//       }else if(!right_side && startdDetector){
//         player.play('pose_audios/upper/TurnHead_left.mp3');
//         sound = false;
//         startReminder();
//       }
//     }else
//       player.play('pose_audios/${counter}.mp3');
//   }
//
//
//   Future<void> posesounder(bool BOO) async {
//     await Future.delayed(Duration(seconds: 1));
//     if (BOO) {
//       player.play('pose_audios/done.mp3');
//     }
//     // if (startdDetector) {
//     //   if (right_side) {
//     //     player.play('pose_audios/upper/TurnHead_right.mp3');
//     //   } else {
//     //     player.play('pose_audios/upper/TurnHead_left.mp3');
//     //   }
//     // }
//   }
//   void startReminder() {
//     // 确保之前的定时器被取消
//     stopReminder();
//     int counter = 0; // 新建一个计数器
//
//     reminderTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       // 播放音频
//       if(xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!)>230) {
//         if (startdDetector) {
//           if (right_side) {
//             player.play('pose_audios/upper/TurnHead_right.mp3');
//           } else {
//             player.play('pose_audios/upper/TurnHead_left.mp3');
//           }
//         }
//       }
//       // 每5秒归零并打印当前计数
//       print("计数器归零前的计数: $counter");
//       counter = 0; // 归零计数器
//
//       // 如果需要，可以在这里执行其他逻辑
//       print("计数器已归1");
//     });
//   }
//
//   void stopReminder() {
//     reminderTimer?.cancel();
//     reminderTimer = null; // 确保不再使用
//   }
//   void startReminder2() {
//     // 确保之前的定时器被取消
//     stopReminder2();
//     int counter = 0; // 新建一个计数器
//
//     reminderTimer2 = Timer.periodic(const Duration(seconds: 2), (timer) async{
//       // 播放音频
//
//       if (right_side) {
//         if (xDistance(
//             posedata[0]!, posedata[1]!, posedata[24]!, posedata[25]!) < 120
//             && (xDistance(
//                 posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
//                 && this.startdDetector)) {
//           player.play('pose_audios/please_keep_it.mp3');
//         }
//       }
//       else {
//         if(xDistance(posedata[0]!, posedata[1]!, posedata[22]!, posedata[23]!) < 120
//             &&(xDistance(posedata[4]!, posedata[5]!, posedata[10]!, posedata[11]!) < 70
//                 &&this.startdDetector))
//           player.play('pose_audios/please_keep_it.mp3');
//       }
//       // 每5秒归零并打印当前计数
//       print("计数器归零前的计数: $counter");
//       counter = 0; // 归零计数器
//
//       // 如果需要，可以在这里执行其他逻辑
//       print("计数器已归2");
//     });
//   }
//   void stopReminder2() {
//     reminderTimer2?.cancel();
//     reminderTimer2 = null; // 确保不再使用
//   }
//
// }
//
//
// Future<void> endout10() async {
//   DateTime now = DateTime.now();
//   String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//   var url;
//   if(Face_Detect_Number==10){                //抿嘴
//     url = Uri.parse(ip+"train_mouthok.php");
//     print("初階,吞嚥");
//   }
//   final responce = await http.post(url,body:{
//     "time": formattedDate,
//     "account": FFAppState().accountnumber.toString(),
//     "action": FFAppState().mouth.toString(), //動作
//     "degree": "初階",
//     "parts": "吞嚥",
//     "times": "1", //動作
//     "coin_add": "5",
//   });
//   if (responce.statusCode == 200) {
//     print("ok");
//   } else {
//     print(responce.statusCode);
//     print("no");
//   }
// }