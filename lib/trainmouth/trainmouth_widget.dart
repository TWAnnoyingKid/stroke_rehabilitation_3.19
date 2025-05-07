import 'dart:convert';
import '../main.dart';
import '../vision_detector_views/label_detector_view/face_class.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'trainmouth_model.dart';
export 'trainmouth_model.dart';
import '../vision_detector_views/label_detector_view/face_video.dart';

int Face_Detect_Number = 0;
class TrainmouthWidget extends StatefulWidget {
  const TrainmouthWidget({Key? key}) : super(key: key);

  @override
  _TrainmouthWidgetState createState() => _TrainmouthWidgetState();
}

class _TrainmouthWidgetState extends State<TrainmouthWidget> {
  late TrainmouthModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  var  gettime=DateTime.now();  //獲取按下去的時間
  var  gettime1;  //轉換輸出型態月日年轉年月日

  inputtime()async{                                                             //測試動作有無反應
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=>FaceVideoApp()));
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrainmouthModel());
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
                                  '初階訓練',
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


                            // Expanded(
                            //   child: SingleChildScrollView(//允許 Column 內容可滾動
                            //     child: Column(
                            //       children: [
                            //         Container(
                            //           width: MediaQuery.of(context).size.width,
                            //           decoration: BoxDecoration(
                            //             color: Color(0xFF90BDF9),
                            //           ),
                            //           child: Column(
                            //             children: [
                            //               Padding(
                            //                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            //                 child: Wrap(//自動換行
                            //                   spacing: 60,// 垂直間距
                            //                   runSpacing: 20,// 垂直間距
                            //                   alignment: WrapAlignment.start,//讓按鈕置中對齊
                            //                   children: List.generate(12, (index) {//生成按鈕
                            //                     //  定義圖片
                            //                     List<String> buttonLabels = [
                            //                       '抿唇動作', '臉頰微笑', '吐舌頭式', '嘟嘴式', '張嘴說阿',
                            //                       '彈舌式', '頭頸側彎', '下巴運動', '發音練習', '頭部轉向', '肩部上下', '唾液腺'
                            //                     ];
                            //
                            //                     List<int> detectNumbers = [6, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12];
                            //                     //  設定圖片
                            //                     List<String> imagePaths = [
                            //                       'assets/images/57.png', // 抿唇動作
                            //                       'assets/images/44.png', // 臉頰微笑
                            //                       'assets/images/45.png', // 吐舌頭式
                            //                       'assets/images/55.png', // 嘟嘴式
                            //                       'assets/images/56.png', // 張嘴說阿
                            //                       'assets/images/46.png', // 彈舌式
                            //                       'assets/images/54.png', // 頭頸側彎
                            //                       'assets/images/53.png', // 下巴運動
                            //                       'assets/images/58.png', // 發音練習
                            //                       'assets/images/59.png', // 頭部左右轉向
                            //                       'assets/images/60.png', // 肩部
                            //                       'assets/images/60.png',
                            //                     ];
                            //
                            //                     return GestureDetector(
                            //                       onTap: () async {
                            //                         setState(() {
                            //                           Face_Detect_Number = detectNumbers[index];
                            //                           FFAppState().mouth = buttonLabels[index];
                            //                         });
                            //                         inputtime();
                            //                       },
                            //                       child: Column(
                            //                         children: [
                            //                           Image.asset(
                            //                             imagePaths[index], //  設定的圖片
                            //                             width: MediaQuery.of(context).size.width * 0.3,
                            //                             height: MediaQuery.of(context).size.height * 0.15,
                            //                             fit: BoxFit.fill,
                            //                           ),
                            //                           Text(
                            //                             buttonLabels[index],
                            //                             style: FlutterFlowTheme.of(context)
                            //                                 .bodyMedium
                            //                                 .override(
                            //                               fontFamily: 'Poppins',
                            //                               fontSize: 28,//文字大小
                            //                               fontWeight: FontWeight.w600,
                            //                             ),
                            //                           ),
                            //                         ],
                            //                       ),
                            //                     );
                            //                   }),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),


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
                                            setState(() {
                                              Face_Detect_Number = 6;//抿唇動作
                                              FFAppState().mouth = '抿唇動作';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/57.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Text(
                                          '抿唇動作',
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
                                            setState(() {
                                              Face_Detect_Number = 1; //微笑動作
                                              FFAppState().mouth = '臉頰微笑';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/44.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '臉頰微笑',
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
                                            setState(() {
                                              Face_Detect_Number = 5;
                                              FFAppState().mouth = '彈舌式';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/46.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '彈舌式',
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
                                            setState(() {
                                              Face_Detect_Number = 8;
                                              FFAppState().mouth = '下巴運動';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/53.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '下巴運動',
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
                                            setState(() {
                                              Face_Detect_Number = 3;
                                              FFAppState().mouth = '嘟嘴式';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/55.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '嘟嘴式',
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
                                            setState(() {
                                              Face_Detect_Number = 4;
                                              FFAppState().mouth = '張嘴說阿';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/yawning.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '張嘴說阿',
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
                                            setState(() {
                                              Face_Detect_Number = 7;
                                              FFAppState().mouth = '頭頸側彎';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/54.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '頭頸側彎',
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
                                            setState(() {
                                              Face_Detect_Number = 2;
                                              FFAppState().mouth = '吐舌頭式';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/45.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '吐舌頭式',
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
                                            setState(() {
                                              Face_Detect_Number = 9;
                                              FFAppState().mouth = '發音練習';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/56.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '發音練習',
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
                                            setState(() {
                                              Face_Detect_Number = 10;
                                              FFAppState().mouth = '頭部轉向';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/59.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '頭部轉向',
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
                                            setState(() {
                                              Face_Detect_Number = 11;
                                              FFAppState().mouth = '肩部上下';
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
                                          '肩部上下',
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
                                            setState(() {
                                              Face_Detect_Number = 12;
                                              FFAppState().mouth = '唾液腺';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/salivary-glands.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '唾液腺',
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
                                            setState(() {
                                              Face_Detect_Number = 13;
                                              FFAppState().mouth = '臉頰鼓起';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/upset.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '臉頰鼓起',
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
                                            setState(() {
                                              Face_Detect_Number = 14;
                                              FFAppState().mouth = '舌頂舌板';
                                            });
                                            inputtime();
                                          },
                                          child: Image.asset(
                                            'assets/images/tongue-depressor.png',
                                            width: screenSize.width * 0.35,
                                            height: screenSize.width * 0.35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '舌頂舌板',
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

