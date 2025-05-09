import 'dart:convert';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notice_model.dart';
export 'notice_model.dart';
import 'package:http/http.dart' as http;
import '/main.dart';
import 'package:go_router/go_router.dart';

class NoticeWidget extends StatefulWidget {
  const NoticeWidget({Key? key}) : super(key: key);

  @override
  _NoticeWidgetState createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  late NoticeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  Future<List> getData() async {
    var url = Uri.parse(ip + "getdata2.php");
    final responce = await http.post(url, body: {
      "account": FFAppState().accountnumber,
      "time": _model.searchBarController.text,
    });

    return jsonDecode(responce.body);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoticeModel());

    _model.searchBarController ??= TextEditingController();
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

    final titleFontSize = isLandscape ? screenHeight * 0.07 : screenWidth * 0.08;
    final searchBarHeight = isLandscape ? screenHeight * 0.12 : screenHeight * 0.08;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: Color(0xFF90BDF9), // Consistent background color
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Fixed Header Area
              Container(
                width: double.infinity,
                height: isLandscape ? screenHeight * 0.15 : screenHeight * 0.1,
                color: Color(0xFF90BDF9),
                padding: EdgeInsets.symmetric(
                    vertical: isLandscape ? screenHeight * 0.01 : screenHeight * 0.01),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center, // Center the title
                  children: [
                    Text(
                      '新通知',
                      textAlign: TextAlign.center, // Ensure text itself is centered
                      style: FlutterFlowTheme.of(context)
                          .displaySmall
                          .override(
                        fontFamily: 'Poppins',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable Content Area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isLandscape ? screenWidth * 0.03 : screenWidth * 0.02,
                    screenHeight * 0.02,
                    isLandscape ? screenWidth * 0.03 : screenWidth * 0.02,
                    screenHeight * 0.02,
                    ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, isLandscape ? 16.0 : 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                height: searchBarHeight,
                                child: TextFormField(
                                  controller: _model.searchBarController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelStyle: FlutterFlowTheme.of(context).bodySmall,
                                    hintText: '請輸入日期',
                                    hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Poppins',
                                          fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.04,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).lineColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                    contentPadding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 20.0, 12.0),
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                     fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.045,
                                  ),
                                  validator: _model.searchBarControllerValidator.asValidator(context),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 30.0,
                                borderWidth: 1.0,
                                buttonSize: searchBarHeight, // Make button height same as search bar
                                icon: Icon(
                                  Icons.search_sharp,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: isLandscape ? screenHeight * 0.05 : screenWidth * 0.07,
                                ),
                                onPressed: () {
                                  setState(() {}); // Trigger rebuild to refresh FutureBuilder
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List>(
                          future: getData(),
                          builder: (ctx, ss) {
                            if (ss.hasError) {
                              return Center(child: Text('載入錯誤: ${ss.error}'));
                            }
                            if (ss.hasData) {
                              if (ss.data!.isEmpty) {
                                return Center(child: Text('沒有找到相關通知', style: TextStyle(fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.045)));
                              }
                              return Items(list: ss.data, isLandscape: isLandscape);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fixed Bottom Navigation Bar
              Container(
                width: double.infinity,
                height: isLandscape ? screenHeight * 0.18 : screenHeight * 0.15,
                color: FlutterFlowTheme.of(context).primaryBtnText,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBottomNavItem(context, 'assets/images/17.jpg', '返回',
                        onTap: () => context.pushNamed('home')),
                    _buildBottomNavItem(context, 'assets/images/18.jpg', '使用紀錄',
                        onTap: () => context.pushNamed('documental')),
                    _buildBottomNavItem(context, 'assets/images/19.jpg', '新通知',
                        onTap: () => context.pushNamed('notice')),
                    _buildBottomNavItem(context, 'assets/images/20.jpg', '關於',
                        onTap: () => context.pushNamed('about')),
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

Widget _buildBottomNavItem(
    BuildContext context,
    String imagePath,
    String label,
    {VoidCallback? onTap}) {
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  final iconWidth = isLandscape ? screenHeight * 0.08 : screenWidth * 0.12;
  final iconHeight = isLandscape ? screenHeight * 0.08 : screenWidth * 0.12;
  final fontSize = isLandscape ? screenHeight * 0.03 : screenWidth * 0.04;

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

class Items extends StatefulWidget {
  List? list;
  final bool isLandscape;

  Items({this.list, required this.isLandscape});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Set<int> readMessages = {}; // 保存已讀訊息的索引值
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final titleFontSize = widget.isLandscape ? screenHeight * 0.035 : screenWidth * 0.045;
    final subtitleFontSize = widget.isLandscape ? screenHeight * 0.03 : screenWidth * 0.038;
    final iconSize = widget.isLandscape ? screenHeight * 0.04 : screenWidth * 0.06;

    Widget divider0 = const Divider(color: Colors.red, thickness: 3);
    Widget divider1 = const Divider(color: Colors.orange, thickness: 3);
    Widget divider2 = Divider(color: Colors.yellow.shade600, thickness: 3);
    Widget divider3 = const Divider(color: Colors.green, thickness: 3);
    Widget divider4 = const Divider(color: Colors.blue, thickness: 3);
    Widget divider5 = Divider(color: Colors.blue.shade900, thickness: 3);
    Widget divider6 = const Divider(color: Colors.purple, thickness: 3);

    Widget ChooseDivider(int index) {
      return index % 7 == 0
          ? divider0
          : index % 7 == 1
              ? divider1
              : index % 7 == 2
                  ? divider2
                  : index % 7 == 3
                      ? divider3
                      : index % 7 == 4
                          ? divider4
                          : index % 7 == 5
                              ? divider5
                              : divider6;
    }

    return ListView.separated(
      itemCount: widget.list!.length,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (ctx, i) {
        return GestureDetector(
          onTap: () async {
            setState(() {
              readMessages.add(i);
            });
            await showDialog(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('內容', style: TextStyle(fontSize: titleFontSize * 1.2)),
                  content: Text(widget.list![i]['content'], style: TextStyle(fontSize: subtitleFontSize)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok', style: TextStyle(fontSize: subtitleFontSize)),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
            leading: Icon(
              Icons.circle,
              size: iconSize,
              color: readMessages.contains(i)
                  ? Colors.grey
                  : Colors.black, // 已讀訊息使用灰色
            ),
            title: Text(
              widget.list![i]['title'] + "                     " + widget.list![i]['time'],
              textAlign: TextAlign.justify,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Poppins',
                    fontSize: titleFontSize,
                  ),
            ),
            subtitle: Text(
              widget.list![i]['content'] /*widget.list![i]['time']*/,
              overflow: TextOverflow.ellipsis, //溢出的話會...
              maxLines: 2, //最大行數2行
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    fontSize: subtitleFontSize,
                  ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.isLandscape ? screenWidth * 0.02 : screenWidth * 0.03,
              vertical: 8.0
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return ChooseDivider(index);
      },
    );
  }
}