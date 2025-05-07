import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'preference_settings_model.dart';
export 'preference_settings_model.dart';

class PreferenceSettingsWidget extends StatefulWidget {
  const PreferenceSettingsWidget({Key? key}) : super(key: key);

  @override
  _PreferenceSettingsWidgetState createState() => _PreferenceSettingsWidgetState();
}

class _PreferenceSettingsWidgetState extends State<PreferenceSettingsWidget> {
  late PreferenceSettingsModel _model;
  String _selectedLanguage = 'chinese'; // 預設為中文

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PreferenceSettingsModel());
    _loadPreference();
  }

  @override
  void dispose() {
    _model.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  // 從 SharedPreferences 載入語言偏好設定
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language_preference') ?? 'chinese';
    });
  }

  // 儲存語言偏好設定到 SharedPreferences
  Future<void> _savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_preference', _selectedLanguage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '偏好設定已儲存',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
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
                  '偏好設定',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 語言選擇區域
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '語言選擇',
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // 中文選項
                        RadioListTile<String>(
                          title: Text(
                            '中文',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                            ),
                          ),
                          value: 'chinese',
                          groupValue: _selectedLanguage,
                          activeColor: Color(0xFF688EEA),
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value!;
                            });
                          },
                        ),

                        // 台語選項
                        RadioListTile<String>(
                          title: Text(
                            '台語',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                            ),
                          ),
                          value: 'taiwanese',
                          groupValue: _selectedLanguage,
                          activeColor: Color(0xFF688EEA),
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 保存按鈕
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: FFButtonWidget(
                  onPressed: _savePreference,
                  text: '儲存設定',
                  options: FFButtonOptions(
                    width: 200,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFFFFAC8F),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
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