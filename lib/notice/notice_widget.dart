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


class NoticeWidget extends StatefulWidget {
  const NoticeWidget({Key? key}) : super(key: key);

  @override
  _NoticeWidgetState createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  late NoticeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  Future<List> getData() async{
    var url = Uri.parse(ip+"getdata2.php");
    final responce = await http.post(url,body: {
      "account" : FFAppState().accountnumber,
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
    print(FFAppState().accountnumber);
    print(_model.searchBarController.text);
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  // width: screenSize.width,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: screenSize.width * 1.7,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 10.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 8.0, 0.0),
                                        child: Container(
                                          width: 5.0,
                                          child: TextFormField(
                                            controller:
                                            _model.searchBarController,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall,
                                              hintText: '請輸入日期',
                                              hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 20.0,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color:
                                                  FlutterFlowTheme.of(context)
                                                      .lineColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(12.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(12.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(12.0),
                                              ),
                                              focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(12.0),
                                              ),
                                              filled: true,
                                              fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                              contentPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24.0, 24.0, 20.0, 24.0),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                            validator: _model
                                                .searchBarControllerValidator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 12.0, 12.0, 0.0),
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30.0,
                                        borderWidth: 1.0,
                                        buttonSize: 50.0,
                                        icon: Icon(
                                          Icons.search_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          print('IconButton pressed ...');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: screenSize.height * 0.6, // 考慮設備比例
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                                child:FutureBuilder<List>(
                                  future: getData(),
                                  builder: (ctx,ss) {
                                    if(ss.hasError){
                                      print("error");
                                    }
                                    if(ss.hasData){
                                      return Items(list:ss.data);
                                    }
                                    else{
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                // ),
              ],
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
class Items extends StatefulWidget {

  List? list;

  Items({this.list});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Set<int> readMessages = {}; // 保存已讀訊息的索引值
  @override
  Widget build(BuildContext context) {
    Widget divider0 = const Divider(
      color: Colors.red,
      thickness: 3,
    );
    Widget divider1 = const Divider(
      color: Colors.orange,
      thickness: 3,
    );
    Widget divider2 = Divider(
      color: Colors.yellow.shade600,
      thickness: 3,
    );
    Widget divider3 = const Divider(
      color: Colors.green,
      thickness: 3,
    );
    Widget divider4 = const Divider(
      color: Colors.blue,
      thickness: 3,
    );
    Widget divider5 = Divider(
      color: Colors.blue.shade900,
      thickness: 3,
    );
    Widget divider6 = const Divider(
      color: Colors.purple,
      thickness: 3,
    );
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
                  title: Text('內容'),
                  content: Text(widget.list![i]['content']),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext),
                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
            leading: Icon(
              Icons.circle,
              size: 30,
              color: readMessages.contains(i)
                  ? Colors.grey
                  : Colors.black, // 已讀訊息使用灰色
            ),

            title: Text(
              widget.list![i]['title']+"                     "+widget.list![i]['time'],
              textAlign: TextAlign.justify,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Poppins',
                fontSize: 25,
              ),
            ),

            subtitle: Text(
              widget.list![i]['content']
              /*widget.list![i]['time']*/,
              overflow: TextOverflow.ellipsis,    //溢出的話會...
              maxLines: 2,                        //最大行數2行
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Poppins',
                fontSize: 19,
              ),
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