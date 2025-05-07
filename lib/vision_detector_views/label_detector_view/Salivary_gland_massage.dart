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

class Salivary_gland_massage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<Salivary_gland_massage> {
  final PoseDetector _poseDetector =
  PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  salivary_gland_massage Det = salivary_gland_massage();
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    Det.posecounter = 0;  // 使用 Det 物件的 posecounter 屬性
    // Det.stopReminder();
    // Det.stopReminder2();
    posedata.clear(); // 清空 pose 数据
    super.dispose(); // 必须在最后调用
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

        Positioned(
          top:170,  // 根據你的UI調整位置
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(180, 255, 190, 52), width: 3),
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Center(
              child: Icon(
                Icons.face,
                size: 50,
                color: Color.fromARGB(120, 255, 190, 52),
              ),
            ),
          ),
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
                          endout12();
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


class salivary_gland_massage {
  static const double THRESHOLD = 50000; // 距離閾值
  int posetimecounter = 0; //復健動作持續秒數
  int posetimeTarget = 3; //復健動作持續秒數目標
  int posecounter = 0; //復健動作實作次數
  int poseTarget = 10; //目標次數設定
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
  bool buttom_false = true;//按下按鈕消失
  bool changeUI = false;
  bool right_side =true;
  bool timerui = true;
  bool sound = true;
  String mindText = "請將全身拍攝於畫面內\n並維持手機直立\n準備完成請按「Start」";
  String instructionText = "請挺胸";
  final AudioCache player = AudioCache();
  final AudioPlayer _audioPlayer = AudioPlayer();//播放音檔
  Timer? reminderTimer; // 用于定时提示
  Timer? reminderTimer2; // 用於定時提示
  Timer? reminderTimer3; // 用於定時提示
  List<double> noseZHistory = [];
  List<double> leftHandZHistory = [];
  List<double> rightHandZHistory = [];
  int poseStage = 0; // 跟踪动作阶段
  double? initialY; // 记录初始Y位置
  double? initialRightHandY; // 右手初始Y坐标
  double? initialLeftHandY;  // 左手初始Y坐标
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
    // startReminder();//啟動提示
    // startReminder2();
    // startReminder3();
  }


  // void poseDetector() {
  //   double midY = (posedata[19]! + posedata[23]!) / 2;
  //   double midY2 = (posedata[21]! + posedata[25]!) / 2;
  //
  //   // 计算右手和左手的Y坐标
  //   double rightHandY = (posedata[38]! + posedata[39]!) / 2; // 右手Y坐标
  //   double leftHandY = (posedata[40]! + posedata[41]!) / 2; // 左手Y坐标
  //
  //   if (this.endDetector) {
  //     // stopReminder(); // 如果已结束检测，停止提醒
  //     return;
  //   }
  //
  //   bool DetectorED =
  //       ddistance(posedata[38]!, posedata[39]!, posedata[18]!, midY) < THRESHOLD // 右手接近脖子上下
  //           && ddistance(posedata[40]!, posedata[41]!, posedata[20]!, midY2) < THRESHOLD; // 左手接近脖子上下
  //
  //   if (this.startdDetector) {
  //     if (this.poseStage == 0) {
  //       // 预备动作 - 手放脖子
  //       this.orderText = "手請放脖子";
  //
  //       if (DetectorED && this.startdDetector) {
  //         this.orderText = "開始按摩";
  //         this.poseStage = 1; // 直接进入震动阶段
  //
  //         // 记录双手的初始Y位置
  //         if (this.initialRightHandY == null) {
  //           this.initialRightHandY = rightHandY; // 记录右手初始Y位置
  //         }
  //         if (this.initialLeftHandY == null) {
  //           this.initialLeftHandY = leftHandY; // 记录左手初始Y位置
  //         }
  //
  //         this.sounder(0); // 提示音
  //       }
  //     }
  //     else if (this.poseStage == 1) {
  //       // 震动阶段 - 检测双手Y轴震动
  //       double rightHandDiff = (rightHandY - this.initialRightHandY!).abs();
  //       double leftHandDiff = (leftHandY - this.initialLeftHandY!).abs();
  //
  //       // 检测双手是否都有足够的震动
  //       if (rightHandDiff >= 10 && leftHandDiff >= 10) {
  //         // this.orderText = "已偵測到雙手震動";
  //         this.sounder(1); // 提示音
  //         this.poseStage = 2; // 进入返回起始位置阶段
  //       } else {
  //         // this.orderText = "請震動雙手 (右手:${rightHandDiff.toInt()}/10, 左手:${leftHandDiff.toInt()}/10)";
  //       }
  //     }
  //     else if (this.poseStage == 2) {
  //       // 返回起始位置阶段
  //       double rightHandDiff = (rightHandY - this.initialRightHandY!).abs();
  //       double leftHandDiff = (leftHandY - this.initialLeftHandY!).abs();
  //
  //       // 检测双手是否都回到初始位置
  //       if (rightHandDiff < 30 && leftHandDiff < 30) { // 回到起始位置附近（允许6像素误差）
  //         this.startdDetector = false;
  //         this.posecounter++;
  //         this.poseStage = 0; // 重置为预备阶段
  //         this.orderText = "達標!";
  //         this.sounder(this.posecounter);
  //         this.right_side = false;
  //         // startReminder();
  //       } else {
  //         this.orderText = "請回到起始位置 (右手差距:${rightHandDiff.toInt()}, 左手差距:${leftHandDiff.toInt()})";
  //       }
  //     }
  //
  //   } else if (DetectorED) {
  //     this.startdDetector = true;
  //     this.poseStage = 0; // 确保从预备阶段开始
  //     // posesounder(false);
  //   }
  // }



  // void poseDetector() {
  //   double midY = (posedata[19]! + posedata[23]!) / 2;
  //   double midY2 = (posedata[21]! + posedata[25]!) / 2;
  //
  //   if (this.endDetector) {
  //     // stopReminder(); // 如果已结束检测，停止提醒
  //     return;
  //   }
  //
  //   bool DetectorED =
  //       ddistance(posedata[38]!, posedata[39]!, posedata[18]!, midY) < THRESHOLD // 右手接近脖子上下
  //           && ddistance(posedata[40]!, posedata[41]!, posedata[20]!, midY2) < THRESHOLD; // 左手接近脖子上下
  //
  //   if (this.startdDetector) {
  //     if (this.poseStage == 0) {
  //       // 预备动作 - 手放脖子
  //       this.orderText = "手請放脖子";
  //
  //       if (DetectorED && this.startdDetector) {
  //         this.orderText = "開始按摩";
  //         this.poseStage = 1; // 直接进入震动阶段
  //         this.initialY = midY; // 记录起始Y位置
  //         this.sounder(0); // 提示音
  //       }
  //     }
  //     else if (this.poseStage == 1) {
  //       // 震动阶段 - 检测Y轴震动5像素
  //       double currentY = midY;
  //
  //       if ((currentY - this.initialY!).abs() >= 10) { // Y轴震动5像素
  //         // this.orderText = "已偵測到震動";
  //         this.sounder(1); // 提示音
  //         this.poseStage = 2; // 进入返回起始位置阶段
  //       } else {
  //         // this.orderText = "請震動頸部 (${(currentY - this.initialY!).abs().toInt()}/10)";
  //       }
  //     }
  //     else if (this.poseStage == 2) {
  //       // 返回起始位置阶段
  //       double currentY = midY;
  //
  //       if ((currentY - this.initialY!).abs() < 6) { // 回到起始位置附近（允许3像素误差）
  //         this.startdDetector = false;
  //         this.posecounter++;
  //         this.poseStage = 0; // 重置为预备阶段
  //         this.orderText = "達標!";
  //         this.sounder(this.posecounter);
  //         this.right_side = false;
  //         // startReminder();
  //       } else {
  //         this.orderText = "請回到起始位置 (差距:${(currentY - this.initialY!).abs().toInt()})";
  //       }
  //     }
  //
  //   } else if (DetectorED) {
  //     this.startdDetector = true;
  //     this.poseStage = 0; // 确保从预备阶段开始
  //     // posesounder(false);
  //   }
  // }


  void poseDetector() {
    double midY = (posedata[19]! + posedata[23]!) / 2;
    double midY2 = (posedata[21]! + posedata[25]!) / 2;
    double rightHandY = posedata[39]!;
    double leftHandY = posedata[41]!;

    if (this.endDetector) {
      // stopReminder(); // 如果已结束检测，停止提醒
      return;
    }

    bool DetectorED =
        ddistance(posedata[38]!, posedata[39]!, posedata[18]!, midY) < THRESHOLD // 右手接近脖子上下
            && ddistance(posedata[40]!, posedata[41]!, posedata[20]!, midY2) < THRESHOLD; // 左手接近脖子上下

    if (this.startdDetector) {
      if (this.poseStage == 0) {
        // 预备动作 - 将手放在指定位置
        this.orderText = "請將雙手放在指定位置";
        if (DetectorED && this.startdDetector) {
          this.orderText = "開始上下移動雙手";
          this.poseStage = 1; // 进入移动阶段
          this.initialY = (rightHandY + leftHandY) / 2; // 记录起始Y位置
          this.sounder(0); // 提示音
        }
      }
      else if (this.poseStage == 1) {
        // 检测手部的Y轴移动
        double currentY = (rightHandY + leftHandY) / 2;

        // 在指定区域内移动
        if (DetectorED) {
          // 检测是否有足够的移动
          if ((currentY - this.initialY!).abs() >= 30) {
            // 记录当前完成一次移动
            this.posecounter++;
            this.orderText = "做得好!";
            this.sounder(this.posecounter);

            // 更新初始位置为当前位置，继续检测下一次移动
            this.initialY = currentY;
          }
        } else {
          // 如果手不在指定位置，提示用户
          this.orderText = "請保持雙手在指定位置";
        }
      }
    } else if (DetectorED) {
      this.startdDetector = true;
      this.poseStage = 0; // 确保从预备阶段开始
    }
  }


  void setStandpoint() {
    //設定基準點(左上角為(0,0)向右下)
    this.Standpoint_X = posedata[22]! - 10;
    this.Standpoint_Y = posedata[23]! - 40;
    this.Standpoint_X = posedata[24]! - 10;
    this.Standpoint_Y = posedata[25]! - 40;
    this.Standpoint_bodymind_x = (posedata[22]!+posedata[24]!)/2;
    this.Standpoint_bodymind_y = (posedata[23]!+posedata[25]!)/2;
  }

  void posetargetdone() {
    //完成任務後發出退出信號
    if (this.posecounter == this.poseTarget) {
      this.endDetector = true;
      // stopReminder(); // 完成任务时停止提醒
      // stopReminder2();
      // stopReminder3();
      sound = false;
    }
  }

  double yDistance(double x1,double y1,double x2,double y2){
    return (y2 - y1).abs();
  }

  double xDistance(double x1,double y1,double x2,double y2){
    return (x2 - x1).abs();
  }



  double ddistance(double x1, double y1, double x2, double y2) {
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2); // 計算平方距離
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
          // stopReminder();
          // stopReminder2();
          // stopReminder3();
        }
      },
    );
  }

  void sounder(int counter){
    _loadLanguagePreference();
    if(counter == 999 && sound && startdDetector){
      _audioPlayer.play(AssetSource('${getAudioPath()}/upper/shrug.${getAudioDataForm()}'));
      sound = false;
      // startReminder();
    }else
      _audioPlayer.play(AssetSource('${getAudioPath()}/${counter}.${getAudioDataForm()}'));
  }
