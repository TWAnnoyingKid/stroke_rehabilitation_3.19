import 'dart:convert';
import '../main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  var money1;

  Future money()async{
    var url = Uri.parse(ip+"money.php");
    final responce = await http.post(url,body: {
      "account" : FFAppState().accountnumber,
    });
    if (responce.statusCode == 200) {
      var data = json.decode(responce.body);
      setState(() {
        money1=data['coin']['coin'];
      });
      //print(data['coin']['coin']);
    }
  }

  void cycle(){
    var url = Uri.parse(ip+"delete.php");
    http.post(url,body: {
      "account":FFAppState().accountnumber,
    });

  }


  @override
  void initState() {
    future:money();
    super.initState();
    _model = createModel(context, () => HomeModel());

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
    //////////////////////////////////////////////////////////////////
    final screenSize = MediaQuery.of(context).size;
/////////////////////////////////////////////////////////////////////////////////
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Header with greeting and points
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Hello ',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.07,/////////////////
                                ),
                              ),
                              Text(
                                FFAppState().nickname,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.05,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '繼續努力加油!!!',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              fontSize: screenSize.width * 0.05,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                                child: Image.asset(
                                  'assets/images/25.jpg',
                                  width: screenSize.width * 0.15,
                                  height: screenSize.height * 0.08,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                '$money1' + '個',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main menu options
                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.14,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD3C4),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed('need');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          'assets/images/23.png',
                          width: screenSize.width * 0.22,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '需求表達',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.14,
                  decoration: BoxDecoration(
                    color: Color(0xFF688EEA),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed('train');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          'assets/images/22.png',
                          width: screenSize.width * 0.22,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '復健訓練',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.14,
                  decoration: BoxDecoration(
                    color: Color(0xFFD4FFC4),
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed('LINE');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          'assets/images/24.png',
                          width: screenSize.width * 0.22,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '諮詢社群',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.14,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).grayIcon,
                  ),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed('setting');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/21.png',
                          width: screenSize.width * 0.22,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '設定',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: screenSize.width * 0.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom navigation row
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
        ),
      ),
    );
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
}
