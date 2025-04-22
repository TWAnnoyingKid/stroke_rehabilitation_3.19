import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'trainupperbody2_model.dart';
export 'trainupperbody2_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/main.dart';
import '../vision_detector_views/pose_transform.dart';
import '../vision_detector_views/pose_video.dart';


class Trainupperbody2Widget extends StatefulWidget {
  const Trainupperbody2Widget({Key? key}) : super(key: key);

  @override
  _Trainupperbody2WidgetState createState() => _Trainupperbody2WidgetState();
}

class _Trainupperbody2WidgetState extends State<Trainupperbody2Widget> {
  late Trainupperbody2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  var  gettime= DateTime.now();  //獲取按下去的時間
  var  gettime1;  //轉換輸出型態月日年轉年月日
  /*inputtime()async{                                                           //此函式是鎖一天只能做一個動作並傳遞後端
    var url = Uri.parse(ip+"inputtime.php");
    final responce = await http.post(url,body: {
      "account" : FFAppState().accountnumber,
      "degree":"進階",
      "parts":"上肢",
      "time": gettime1.toString(),
      "action": FFAppState().trainup,//動作
    });
    if (responce.statusCode == 200) {
      var data = json.decode(responce.body); //將json解碼為陣列形式
      print(data["action"]);
      print(data["time"]);
      //print(gettime1=dateTimeFormat('yyyy-M-d', gettime));//轉換輸出型態月日年轉年月日
      if("沒時間"==data["time"]){
        if("有訓練"==data["action"]||"有時間"==data["time"]){

        }
        else{
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=>VideoApp()),
          );
        }
      }
      else if(data["times"]=="1次"&&"有時間"==data["time"]){
        if(data["timeaction"]=="對"){
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=>VideoApp()),
          );
        }
      }
      else if(data["times"]=="2次"){

      }
    }
  }*/

  inputtime()async{         //此函式為代替方案，不限制一天動作，可以一職測試 測試完請刪掉
    Navigator.push(context,
      MaterialPageRoute(builder: (context)=>VideoApp()),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Trainupperbody2Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        FFAppState().trainup = '聳肩動作';
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    gettime1=dateTimeFormat('yyyy-M-d', gettime);
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
              Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: screenHeight * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    constraints: BoxConstraints(
                      minHeight: screenHeight * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF90BDF9),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15.0, 0.0, 0.0, 0.0),
                                child: Image.asset(
                                  'assets/images/14.png',
                                  width: screenSize.width * 0.15,
                                  height: screenSize.width * 0.15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  '進階訓練',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .override(
                                    fontFamily: 'Poppins',
                                    fontSize: screenSize.width * 0.08,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if(FFAppState().affectedside == null)
                                            return;
                                          else if(FFAppState().affectedside == "右側")
                                            global.posenumber = 6;
                                          else
                                            global.posenumber = 30;
                                          setState(() {
                                            FFAppState().trainup = '肩膀前舉';
                                          });
                                          inputtime();
                                        },
                                        child: Image.asset(
                                          'assets/images/28.png',
                                          width: screenSize.width * 0.35,
                                          height: screenSize.width * 0.35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        '肩膀前舉',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                          fontSize: screenSize.width * 0.08,
                                          fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if(FFAppState().affectedside == null)
                                            return;
                                          else if(FFAppState().affectedside == "右側")
                                            global.posenumber = 7;
                                          else
                                            global.posenumber = 31;
                                          setState(() {
                                            FFAppState().trainup = '手肘前伸';
                                          });
                                          inputtime();
                                        },
                                        child: Image.asset(
                                          'assets/images/29.png',
                                          width: screenSize.width * 0.35,
                                          height: screenSize.width * 0.35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        '手肘前伸',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                          fontSize: screenSize.width * 0.08,
                                          fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if(FFAppState().affectedside == null)
                                            return;
                                          else if(FFAppState().affectedside == "右側")
                                            global.posenumber = 8;
                                          else
                                            global.posenumber = 32;

                                          setState(() {
                                            FFAppState().trainup = '肩膀側舉';
                                          });
                                          inputtime();
                                        },
                                        child: Image.asset(
                                          'assets/images/30.png',
                                          width: screenSize.width * 0.35,
                                          height: screenSize.width * 0.35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        '肩膀側舉',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                          fontSize: screenSize.width * 0.08,
                                          fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if(FFAppState().affectedside == null)
                                            return;
                                          else if(FFAppState().affectedside == "右側")
                                            global.posenumber = 9;
                                          else
                                            global.posenumber = 33;

                                          setState(() {
                                            FFAppState().trainup = '雙手抬舉';
                                          });
                                          inputtime();
                                        },
                                        child: Image.asset(
                                          'assets/images/31.png',
                                          width: screenSize.width * 0.35,
                                          height: screenSize.width * 0.35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        '雙手抬舉',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                          fontSize: screenSize.width * 0.08,
                                          fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if(FFAppState().affectedside == null)
                                            return;
                                          else if(FFAppState().affectedside == "右側")
                                            global.posenumber = 10;
                                          else
                                            global.posenumber = 34;

                                          setState(() {
                                            FFAppState().trainup = '聳肩旋轉';
                                          });
                                          inputtime();
                                        },
                                        child: Image.asset(
                                          'assets/images/50.png',
                                          width: screenSize.width * 0.35,
                                          height: screenSize.width * 0.35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        '聳肩旋轉',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                          fontSize: screenSize.width * 0.08,
                                          fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if(FFAppState().affectedside == null)
                                            return;
                                          else if(FFAppState().affectedside == "右側")
                                            global.posenumber = 11;
                                          else
                                            global.posenumber = 35;

                                          setState(() {
                                            FFAppState().trainup = '洗澡動作';
                                          });
                                          inputtime();
                                        },
                                        child: Image.asset(
                                          'assets/images/33.png',
                                          width: screenSize.width * 0.35,
                                          height: screenSize.width * 0.35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        '洗澡動作',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                          fontSize: screenSize.width * 0.08,
                                          fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 18),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBottomNavItem(
                              context,
                              'assets/images/17.jpg',
                              '返回',
                              screenSize*1.5,
                              onTap: () {
                                Navigator.pop(context);
                              }
                          ),
                          _buildBottomNavItem(
                              context,
                              'assets/images/18.jpg',
                              '使用紀錄',
                              screenSize*1.5,
                              onTap: () {
                                context.pushNamed('documental');
                              }
                          ),
                          _buildBottomNavItem(
                              context,
                              'assets/images/19.jpg',
                              '新通知',
                              screenSize*1.5,
                              onTap: () {
                                context.pushNamed('notice');
                              }
                          ),
                          _buildBottomNavItem(
                              context,
                              'assets/images/20.jpg',
                              '關於',
                              screenSize*1.5,
                              onTap: () {
                                context.pushNamed('about');
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
Widget _buildBottomNavItem(
    BuildContext context,
    String imagePath,
    String label,
    Size screenSize,
    {VoidCallback? onTap}
    ) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: screenSize.width * 0.17,
            height: screenSize.width * 0.15,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              fontSize: screenSize.width * 0.04,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

