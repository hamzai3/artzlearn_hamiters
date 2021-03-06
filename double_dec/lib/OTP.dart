import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'ExtraDetails.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'NoInternet.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OtpView extends StatefulWidget {
  final WOTP, contact;

  OtpView({this.WOTP, this.contact});

  @override
  _OtpViewState createState() => _OtpViewState();
}

ExtraDetails extraDet = new ExtraDetails();

class _OtpViewState extends State<OtpView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController entered_otp = new TextEditingController();

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

  String _code = "";
  String signature = "{{ app signature }}";

  int _start = 60;
  var OTP;
  Timer _timer;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _start = 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generate_OTP();
  }

  generate_OTP() {
    setState(() {
      entered_otp = new TextEditingController(text: '');
      OTP = "";
      Random rnd = new Random();
      for (int i = 0; i < 5; i++) {
        var l = 1 + rnd.nextInt(9 - 1);
        OTP = OTP + "" + l.toString();
      }
      print(OTP.trim());
      _sendOTP(OTP.toString());
    });
    return OTP;
  }

  getTimeAutoSizeText() {
    return new Padding(
      padding: new EdgeInsets.all(15.0),
      child: new AutoSizeText(
        "Waiting $_start seconds. before resending OTP",
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }

  verify_otp() {
    print("Entered ${(entered_otp.text.toString())}  original was $OTP");
    if (entered_otp.text.toString() == OTP.trim()) {
// Verified
    } else {
      showInSnackBar("Invalid Code, please check message sent to you on " +
          widget.contact.toString());
    }
  }

  Future<void> _sendOTP(_tempOTP) async {
    showInSnackBar("Sending OTP, check SMS for OTP");
//    http://sms6.rmlconnect.net:8080/bulksms/bulksms?username=MartTr&password=PsBsglGr&type=0&dlr=1&destination=9867602207&source=Demo&message=Demo%20Message
    String msg = _tempOTP +
        "%20Is%20Your%20Mart%20To%20Kart%20One%20Time%20Password,%20registered%20on%20" +
        widget.contact.toString() +
        ".%20Note:%20Please%20DO%20NOT%20SHARE%20this%20OTP%20with%20anyone";
    var dio = new Dio();
    var url =
        "http://sms6.rmlconnect.net:8080/bulksms/bulksms?username=MartTr&password=PsBsglGr&type=0&dlr=1&destination=${(widget.contact.toString())}&source=MRTKRT&message=$msg";
//        "http://trans.smsfresh.co/api/sendmsg.php?user=neatfox&pass=123456&sender=AAZIDO&phone=" +      ${(mobile_number.text.toString())}
//            mobile_number.text +
//            "&text=" +
//            msg +
//            "&priority=ndnd&stype=normal";
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        Response dio_response = await dio.post(
          url,
        );
      } on DioError catch (e) {
        print(e.message);
      }
      // OtP SENT
//      _startTimer();
//      generate_OTP();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NoInternet()),
          ModalRoute.withName('/NoInternet'));
    }
  }

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(),
              new AutoSizeText(
                "ENTER OTP",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    fontFamily: 'ralewayRegular'),
              ),
              Spacer(),
              new Center(
                child: new PinCodeTextField(
                  autofocus: true,
                  pinBoxWidth: 55.0,
                  pinBoxHeight: 50.0,
                  controller: entered_otp,
                  highlight: true,
                  highlightColor: extraDet.getBlackColor(),
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.black,
                  maxLength: 5,
                  hasError: hasError,
                  onTextChanged: (text) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  onDone: (text) {
                    print("DONE $text");
                    verify_otp();
                  },
                  wrapAlignment: WrapAlignment.center,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 18.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 10),
                ),
              ),
              Spacer(),
              Spacer(),
              _start == 0
                  ? new SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: new Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0),
                        child: new Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          color: extraDet.getBlackColor(),
                          child: new Padding(
                            child: new CupertinoButton(
                              padding: EdgeInsets.all(0.0),
                              child: new AutoSizeText(
                                "RESEND OTP",
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'ralewayRegular',
                                  color: extraDet.getWhiteColor(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                generate_OTP();
                              },
                            ),
                            // padding: EdgeInsets.only(
                            //   left: 80.0,
                            //   right: 80.0,
                            // ),
                          ),
                        ),
                      ),
                    )
                  : getTimeAutoSizeText(),
            ],
          ),
        ));
  }
}
