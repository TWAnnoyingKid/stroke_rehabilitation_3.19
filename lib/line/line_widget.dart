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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF99CBA2),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 頂部標題區域
              _buildPageHeader(context, '諮詢社群', 'assets/images/24.png'),

              // 中間內容區域 (可滾動)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // LINE按鈕
                        _buildLineButton(context, screenSize, isLandscape),
                      ],
                    ),
                  ),
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

  // LINE按鈕
  Widget _buildLineButton(BuildContext context, Size screenSize, bool isLandscape) {
    final buttonSize = isLandscape
        ? screenSize.width * 0.3
        : screenSize.width * 0.5;

    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.05),
      child: Center(
        child: Container(
          width: buttonSize,
          height: buttonSize,
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
    );
  }

  // 統一的頁面標題區域
  Widget _buildPageHeader(
      BuildContext context,
      String title,
      String imagePath
      ) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final containerHeight = isLandscape
        ? screenSize.height * 0.15
        : screenSize.height * 0.1;

    final iconSize = isLandscape
        ? screenSize.height * 0.1
        : screenSize.width * 0.15;

    final titleFontSize = isLandscape
        ? screenSize.height * 0.07
        : screenSize.width * 0.08;

    return Container(
      width: double.infinity,
      height: containerHeight,
      color: Color(0xFF99CBA2), // 保持與頁面主色調一致
      padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.01,
          horizontal: screenSize.width * 0.02
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                screenSize.width * 0.03, 0.0, 0.0, 0.0),
            child: Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                screenSize.width * 0.04, 0.0, 0.0, 0.0),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context)
                  .displaySmall
                  .override(
                fontFamily: 'Poppins',
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
        : screenSize.width * 0.12;

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