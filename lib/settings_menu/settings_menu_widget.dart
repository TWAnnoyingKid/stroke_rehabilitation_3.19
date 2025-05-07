import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_menu_model.dart';
export 'settings_menu_model.dart';

class SettingsMenuWidget extends StatefulWidget {
  const SettingsMenuWidget({Key? key}) : super(key: key);

  @override
  _SettingsMenuWidgetState createState() => _SettingsMenuWidgetState();
}

class _SettingsMenuWidgetState extends State<SettingsMenuWidget> {
  late SettingsMenuModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsMenuModel());
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // 頂部標題
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Text(
                  '設定選單',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 設定選項按鈕
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('preference_settings');
                  },
                  child: Container(
                    width: double.infinity,
                    height: screenSize.height * 0.1,
                    decoration: BoxDecoration(
                      color: Color(0xFF688EEA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Icon(
                            Icons.settings_applications_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            '偏好設定',
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.pushNamed('setting');
                  },
                  child: Container(
                    width: double.infinity,
                    height: screenSize.height * 0.1,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFAC8F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            '使用者帳號設定',
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Spacer(),

              // 底部導航列
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