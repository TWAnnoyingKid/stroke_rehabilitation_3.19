import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'trainlowerbody_model.dart';
export 'trainlowerbody_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/main.dart';
class TrainlowerbodyWidget extends StatefulWidget {
  const TrainlowerbodyWidget({Key? key}) : super(key: key);

  @override
  _TrainlowerbodyWidgetState createState() => _TrainlowerbodyWidgetState();
}

class _TrainlowerbodyWidgetState extends State<TrainlowerbodyWidget> {
  late TrainlowerbodyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  lock1()async{
    var url = Uri.parse(ip+"lock.php");
    final responce = await http.post(url,body: {
      "pid" : FFAppState().accountnumber,
      "parts":"下肢",
      //"pid" : "airehab_01",
    });
    if (responce.statusCode == 200) {
      var data = json.decode(responce.body); //將json解碼為陣列形式
      if(data["lock"]["state"]=="unlock"){
        context.pushNamed('trainlowerbody1');    //!!!!!!!!!這段是無動作，測試完 請刪掉
      }
      else{
        context.pushNamed('trainlowerbody1');
      }
    }
  }
  lock2()async{
    var url = Uri.parse(ip+"lock.php");
    final responce = await http.post(url,body: {
      "pid" : FFAppState().accountnumber,
      "parts":"下肢",
      //"pid" : "airehab_01",
    });
    if (responce.statusCode == 200) {
      var data = json.decode(responce.body); //將json解碼為陣列形式
      if(data["lock"]["state"]=="lock"){
        context.pushNamed('trainlowerbody2');    //!!!!!!!!!這段是無動作，測試完 請刪掉
      }
      else{
        context.pushNamed('trainlowerbody2');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrainlowerbodyModel());
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
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                    '下肢訓練',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                      fontFamily: 'Poppins',
                                      fontSize: screenSize.width * 0.08,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: screenSize.width * 0.6,
                                        height: screenSize.width * 0.3,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD2FFBF),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x33000000),
                                              offset: Offset(5.0, 15.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            lock1();
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '初階',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0xA213549A),
                                                      fontSize: screenSize.width * 0.12,
                                                      fontWeight: FontWeight.w600,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 35.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 20.0, 0.0, 0.0),
                                      child: Container(
                                        width: screenSize.width * 0.6,
                                        height: screenSize.width * 0.3,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD2FFBF),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x33000000),
                                              offset: Offset(5.0, 15.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            lock2();
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '進階',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0xA213549A),
                                                      fontSize: screenSize.width * 0.12,
                                                      fontWeight: FontWeight.w600,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

