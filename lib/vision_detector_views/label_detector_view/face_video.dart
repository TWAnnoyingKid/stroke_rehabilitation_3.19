import 'package:flutter/material.dart';
import 'package:untitled2/trainmouth/trainmouth_widget.dart';
import 'package:video_player/video_player.dart';
import 'face_class.dart';

class FaceVideoApp extends StatefulWidget {
  const FaceVideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<FaceVideoApp> {
  late VideoPlayerController _controller;

  final Map<int, String> rehabilitationInfo = {
    9: "語言訓練：這個訓練幫助改善中風後語言功能障礙，通過有系統的語言練習促進語言區域恢復。",
    10: "頭部轉動：這個運動可以鍛鍊頸部肌肉，改善頭部運動控制能力，對中風後頸部僵硬有幫助。",
    11: "肩部活動：這個練習幫助恢復肩膀活動範圍，預防肩部疼痛和僵硬，提高上肢功能。",
    12: "唾液腺按摩：這個技術通過刺激唾液腺，改善吞嚥功能和口腔濕潤度，減輕口乾症狀。",
    13: "臉頰鼓氣：這個練習強化臉頰肌肉，改善口腔控制能力，有助於進食和發音功能恢復。",
    14: "舌頭壓板訓練：這個訓練加強舌頭力量和控制能力，對吞嚥障礙和構音問題有改善效果。",
  };

  @override
  void initState() {
    super.initState();
    int _facenumber;
    _facenumber = Face_Detect_Number;
    if(_facenumber > 8){
      _facenumber = 8;
    }
    _controller = VideoPlayerController.network(
        'https://github.com/TWAnnoyingKid/stroke_rehabilitation_3.19/raw/main/assets/face_videos/${_facenumber}.mp4')
      ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
          _controller.play();
      });
  }

  // 添加到 _VideoAppState 類中
  void _showInfoDialog(BuildContext context) {
    // 根據不同的 Face_Detect_Number 設置不同的復健信息
    String title = "";
    String description = "";
    String imagePath = "";

    switch(Face_Detect_Number) {
      case 9:
        title = "語言訓練";
        description = "此訓練主要針對語言功能障礙患者，透過發音練習和語言復健活動，幫助恢復言語能力。訓練過程中需要反覆練習口部肌肉的協調運動，同時結合發聲訓練。\n\n訓練步驟：\n1. 坐直身體，放鬆肩膀\n2. 深呼吸後開始練習發音\n3. 從簡單的單音節開始，逐漸增加複雜度\n4. 每天練習10-15分鐘，每次訓練間隔足夠休息時間";
        imagePath = "assets/rehab_images/speech_muscles.png";
        break;
      case 10:
        title = "頭部轉動";
        description = "頭部轉動訓練可以幫助改善頸部肌肉的靈活性和力量，並促進血液循環。此訓練對於中風後頸部肌肉僵硬的患者特別有益。\n\n訓練步驟：\n1. 坐姿挺直，雙手放鬆\n2. 緩慢將頭部向左轉動，停留3-5秒\n3. 回到中間位置，再向右轉動，停留3-5秒\n4. 重複動作5-10次，注意動作要緩慢且控制良好";
        imagePath = "assets/rehab_images/head_turn_muscles.png";
        break;
      case 11:
        title = "肩部活動";
        description = "肩部活動訓練有助於恢復肩膀關節靈活度和肌肉力量，對於上肢功能障礙的中風患者非常重要。此訓練可預防肩部痛症和關節僵硬。\n\n訓練步驟：\n1. 坐直或站立，雙手放在頭上\n2. 將雙肩向上提升，保持5秒\n3. 放鬆後，嘗試向後和向前轉動肩膀\n4. 每種動作重複10次，動作要平穩且有控制";
        imagePath = "assets/rehab_images/shoulder_muscles.png";
        break;
      case 12:
        title = "唾液腺按摩";
        description = "唾液腺按摩可以刺激唾液分泌，幫助中風患者改善口乾和吞嚥困難的問題。此按摩也有助於面部血液循環和放鬆面部肌肉。\n\n訓練步驟：\n1. 用指腹在耳朵前方的腮腺區域輕輕畫圓\n2. 按摩下巴下方的顎下腺區域\n3. 按摩舌下腺位置（舌頭下方）\n4. 每個部位按摩30秒至1分鐘，每天進行2-3次";
        imagePath = "assets/rehab_images/salivary_gland_muscles.png";
        break;
      case 13:
        title = "臉頰鼓氣";
        description = "臉頰鼓氣訓練有助於加強臉頰肌肉和口腔控制能力，對吞嚥和發音有正面幫助。此訓練也可以改善面部對稱性。\n\n訓練步驟：\n1. 深吸一口氣，將空氣存在口腔中，鼓起臉頰\n2. 保持鼓氣姿勢5-10秒\n3. 緩慢呼出空氣\n4. 嘗試將空氣在左右臉頰間移動\n5. 重複以上動作8-10次";
        imagePath = "assets/rehab_images/puff_muscles.png";
        break;
      case 14:
        title = "舌頭壓舌板";
        description = "舌頭壓舌板訓練可以增強舌頭的力量和控制能力，對於改善吞嚥功能和說話清晰度有很大幫助。此訓練針對舌頭肌肉。\n\n訓練步驟：\n1. 將舌頭伸出抵住壓舌板\n2. 用舌頭施力推動壓舌板5-10秒\n3. 嘗試向不同方向推動（上、下、左、右）\n4. 每個方向重複5次\n5. 隨著能力增強，可以增加抵抗的時間";
        imagePath = "assets/rehab_images/tongue_depresser_muscles.png";
        break;
      default:
        title = "復健資訊";
        description = "請選擇特定的復健動作查看詳細說明。";
        imagePath = "";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Divider(thickness: 2),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (imagePath.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "訓練肌肉區域：",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Image.asset(
                                  imagePath,
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: Face_Detect_Number > 8 ? AppBar(
        backgroundColor: Color.fromARGB(255, 144, 189, 249),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white, size: 30),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ) : null,

      body:Container(
        color: Color.fromARGB(255, 144, 189, 249),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller))
                : Container(),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      fixedSize: MaterialStateProperty.all(Size(80, 80)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)))),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 50, color: Colors.white),
                ),
                Padding(padding: EdgeInsets.all(30)),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                      fixedSize: MaterialStateProperty.all<Size>(Size(80, 80)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)))),
                  onPressed: () {
                    switch(Face_Detect_Number){
                      case 1:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>smile()));
                        break;
                      case 2:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>tougue()));
                        break;
                      case 3:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>pout()));
                        break;
                      case 4:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>open_mouth()));
                        break;
                      case 5:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>flick_tougue()));
                        break;
                      case 6:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>pursed_lips()));
                        break;
                      case 7:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>headneck_bend()));
                        break;
                      case 8:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>chin_movement()));
                        break;
                      case 9:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>speech()));
                        break;
                      case 10:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>head_turn()));
                        break;
                      case 11:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>Shoulder_activities()));
                        break;
                      case 12:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>Salivary_gland_massage()));
                        break;
                      case 13:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>puff()));
                        break;
                      case 14:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context)=>tongue_depresser()));
                        break;
                    }
                  },
                  child: Icon(Icons.arrow_forward, size: 50, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: 300,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(132, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Text(
                "左邊按鈕暫停與重播影片\n右邊按鈕開始復健!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  backgroundColor: Colors.transparent,
                  fontSize: 25,
                  color: Colors.black,
                  height: 1.2,
                  inherit: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}