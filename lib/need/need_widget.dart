import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'need_model.dart';
export 'need_model.dart';
import 'package:audioplayers/audioplayers.dart';//播放音檔
class NeedWidget extends StatefulWidget {
  const NeedWidget({Key? key}) : super(key: key);

  @override
  _NeedWidgetState createState() => _NeedWidgetState();
}

class _NeedWidgetState extends State<NeedWidget> {
  late NeedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final AudioCache player = AudioCache();
  final AudioPlayer _audioPlayer = AudioPlayer();//播放音檔

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NeedModel());
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
    // Calculate responsive values
    final double iconSize = screenSize.width * 0.15;
    final double fontSize = screenSize.width * 0.04;
    final double cardButtonFontSize = screenSize.width < 400 ? 20.0 : 30.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        body: SafeArea(
          // Use SingleChildScrollView to wrap the entire content including navigation
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Main content container
                Container(
                  width: double.infinity,
                  color: Color(0xFFFFC1A1),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 0.0, 0.0, 0.0),
                              child: Image.asset(
                                'assets/images/00.png',
                                width: iconSize,
                                height: iconSize,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 0.0, 0.0),
                              child: Text(
                                '需求表達',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                  fontFamily: 'Poppins',
                                  fontSize: fontSize * 1.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Grid layout
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: GridView.count(
                          crossAxisCount: screenSize.width < 600 ? 2 : 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 15,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridItem(
                                context,
                                'assets/images/01.png',
                                '肚子餓',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/5.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/02.png',
                                '口渴',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/2.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/03.png',
                                '小號',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/4.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/04.png',
                                '大號',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/3.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/05.png',
                                '換尿布',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/8.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/06.png',
                                '翻身',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/12.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/07.png',
                                '很熱',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/7.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/08.png',
                                '很冷',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/6.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/10.png',
                                '頭痛',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/10.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/11.png',
                                '腹痛身',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/9.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/12.png',
                                '下床',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/1.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                            _buildGridItem(
                                context,
                                'assets/images/09.png',
                                '頭暈',
                                onTap: () async {
                                  _audioPlayer.play(AssetSource('audios/11.mp3'));
                                },
                                constraints: BoxConstraints(maxWidth: screenSize.width),
                                fontSize: cardButtonFontSize
                            ),
                          ],

                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom navigation - now included within the SingleChildScrollView
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
// Helper method to build grid items
  Widget _buildGridItem(
      BuildContext context,
      String imagePath,
      String label,
      {required VoidCallback onTap,
        required BoxConstraints constraints,
        required double fontSize}
      ) {
    final double itemWidth = constraints.maxWidth * 0.25;
    final double imageHeight = constraints.maxHeight * 0.12;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: itemWidth,
              maxHeight: imageHeight,
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 8),
        FFButtonWidget(
          onPressed: () {
            print('Button pressed ...');
          },
          text: label,
          options: FFButtonOptions(
            width: itemWidth,
            height: 40.0,
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primaryBtnText,
            textStyle: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Poppins',
              fontSize: fontSize,
            ),
            elevation: 2.0,
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primaryBtnText,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
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
