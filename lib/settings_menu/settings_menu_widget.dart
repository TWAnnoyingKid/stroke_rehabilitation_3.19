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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 頂部標題
              _buildHeader(context, screenSize, isLandscape),

              // 設定選項
              Expanded(
                child: SingleChildScrollView(
                  child: _buildSettingsOptions(context, screenSize, isLandscape),
                ),
              ),

              // 底部導航欄
              _buildBottomNavBar(context),
            ],
          ),
        ),
      ),
    );
  }

  // 頂部標題
  Widget _buildHeader(BuildContext context, Size screenSize, bool isLandscape) {
    final headerHeight = isLandscape
        ? screenSize.height * 0.15
        : screenSize.height * 0.1;

    final titleFontSize = isLandscape
        ? screenSize.height * 0.07
        : screenSize.width * 0.08;

    return Container(
      width: double.infinity,
      height: headerHeight,
      color: FlutterFlowTheme.of(context).primaryBtnText,
      padding: EdgeInsets.all(screenSize.width * 0.02),
      child: Center(
        child: Text(
          '設定選單',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'Poppins',
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 設定選項
  Widget _buildSettingsOptions(BuildContext context, Size screenSize, bool isLandscape) {
    final optionHeight = isLandscape
        ? screenSize.height * 0.14
        : screenSize.height * 0.1;

    final iconSize = isLandscape
        ? screenSize.height * 0.06
        : screenSize.width * 0.08;

    final fontSize = isLandscape
        ? screenSize.height * 0.04
        : screenSize.width * 0.06;

    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      child: Column(
        children: [
          _buildSettingOption(
            context,
            Icons.settings_applications_rounded,
            '偏好設定',
            Color(0xFF688EEA),
            screenSize,
            isLandscape,
            height: optionHeight,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => context.pushNamed('preference_settings'),
          ),
          SizedBox(height: screenSize.height * 0.03),
          _buildSettingOption(
            context,
            Icons.person_outline,
            '使用者帳號設定',
            Color(0xFFFFAC8F),
            screenSize,
            isLandscape,
            height: optionHeight,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => context.pushNamed('setting'),
          ),
        ],
      ),
    );
  }

  // 單個設定選項
  Widget _buildSettingOption(
      BuildContext context,
      IconData icon,
      String label,
      Color backgroundColor,
      Size screenSize,
      bool isLandscape,
      {double? height,
        double? iconSize,
        double? fontSize,
        VoidCallback? onTap}
      ) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
              child: Icon(
                icon,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 統一的底部導航欄
  Widget _buildBottomNavBar(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final navBarHeight = isLandscape
        ? screenSize.height * 0.15
        : screenSize.height * 0.15;

    return Container(
      width: double.infinity,
      height: navBarHeight,
      color: FlutterFlowTheme.of(context).primaryBtnText,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(
              context,
              'assets/images/17.jpg',
              '返回',
              onTap: () => Navigator.pop(context)
          ),
          _buildNavItem(
              context,
              'assets/images/18.jpg',
              '使用紀錄',
              onTap: () => context.pushNamed('documental')
          ),
          _buildNavItem(
              context,
              'assets/images/19.jpg',
              '新通知',
              onTap: () => context.pushNamed('notice')
          ),
          _buildNavItem(
              context,
              'assets/images/20.jpg',
              '關於',
              onTap: () => context.pushNamed('about')
          ),
        ],
      ),
    );
  }

  // 統一的導航項目
  Widget _buildNavItem(
      BuildContext context,
      String imagePath,
      String label,
      {VoidCallback? onTap}
      ) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final iconSize = isLandscape
        ? screenSize.height * 0.08
        : screenSize.width * 0.15;

    final fontSize = isLandscape
        ? screenSize.height * 0.03
        : screenSize.width * 0.04;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenSize.height * 0.005),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Poppins',
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}