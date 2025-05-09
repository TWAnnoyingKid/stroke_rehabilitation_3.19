import '../main.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'documental_model.dart';
export 'documental_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

class DocumentalWidget extends StatefulWidget {
  const DocumentalWidget({Key? key}) : super(key: key);

  @override
  _DocumentalWidgetState createState() => _DocumentalWidgetState();
}

class _DocumentalWidgetState extends State<DocumentalWidget> {
  late DocumentalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  Future<List> getData() async {
    var url = Uri.parse(ip + "getdata1.php");
    final responce = await http.post(url, body: {
      "account": FFAppState().accountnumber,
      "action": _model.searchBarController.text,
    });
    return jsonDecode(responce.body);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DocumentalModel());

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
        backgroundColor: Color(0xFF90BDF9),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: isLandscape ? screenHeight * 0.15 : screenHeight * 0.1,
                color: Color(0xFF90BDF9),
                padding: EdgeInsets.symmetric(
                    vertical: isLandscape ? screenHeight * 0.01 : screenHeight * 0.01),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '使用紀錄',
                      textAlign: TextAlign.center,
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
                                    labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Poppins',
                                      fontSize: isLandscape ? screenHeight * 0.03 : screenWidth * 0.04,
                                    ),
                                    hintText: '請輸入訓練動作',
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
                                buttonSize: searchBarHeight,
                                icon: Icon(
                                  Icons.search_sharp,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: isLandscape ? screenHeight * 0.05 : screenWidth * 0.07,
                                ),
                                onPressed: () {
                                   setState(() {});
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
                              if (ss.data!.isEmpty){
                                return Center(child: Text('沒有找到相關紀錄', style: TextStyle(fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.045)));
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
              Container(
                width: double.infinity,
                height: isLandscape ? screenHeight * 0.15 : screenHeight * 0.15,
                color: FlutterFlowTheme.of(context).primaryBtnText,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBottomNavItem(context, 'assets/images/17.jpg', '主頁',
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

class Items extends StatelessWidget {
  final List? list;
  final bool isLandscape;

  const Items({Key? key, this.list, required this.isLandscape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final List<dynamic> displayList = list?.reversed.toList() ?? [];

    final titleFontSize = isLandscape ? screenHeight * 0.035 : screenWidth * 0.04;
    final subtitleFontSize = isLandscape ? screenHeight * 0.03 : screenWidth * 0.035;
    final iconSize = isLandscape ? screenHeight * 0.05 : screenWidth * 0.05;

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
      itemCount: displayList.length,
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isLandscape ? screenWidth * 0.01 : screenWidth * 0.02,
      ),
      itemBuilder: (ctx, i) {
        final item = displayList[i] as Map<String, dynamic>;
        return ListTile(
          leading: Container(
            width: iconSize * 1.2,
            height: iconSize * 1.2,
            alignment: Alignment.center,
            child: Icon(
              Icons.message,
              size: iconSize,
            ),
          ),
          title: Text(
            '${item['degree']}  ${item['parts']}  ${item['action']}',
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Poppins',
                  fontSize: titleFontSize,
                ),
          ),
          subtitle: Text(
            '${item['time']}',
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Poppins',
                  fontSize: subtitleFontSize,
                ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isLandscape ? screenWidth * 0.02 : screenWidth * 0.03,
            vertical: 8.0,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return ChooseDivider(index);
      },
    );
  }
}