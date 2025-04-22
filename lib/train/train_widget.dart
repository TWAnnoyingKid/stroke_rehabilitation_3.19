import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'train_model.dart';
export 'train_model.dart';
import '/rsst_test/rsst_intro_page.dart';

class TrainWidget extends StatefulWidget {
  const TrainWidget({Key? key}) : super(key: key);

  @override
  _TrainWidgetState createState() => _TrainWidgetState();
}

class _TrainWidgetState extends State<TrainWidget> {
  late TrainModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrainModel());
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

    // 計算自適應字體大小和按鈕大小
    final titleFontSize = screenWidth * 0.08 > 50 ? 50.0 : screenWidth * 0.08;
    final buttonFontSize = screenWidth * 0.06 > 35 ? 35.0 : screenWidth * 0.06;
    final buttonHeight = screenHeight * 0.12 > 100 ? 100.0 : screenHeight * 0.12;
    final imageSize = screenHeight * 0.09 > 90 ? 90.0 : screenHeight * 0.09;

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
                                      'assets/images/22.png',
                                      width: screenSize.width * 0.15,
                                      height: screenSize.width * 0.15,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      '復健訓練',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .displaySmall
                                          .override(
                                        fontFamily: 'Poppins',
                                        fontSize: titleFontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // 上肢訓練按鈕
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                        child: Container(
                                          width: screenSize.width * 0.9,
                                          height: screenSize.width * 0.2,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4DB60),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(5.0, 15.0),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed('trainupperbody');
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '上肢訓練',
                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFC50D1C),
                                                    fontSize: screenSize.width * 0.12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                  child: Image.asset(
                                                    'assets/images/13.png',
                                                      width: screenSize.width * 0.15,
                                                      height: screenSize.width * 0.15,
                                                      fit: BoxFit.contain,
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
                                // 下肢訓練按鈕
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                        child: Container(
                                          width: screenSize.width * 0.9,
                                          height: screenSize.width * 0.2,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4DB60),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(5.0, 15.0),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed('trainlowerbody');
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '下肢訓練',
                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFC50D1C),
                                                    fontSize: screenSize.width * 0.12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                  child: Image.asset(
                                                    'assets/images/14.png',
                                                    width: screenSize.width * 0.15,
                                                    height: screenSize.width * 0.15,
                                                    fit: BoxFit.contain,
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
                                // 口腔動作按鈕
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                        child: Container(
                                          width: screenSize.width * 0.9,
                                          height: screenSize.width * 0.2,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4DB60),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(5.0, 15.0),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed('trainmouth');
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '口腔訓練',
                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFC50D1C),
                                                    fontSize: screenSize.width * 0.12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                  child: Image.asset(
                                                    'assets/images/15.png',
                                                    width: screenSize.width * 0.15,
                                                    height: screenSize.width * 0.15,
                                                    fit: BoxFit.contain,
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
                                // 口腔動作按鈕
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                        child: Container(
                                          width: screenSize.width * 0.9,
                                          height: screenSize.width * 0.2,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF4DB60),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x33000000),
                                                offset: Offset(5.0, 15.0),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(40.0),
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const RsstIntroPage(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '復健成效測驗',
                                                  style: FlutterFlowTheme.of(context).displaySmall.override(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFC50D1C),
                                                    fontSize: screenSize.width * 0.12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                  child: Image.asset(
                                                    'assets/images/15.png',
                                                    width: screenSize.width * 0.15,
                                                    height: screenSize.width * 0.15,
                                                    fit: BoxFit.contain,
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
