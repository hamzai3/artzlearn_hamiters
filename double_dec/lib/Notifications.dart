import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'NoInternet.dart';
import 'dart:io';
import 'BottomNav.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'ExtraDetails.dart';
import 'package:auto_size_text/auto_size_text.dart';
class Notifications extends StatefulWidget {
  final url;

  Notifications({this.url});

  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  String result;
  List data = [];
  var _email = "";
  bool _isLoading = true, no_results;
  String err = "";
  Response form_response;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new AutoSizeText(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'ralewayRegular',
              color: Colors.white)),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
    ));
  }

  _GetNotifictaions(name) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
// print("url "+"https://www.azido.in/cms/REST-API/REST-Functions.php"+"\n"+"email "+email.text+"\n"+"password "+password.text);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "NeedDetailsOf": "Notifications",
          "name": name,
        });
        try {
          form_response = await dio.post(
            ed.getURL(),
            // 'https://rachanasansad.edu.in//admin/home/api/Restapi_r.php',
            data: formData,
//            onSendProgress: showDownloadProgress,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got in nogtifictaions" +
              form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          data = jsonval["results"];
          print("Response got in nogtifictaions $data ");
          if (data.length == null || data.length == 0) {
            _isLoading = false;
            no_results = false;
            err = "No Notification Found";
            showInSnackBar("No Notificaitions found");
          } else {
            if (data[0]['status'] == 'failed') {
              err = "No Notification Found";
              showInSnackBar("No Notificaitions found");
              _isLoading = false;
              no_results = true;
            }else{
              
          _isLoading = false;
          no_results = false;
            }
          }
        });
      } else {
        setState(() {
          showInSnackBar("No internet connection found ");
          //  CupertinoDailog(
          //      "Sorry!", "No Internet Connection Found", "Try Again");
        });
      }
    } catch (e, s) {
      // showInSnackBar("Something went wrong, check network.");
      print("Error " + e.toString() + " Stack " + s.toString());
    }
    SocketException(message) {
      showInSnackBar("Something went wrong, check network.");
    }
  }

  ExtraDetails ed = new ExtraDetails();
  String app_name = '';
  var toekn;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      ed.getshared("name_expected").then((value) {
        _GetNotifictaions(value);
      });
      ed.getshared("SIName_expected").then((value) {
        app_name = value;
      });
      //
    });
  }

  void _showDialog(String title, String body, String btnText) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new AutoSizeText(title),
          content: new AutoSizeText(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new AutoSizeText(btnText),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new NoInternet()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new AutoSizeText(
              "Notifications",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Mont',
                  fontSize: 16.0,
                  letterSpacing: 1.1,
                  color: Colors.white),
            ),
          ],
        ),
        backgroundColor: new Color(0xfff1b700),
      ),
      //  new CupertinoNavigationBar(
      //   backgroundColor: new Color(0xfff1b700),
      //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
      //   // backgroundColor: extraDet.getBrownColor(),
      //   // actionsForegroundColor: getWhiteColor(),
      //   automaticallyImplyLeading: false,
      //   transitionBetweenRoutes: false,
      // middle: new AutoSizeText(
      //   "$app_name\nNotifications",
      //   style: TextStyle(
      //       fontFamily: 'Mont',
      //       fontSize: 16.0,
      //       letterSpacing: 1.1,
      //       color: Colors.white),
      // ),
      // ),
      body: new SafeArea(
        child: _isLoading
            ? new Center(
                child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xffffb619)),
                ),
              )
            : no_results
                ? new Center(
                    child: new AutoSizeText("No Notifications Found",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Mont',
                        )),
                  )
                : new ListView.builder(
                    itemCount: data == null ? 0 : data.length ?? 0,
                    itemBuilder: (BuildContext context, int i) {
                      return new Column(
                        children: <Widget>[
                          new Divider(
                            height: 15.0,
                            color: Colors.transparent,
                          ),

                          data[i]["title"].toString().trim() != 'null'
                              ? new Card(
                                  margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  elevation: 4.0,
                                  child: new ExpansionTile(
                                    title: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Expanded(
                                              child: new AutoSizeText(
                                                data[i]["title"]
                                                    .toString()
                                                    .trim(),
                                                style: new TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontFamily: 'Mont',
                                                    fontSize: 18),
                                              ),
                                            )
                                          ],
                                        ),
                                        new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new AutoSizeText(
                                              "" +
                                                  data[i]["added_on"]
                                                      .toString()
                                                      .trim(),
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    children: <Widget>[
                                      new Container(
                                        padding: new EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          bottom: 15.0,
                                        ),
                                        child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                new Expanded(
                                                  child: new AutoSizeText(
                                                      data[i]["description"]
                                                          .toString()
                                                          .trim(),
                                                      style: new TextStyle(
                                                          fontFamily: 'Mont',
                                                          fontSize: 16)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : new SizedBox(),
                          new Divider(
                            height: 5,
                          )
                        ],
                      );
                    },
                  ),
      ),
      bottomNavigationBar: new BottomNav(
        currentPage: 3,
        url: widget.url,
      ),
    );
  }
}
