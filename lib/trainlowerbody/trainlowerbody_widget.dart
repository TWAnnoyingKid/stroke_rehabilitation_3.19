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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF90BDF9),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 固定標題區域
              Container(
                width: double.infinity,
                height: isLandscape
                    ? screenHeight * 0.15
                    : screenHeight * 0.1, // 根據方向設置不同的高度比例
                color: Color(0xFF90BDF9),
                padding: EdgeInsets.symmetric(
                    vertical: isLandscape ? screenHeight * 0.01 : screenHeight * 0.01),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          screenWidth * 0.03, 0.0, 0.0, 0.0),
                      child: Image.asset(
                        'assets/images/14.png',
                        width: isLandscape ? screenHeight * 0.1 : screenWidth * 0.15,
                        height: isLandscape ? screenHeight * 0.1 : screenWidth * 0.15,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          screenWidth * 0.04, 0.0, 0.0, 0.0),
                      child: Text(
                        '下肢訓練',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context)
                            .displaySmall
                            .override(
                          fontFamily: 'Poppins',
                          fontSize: isLandscape
                              ? screenHeight * 0.07  // 橫向時使用螢幕高度比例
                              : screenWidth * 0.08, // 直向時使用螢幕寬度比例
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 中間內容區域 (可滾動)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    color: Color(0xFF90BDF9),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: isLandscape ? screenWidth * 0.04 : 0,
                    ),
                    child: isLandscape
                    // 橫向模式 - 兩個級別並排
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 初階選項
                        _buildLevelButton(
                          context: context,
                          title: '初階',
                          screenSize: screenSize,
                          isLandscape: true,
                          onTap: () async {
                            lock1();
                          },
                        ),

                        // 進階選項
                        _buildLevelButton(
                          context: context,
                          title: '進階',
                          screenSize: screenSize,
                          isLandscape: true,
                          onTap: () async {
                            lock2();
                          },
                        ),
                      ],
                    )
                    // 直向模式保持不變
                        : Column(
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
                              0.0, screenHeight * 0.04, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, screenHeight * 0.02, 0.0, 0.0),
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
                  ),
                ),
              ),

              // 底部固定導航欄
              Container(
                width: double.infinity,
                height: isLandscape
                    ? screenHeight * 0.15
                    : screenHeight * 0.15,  // 根據方向設置高度比例
                color: FlutterFlowTheme.of(context).primaryBtnText,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBottomNavItem(
                        context,
                        'assets/images/17.jpg',
                        '返回',
                        onTap: () {
                          Navigator.pop(context);
                        }
                    ),
                    _buildBottomNavItem(
                        context,
                        'assets/images/18.jpg',
                        '使用紀錄',
                        onTap: () {
                          context.pushNamed('documental');
                        }
                    ),
                    _buildBottomNavItem(
                        context,
                        'assets/images/19.jpg',
                        '新通知',
                        onTap: () {
                          context.pushNamed('notice');
                        }
                    ),
                    _buildBottomNavItem(
                        context,
                        'assets/images/20.jpg',
                        '關於',
                        onTap: () {
                          context.pushNamed('about');
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 初階/進階按鈕組件 (橫向模式專用)
Widget _buildLevelButton({
  required BuildContext context,
  required String title,
  required Size screenSize,
  required bool isLandscape,
  required VoidCallback onTap,
}) {
  final buttonWidth = isLandscape
      ? screenSize.width * 0.4
      : screenSize.width * 0.6;

  final buttonHeight = isLandscape
      ? screenSize.height * 0.3
      : screenSize.width * 0.3;

  final fontSize = isLandscape
      ? screenSize.height * 0.08
      : screenSize.width * 0.12;

  return Container(
    width: buttonWidth,
    height: buttonHeight,
    decoration: BoxDecoration(
      color: Color(0xFFD2FFBF),
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
      onTap: onTap,
      child: Center(
        child: Text(
          title,
          style: FlutterFlowTheme.of(context).displaySmall.override(
            fontFamily: 'Poppins',
            color: Color(0xA213549A),
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
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
    {VoidCallback? onTap}
    ) {
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  // 根據方向設置不同的尺寸比例
  final iconWidth = isLandscape
      ? screenHeight * 0.08
      : screenWidth * 0.12;
  final iconHeight = isLandscape
      ? screenHeight * 0.08
      : screenWidth * 0.12;
  final fontSize = isLandscape
      ? screenHeight * 0.03
      : screenWidth * 0.04;

  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: iconWidth,
            height: iconHeight,
            fit: BoxFit.contain,
          ),
          SizedBox(height: screenHeight * 0.005),
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

