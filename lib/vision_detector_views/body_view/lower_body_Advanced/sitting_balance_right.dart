import 'dart:async';
import 'dart:math';
import '../assembly.dart';
import 'package:audioplayers/audioplayers.dart';//播放音檔
import 'package:shared_preferences/shared_preferences.dart';

class Detector_sitting_balance_right implements Detector_default{
  int posetimecounter = 0; //復健動作持續秒數
  int posetimeTarget = 3; //復健動作持續秒數目標
  int posecounter = 0; //復健動作實作次數
  int poseTarget = 15; //目標次數設定
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
  bool right_side = true;
  bool timerui = true;
  String mindText = "請將全身拍攝於畫面內\n並維持鏡頭穩定\n準備完成請按「Start」";
  final AudioCache player = AudioCache();
  final AudioPlayer _audioPlayer = AudioPlayer();//播放音檔
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
    posesounder(true);
  }

  void poseDetector() {
    //偵測判定
    if (this.startdDetector) {
      DetectorED = true;
      if(right_side) {
        this.orderText = "請向右傾";
        if (this.posetimecounter == this.posetimeTarget) {
          //秒數達成
          this.startdDetector = false;
          this.posecounter++;
          this.posetimecounter = 0;
          this.orderText = "達標!";
          this.sounder(this.posecounter);
          this.right_side = false;
          posesounder(false);
        }
        if (distance(posedata[24]!, posedata[24]!, posedata[48]!, posedata[48]!) > 120
            && this.startdDetector) {
          //每秒目標
          this.posetimecounter++;
          print(this.posetimecounter);
          this.orderText = "請保持住!";
        } else {
          //沒有保持
          this.posetimecounter = 0;
        }
      }else {
        this.orderText = "請向左傾";
        if (this.posetimecounter == this.posetimeTarget) {
          //秒數達成
          this.startdDetector = false;
          this.posecounter++;
          this.posetimecounter = 0;
          this.orderText = "達標!";
          this.sounder(this.posecounter);
          this.right_side = true;
          posesounder(true);
        }
        if (distance(posedata[22]!, posedata[22]!, posedata[46]!, posedata[46]!)>120
            && this.startdDetector) {
          //每秒目標
          this.posetimecounter++;
          print(this.posetimecounter);
          this.orderText = "請保持住!";
        } else {
          //沒有保持
          this.posetimecounter = 0;
        }
      }
    } else if (DetectorED) {
      //預防空值被訪問
      if (
      distance(posedata[24]!, posedata[24]!, posedata[48]!, posedata[48]!)<100
      ) {
        //確認復歸
        this.startdDetector = true;
      } else {
        this.orderText = "請回正身體";
      }
    }
  }

  void setStandpoint() {
    //設定基準點(左上角為(0,0)向右下)
    // this.Standpoint_X = posedata[22]! - 20;
    // this.Standpoint_Y = posedata[23]! - 20;
    // this.Standpoint_bodymind_x = (posedata[22]!+posedata[24]!)/2;
    // this.Standpoint_bodymind_y = (posedata[23]!+posedata[25]!)/2;
  }

  void posetargetdone() {
    //完成任務後發出退出信號
    if (this.posecounter == this.poseTarget) {
      this.endDetector = true;
    }
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
          }
        },
      );
  }

  @override
  Future<void> sounder(int counter) async {
    String audioPath = '${getAudioPath()}/${counter}.${getAudioDataForm()}';
    await _audioPlayer.play(AssetSource(audioPath));
  }

  Future<void> posesounder(bool BOO) async {
    await Future.delayed(Duration(seconds: 1));
    await _loadLanguagePreference();
    String baseAudioPath = getAudioPath();
    if(BOO){
      await _audioPlayer.play(AssetSource('$baseAudioPath/lower/sitting_balance_right.${getAudioDataForm()}'));
    }else{
      await _audioPlayer.play(AssetSource('$baseAudioPath/lower/sitting_balance_left.${getAudioDataForm()}'));
    }
  }
}
