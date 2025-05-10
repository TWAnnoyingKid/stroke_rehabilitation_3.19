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

  Future money() async {
    var url = Uri.parse(ip + "money.php");
    final responce = await http.post(url, body: {
      "account": FFAppState().accountnumber,
    });
    if (responce.statusCode == 200) {
      var data = json.decode(responce.body);
      setState(() {
        money1 = data['coin']['coin'];
      });
      //print(data['coin']['coin']);
    }
  }

  void cycle() {
    var url = Uri.parse(ip + "delete.php");
    http.post(url, body: {
      "account": FFAppState().accountnumber,
    });
  }

  @override
  void initState() {
    future:
    money();
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
            children: [
              // 歡迎區域 - 改為水平佈局
              _buildWelcomeHeader(context, screenSize, isLandscape),

              // 中間選單區域 (可滾動)
              Expanded(
                child: SingleChildScrollView(
                  child: _buildMenuOptions(context, screenSize, isLandscape),
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

  // 重新設計的歡迎區域 - 水平佈局
  Widget _buildWelcomeHeader(BuildContext context, Size screenSize, bool isLandscape) {
    // 計算響應式尺寸
    final headerPadding = EdgeInsets.symmetric(
      horizontal: screenSize.width * 0.05,
      vertical: isLandscape ? screenSize.height * 0.02 : screenSize.height * 0.02,
    );

    final greetingFontSize = isLandscape
        ? screenSize.height * 0.05
        : screenSize.width * 0.05;

    final coinIconSize = isLandscape
        ? screenSize.height * 0.08
        : screenSize.width * 0.12;

    final coinFontSize = isLandscape
        ? screenSize.height * 0.05
        : screenSize.width * 0.07;

    return Container(
      width: double.infinity,
      padding: headerPadding,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBtnText,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 左側 - 歡迎詞
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello ',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: greetingFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      FFAppState().nickname,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: greetingFontSize,
                      ),
                    ),
                  ],
                ),
                Text(
                  '繼續努力加油!!!',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: greetingFontSize * 0.8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // 右側 - 金幣數量
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/25.jpg',
                width: coinIconSize,
                height: coinIconSize,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8),
              Text(
                '$money1' + '個',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Poppins',
                  fontSize: coinFontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 重新設計的選單區域
  Widget _buildMenuOptions(BuildContext context, Size screenSize, bool isLandscape) {
    // 響應式尺寸和間距計算
    final padding = EdgeInsets.all(isLandscape
        ? screenSize.width * 0.02
        : screenSize.width * 0.03);

    return Padding(
      padding: padding,
      child: isLandscape
          ? _buildLandscapeMenuGrid(context, screenSize)
          : _buildPortraitMenuList(context, screenSize),
    );
  }

  // 橫向菜單 - 網格佈局
  Widget _buildLandscapeMenuGrid(BuildContext context, Size screenSize) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      mainAxisSpacing: screenSize.height * 0.03,
      crossAxisSpacing: screenSize.width * 0.02,
      children: [
        _buildMenuOption(
          context,
          'assets/images/23.png',
          '需求表達',
          Color(0xFFFFD3C4),
          screenSize,
          true,
          onTap: () => context.pushNamed('need'),
        ),
        _buildMenuOption(
          context,
          'assets/images/22.png',
          '復健訓練',
          Color(0xFF688EEA),
          screenSize,
          true,
          onTap: () => context.pushNamed('train'),
        ),
        _buildMenuOption(
          context,
          'assets/images/24.png',
          '諮詢社群',
          Color(0xFFD4FFC4),
          screenSize,
          true,
          onTap: () => context.pushNamed('LINE'),
        ),
        _buildMenuOption(
          context,
          'assets/images/21.png',
          '設定',
          FlutterFlowTheme.of(context).grayIcon,
          screenSize,
          true,
          onTap: () => context.pushNamed('settings_menu'),
        ),
      ],
    );
  }

  // 直向菜單 - 列表佈局
  Widget _buildPortraitMenuList(BuildContext context, Size screenSize) {
    final itemHeight = screenSize.height * 0.12;
    final spacing = screenSize.height * 0.01;

    return Column(
      children: [
        _buildMenuOption(
          context,
          'assets/images/23.png',
          '需求表達',
          Color(0xFFFFD3C4),
          screenSize,
          false,
          height: itemHeight,
          onTap: () => context.pushNamed('need'),
        ),
        SizedBox(height: spacing),
        _buildMenuOption(
          context,
          'assets/images/22.png',
          '復健訓練',
          Color(0xFF688EEA),
          screenSize,
          false,
          height: itemHeight,
          onTap: () => context.pushNamed('train'),
        ),
        SizedBox(height: spacing),
        _buildMenuOption(
          context,
          'assets/images/24.png',
          '諮詢社群',
          Color(0xFFD4FFC4),
          screenSize,
          false,
          height: itemHeight,
          onTap: () => context.pushNamed('LINE'),
        ),
        SizedBox(height: spacing),
        _buildMenuOption(
          context,
          'assets/images/21.png',
          '設定',
          FlutterFlowTheme.of(context).grayIcon,
          screenSize,
          false,
          height: itemHeight,
          onTap: () => context.pushNamed('settings_menu'),
        ),
      ],
    );
  }

  // 優化的選單選項
  Widget _buildMenuOption(
      BuildContext context,
      String imagePath,
      String label,
      Color backgroundColor,
      Size screenSize,
      bool isLandscape,
      {double? height, VoidCallback? onTap}
      ) {
    // 響應式尺寸計算
    final iconSize = isLandscape
        ? screenSize.height * 0.1
        : screenSize.height * 0.08;

    final fontSize = isLandscape
        ? screenSize.height * 0.1
        : screenSize.width * 0.08;

    final borderRadius = BorderRadius.circular(12);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  imagePath,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 底部導航欄
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