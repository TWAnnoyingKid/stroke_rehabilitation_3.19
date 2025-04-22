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
import '/main.dart';

class DocumentalWidget extends StatefulWidget {
  const DocumentalWidget({Key? key}) : super(key: key);

  @override
  _DocumentalWidgetState createState() => _DocumentalWidgetState();
}

class _DocumentalWidgetState extends State<DocumentalWidget> {
  late DocumentalModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  Future<List> getData() async{
    var url = Uri.parse(ip+"getdata1.php");
    final responce = await http.post(url,body: {
      "account" : FFAppState().accountnumber,
      "action" :_model.searchBarController.text,

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: screenSize.width,
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
                                                  .bodySmall
                                                  .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 25.0,
                                              ),
                                              hintText: '請輸入訓練動作',
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
                                                .bodyMedium
                                                .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 20.0,
                                            ),
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
class Items extends StatelessWidget {

  List? list;

  Items({this.list});

  @override
  Widget build(BuildContext context) {
    //Widget divider1=Divider(color: Colors.blue, thickness: 3.0,);
    //Widget divider2=Divider(color: Colors.green,thickness: 3.0,);
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
// 獲取螢幕尺寸
    final screenSize = MediaQuery.of(context).size;

    return ListView.separated(
      itemCount: list!.length,  // 列表的數量
      padding: EdgeInsets.symmetric(
        vertical: screenSize.width * 0.02,
        horizontal: screenSize.width * 0.03, // 根據螢幕寬度的比例設置內邊距
      ),
      itemBuilder: (ctx, i) {    // 列表的構建器
        return ListTile(
          leading: Container(
            width: screenSize.width * 0.08,  // 圖標容器寬度為螢幕寬度的8%
            height: screenSize.width * 0.08,  // 保持正方形比例
            alignment: Alignment.center,
            child: Icon(
              Icons.message,
              size: screenSize.width * 0.05,  // 圖標大小為螢幕寬度的5%
            ),
          ),
          title: Text(
            list![i]['degree'] + '  ' + list![i]['parts'] + '  ' + list![i]['action'],
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: 'Poppins',
              fontSize: screenSize.width * 0.04,  // 標題字體大小為螢幕寬度的4%
            ),
          ),
          subtitle: Text(
            list![i]['time'],
            textAlign: TextAlign.start,
            style: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Poppins',
              fontSize: screenSize.width * 0.03,  // 副標題字體大小為螢幕寬度的3%
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.03,
            vertical: screenSize.width * 0.02,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return ChooseDivider(index);
      },
    );
  }
}