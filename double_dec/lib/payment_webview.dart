import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:artzlearn/learn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'ExtraDetails.dart';
import 'NoInternet.dart';
import 'home.dart';
import 'package:artzlearn/main.dart';
import 'package:flutter/material.dart';
import 'ExtraDetails.dart';
import 'BottomNav.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentWebView extends StatefulWidget {
  final order_id, amt;
  PaymentWebView({this.order_id, this.amt});
  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  String kAndroidUserAgent =
      'Mozilla/5.0 (Linux; Android 10.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

  ExtraDetails extraDetails = new ExtraDetails();
  String order_id = '',
      amt = '',
      fname = '',
      lname = '',
      email = '',
      contact = '',
      _url = '';
  bool _gotAllValue = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order_id = widget.order_id.toString();
    amt = widget.amt.toString();
    extraDetails.getshared("UserFName").then((value) {
      setState(() {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          fname = value;
        } else {
          fname = 'App';
        }
      });
    });
    extraDetails.getshared("UserLName").then((value) {
      setState(() {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          lname = value;
        } else {
          fname = 'User';
        }
      });
    });
    extraDetails.getshared("UserEmail").then((value) {
      setState(() {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          email = value;
        } else {
          email = '';
        }
      });
    });
    extraDetails.getshared("UserCont").then((value) {
      setState(() {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          contact = value;
        } else {
          contact = '91XXXXXX';
        }
      });
    });
    Future.delayed(new Duration(seconds: 1), () {
      setState(() {
        _url =
            'https://vidyakite.com/double_dec/PayU/index.php?amount=$amt&phone=$contact&firstname=$fname&email=$email&productinfo=Payment%20of%20Rs%20$amt%20for%20Course%20&surl=https://vidyakite.com/double_dec/PayU/success.php&furl=https://vidyakite.com/double_dec/PayU/success.php&curl=https://vidyakite.com/double_dec/PayU/success.php&udf1=$order_id';
        // _url =
        //     'https://www.payumoney.com/payment/postBackParam.do?paymentId=D408AB0B71142869810385FFC7AB35A0&expired=1';
        _gotAllValue = true;
      });
    });
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print('onUrlChanged: $url');
          if (url == 'https://vidyakite.com/double_dec/PayU/success_payment.php?status=success' ||
              url ==
                  'https://vidyakite.com/double_dec/PayU/success_payment.php?status=success' ||
              url.contains("success_payment.php?status=success")) {
            flutterWebViewPlugin.stopLoading();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentStatus(status: 'success')));
          }
          if (url == 'https://vidyakite.com/double_dec/PayU/success_payment.php?status=failed' ||
              url ==
                  'https://vidyakite.com/double_dec/PayU/success_payment.php?status=failed' ||
              url.contains("success_payment.php?status=failed")) {
            flutterWebViewPlugin.stopLoading();
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentStatus(status: 'failed'
                        // order_id: payment_data[0]['order_id'],
                        // amt: price,
                        )));
          }
        });
      }
    });
  }

  // ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return _gotAllValue
        ? new WebviewScaffold(
            url: _url,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: false,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: new Container(
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          )
        : new Container(
            color: Colors.white,
            child: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
  }
}

class PaymentStatus extends StatefulWidget {
  final status;
  PaymentStatus({this.status});
  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 10),
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Image.asset(
                    'assets/double_dec.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.contain,
                  ),
                  new Text(
                    widget.status == 'success'
                        ? 'Payment Completed'
                        : "Payment Failed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  new Icon(
                    widget.status == 'success'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        widget.status == 'success' ? Colors.green : Colors.red,
                    size: 200.0,
                  ),
                  Container(
                    height: 20.0,
                    width: 1,
                    // color: Colors.black,
                    // color: ed.getIBLSubtitle(),
                  ),
                  new Padding(
                      padding: new EdgeInsets.all(15.0),
                      child: new Text(
                        widget.status == 'success'
                            ? 'You can check this course in \n"MY COURSE"'
                            : "Something went wrong, please try again",
                            textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new GestureDetector(
                          child: new Card(
                            color: extraDetails.getBlueColor(),
                            child: new Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              // color: Colors.black.withOpacity(0.8),
                              child: new Padding(
                                padding: new EdgeInsets.fromLTRB(15, 5, 15, 5),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Expanded(
                                      child: new AutoSizeText(
                                        "CLOSE",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color:
                                                extraDetails.getWhiteColor()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            extraDetails.setshared("cart_list", '');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LearnPage()));
                          }),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
