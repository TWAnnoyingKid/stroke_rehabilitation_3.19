import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'line_model.dart';
export 'line_model.dart';

class LineWidget extends StatefulWidget {
  const LineWidget({Key? key}) : super(key: key);

  @override
  _LineWidgetState createState() => _LineWidgetState();
}

class _LineWidgetState extends State<LineWidget> {
  late LineModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LineModel());
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        body: SafeArea(
          // Remove the fixed height container and allow content to be scrollable
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 主内容区域 - 绿色背景
                Container(
                  width: double.infinity,
                  height: screenSize.width * 1.7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF99CBA2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题栏 - 图标和标题
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
                                'assets/images/24.png',
                                width: screenSize.width * 0.15,
                                height: screenSize.width * 0.15,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 0.0, 0.0),
                              child: Text(
                                '諮詢社群',
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

                      // LINE按钮
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 150, 20, 20), // Added bottom padding
                        child: Center(
                          child: Container(
                            width: screenSize.width * 0.5,
                            height: screenSize.width * 0.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await launchURL(
                                    'https://liff.line.me/1645278921-kWRPP32q/?accountId=255szdhq');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Image.asset(
                                  'assets/images/27.png',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 底部导航栏 - Remove nested SingleChildScrollView for bottom navigation
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

// 创建导航按钮的辅助方法
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