//   Future<void> posesounder(bool BOO) async {
//     await Future.delayed(Duration(seconds: 2));
//     if(BOO){
//       player.play('pose_audios/done.mp3');
//     }
//     // else{
//     //   player.play('pose_audios/upper/shrug.mp3');
//     // }
//   }
//   void startReminder() {
//     // 确保之前的定时器被取消
//     stopReminder();
//     int counter = 0; // 新建一个计数器
//
//     reminderTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       // 播放音频
//       if(startdDetector) {
//         player.play('pose_audios/upper/shrug.mp3');
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
//
//   void startReminder2() {
//     // 确保之前的定时器被取消
//     stopReminder2();
//     int counter = 0; // 新建一个计数器
//
//     reminderTimer2 = Timer.periodic(const Duration(seconds: 2), (timer) async{
//       // 播放音频
//       if ((posedata[23]! < (this.Standpoint_Y!)&& this.startdDetector
//           &&(posedata[25]! < (this.Standpoint_Y!)&& this.startdDetector
//               &&this.startdDetector))
//           &&(!(distance(Standpoint_bodymind_x!, Standpoint_bodymind_y!,
//               (posedata[22]!+posedata[24]!)/2, (posedata[23]!+posedata[25]!)/2)>80&&this.startdDetector))) {
//         player.play('pose_audios/please_keep_it.mp3');
//       }
//
//
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
//   void startReminder3() {
//     // 确保之前的定时器被取消
//     stopReminder3();
//     int counter = 0; // 新建一个计数器
//
//     reminderTimer3 = Timer.periodic(const Duration(seconds: 3), (timer) async{
//       // 播放音频
//       if (distance(Standpoint_bodymind_x!, Standpoint_bodymind_y!,
//           (posedata[22]!+posedata[24]!)/2, (posedata[23]!+posedata[25]!)/2)>80&&this.startdDetector) {
//         player.play('pose_audios/upper/Excessive_roll.mp3');
//       }
//
//
//       // 每5秒归零并打印当前计数
//       print("计数器归零前的计数: $counter");
//       counter = 0; // 归零计数器
//
//       // 如果需要，可以在这里执行其他逻辑
//       print("计数器已归3");
//     });
//   }
//   void stopReminder3() {
//     reminderTimer3?.cancel();
//     reminderTimer3 = null; // 确保不再使用
//   }
}

Future<void> endout12() async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  var url;
  if(Face_Detect_Number==12){
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