import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'ExtraDetails.dart';
import 'NoInternet.dart';
import 'home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chips_choice/chips_choice.dart';
import 'OTP.dart';

class Register extends StatefulWidget {
  final l_type;
  Register({this.l_type});
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  List data, otp_params;
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController contact = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  TextEditingController pwd = new TextEditingController();
  TextEditingController cpwd = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final _formKey_OTP = GlobalKey<FormState>();
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  String photo = "";
  bool _isSubmitted = false, enable = true;
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      extraDetails.getshared("UserAuth").then((value) {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          // fname.text = value.toString();
        }
      });
      extraDetails.getshared("UserFName").then((value) {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          fname.text = value.toString().split(' ')[0];
          lname.text = value.toString().split(' ')[1];
        }
      });
      extraDetails.getshared("UserLName").then((value) {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          lname.text = value.toString();
        }
      });
      extraDetails.getshared("UserEmail").then((value) {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          email.text = value.toString();
        }
      });
      extraDetails.getshared("UserPhotoUrl").then((value) {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          setState(() {
            photo = value.toString();
          });
        }

        print(photo);
      });
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new AutoSizeText(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.0, fontFamily: 'quickReg', color: Colors.white)),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
    ));
  }

  _sendOtp(_otp, senderid, template1, template2, api_key1, url) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      var api_key = Uri.encodeFull(api_key1);
      var msg = Uri.encodeFull(template1 + " $_otp\n" + template2);
      print(msg);
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          FormData formData = new FormData.fromMap({
            "apikey": api_key,
            "numbers": contact.text.toString(),
            "sender": senderid,
            "message": msg,
          });
          try {
            form_response = await dio.post(
              url,
              data: formData,
            );
          } on DioError catch (e) {
            print(e.message);
          }
        }
        print(form_response.toString());
        showForm();
      } on SocketException catch (_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoInternet()),
            ModalRoute.withName('/NoInternet'));
      }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  _register() async {
    setState(() {
      otp.text = '';
      _isSubmitted = true;
    });
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "signup",
          "first_name": fname.text,
          "last_name": lname.text,
          "contact_no": contact.text,
          "email_id": email.text,
          "password": pwd.text,
          "login_type": widget.l_type.toString() ?? 'Email',
          "img_link": photo,
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got " + form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          data = jsonval["results"];
          if (data[0]['status'] == "failed") {
            if (data[0]['reason'] == "Already_Exist") {
              showInSnackBar("Email or Contact already exists, try again");
            } else {
              showInSnackBar("Something went wrong, try again");
            }
            _isSubmitted = false;
          } else if (data[0]['status'] == "success") {
            showInSnackBar("Completed, please wait...");

            extraDetails.setshared("UserAuth", data[0]['id']);
            extraDetails.setshared("UserFName", data[0]['first_name']);
            extraDetails.setshared("UserLName", data[0]['last_name']);
            extraDetails.setshared("UserEmail", data[0]['email_id']);
            extraDetails.setshared("UserCont", data[0]['phone']);
            extraDetails.setshared("UserPhotoUrl", data[0]['img']);
            Future.delayed(new Duration(seconds: 2), () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserInterest()));
            });
            _isSubmitted = false;
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoInternet()),
            ModalRoute.withName('/NoInternet'));
      }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  var OTP;
  _getOtpParams() async {
    setState(() {
      _isSubmitted = true;
    });
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "GetOtpParams",
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got " + form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          otp_params = jsonval["results"];
          if (otp_params[0]['status'] == "failed") {
            _isSubmitted = false;
          } else if (otp_params[0]['status'] == "success") {
            OTP = new DateTime.now().millisecondsSinceEpoch.toString();
            OTP = OTP.substring(OTP.length - 6, OTP.length);
            _sendOtp(
                OTP,
                otp_params[0]['SenderId'].toString(),
                otp_params[0]['template1']
                    .toString(), //Welcome to double dec, your otp is
                otp_params[0]['template2']
                    .toString(), //, Do not share this with anyone
                otp_params[0]['tempKey'].toString(), //BUksaiuckaslck;s1232asc
                otp_params[0]['smsApiUrl'].toString()); //sms6.rmlconnect.in
            _isSubmitted = false;
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoInternet()),
            ModalRoute.withName('/NoInternet'));
      }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  bool correct = false;
  showForm() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new SizedBox(
                    child: new Text(
                      "Enter OTP sent on ${(contact.text)}",
                      style: new TextStyle(fontSize: 12),
                    ),
                  ),
                  new GestureDetector(
                    child: Icon(Icons.close, size: 24),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              content: new SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: new Form(
                  key: _formKey_OTP,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.01,
                            right: MediaQuery.of(context).size.height * 0.01,
                            bottom: 8.0),
                        child: new SizedBox(
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'OTP cannot be empty';
                              }
                              if (value.length != 6) {
                                return 'Incorrect OTP, try again';
                              }
                            },
                            onChanged: (ad) {
                              setState(() {
                                if (otp.text == OTP) {
                                  correct = true;
                                } else {
                                  correct = false;
                                }
                              });
                            },
                            controller: otp,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            decoration: new InputDecoration(
                              suffix: correct
                                  ? new Icon(Icons.check_box,
                                      color: Colors.green[600])
                                  : new SizedBox(),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: extraDetails.getBlackColor()),
                              labelStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: extraDetails.getBlackColor()),
                              labelText: 'One Time Password',
                              alignLabelWithHint: true,
                              hintText: 'Enter OTP',
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: extraDetails.getBlueColor(),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 14.0,
                                color: extraDetails.getBlackColor()),
                          ),
                        ),
                      ),
                      new Row(children: [
                         SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: extraDetails.getBlueColor(),
                            child: new SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              child:  Text(
                              "VERIFY",
                            textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: extraDetails.getWhiteColor()),
                            ),),
                            onPressed: () {
                              if (_formKey_OTP.currentState.validate()) {
                                _formKey_OTP.currentState.save();
                                setState(() {
                                  if (otp.text == OTP) {
                                    correct = true;
                                    Navigator.pop(context);
                                    _register();
                                  } else {
                                    showInSnackBar(
                                        "OTP Does not match, try again...");
                                    correct = false;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width:150,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: extraDetails.getBlueColor(),
                            child: new SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              child: Text(
                              "RESEND OTP",
                            textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: extraDetails.getWhiteColor()),
                            ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _getOtpParams();
                            },
                          ),
                        ),
                      ),
                      ],),
                     
                      
                    ],
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: new ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            extraDetails.getDivider(40.0),
            new Form(
              key: _formKey,
              child: new Center(
                child: new Column(
                  // shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.03,
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new Container(
                        child: new AutoSizeText(
                          "Register New Account",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: extraDetails.getBlackColor(),
                              fontSize: 24,
                              fontFamily: 'quickBold'),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(25.0),
                    photo == ""
                        ? new SizedBox()
                        : new Image.network(photo,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.2),
                    extraDetails.getDivider(25.0),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new SizedBox(
                        child: new TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name is Mandatory';
                            }
                          },
                          controller: fname,
                          enabled: enable,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelText: 'First Name',
                            alignLabelWithHint: true,
                            hintText: 'Enter First Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: extraDetails.getBlueColor(),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'quickReg',
                              color: extraDetails.getBlackColor()),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(5.0),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new SizedBox(
                        child: new TextFormField(
                          keyboardType: TextInputType.text,
                          controller: lname,
                          enabled: enable,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelText: 'Last Name',
                            alignLabelWithHint: true,
                            hintText: 'Enter Last Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: extraDetails.getBlueColor(),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'quickReg',
                              color: extraDetails.getBlackColor()),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(5.0),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new SizedBox(
                        child: new TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid Contact Number';
                            } else if (value.length != 10) {
                              return 'Invalid Contact Number';
                            }
                          },
                          controller: contact,
                          enabled: enable,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelText: 'Contact Number',
                            alignLabelWithHint: true,
                            hintText: 'Enter Contact Number',
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: extraDetails.getBlueColor(),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'quickReg',
                              color: extraDetails.getBlackColor()),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(5.00),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new SizedBox(
                        child: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid Emaid ID';
                            }
                          },
                          controller: email,
                          enabled: enable,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelText: 'Email ID',
                            hintText: 'Enter Email ID',
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: extraDetails.getBlueColor(),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'quickReg',
                              color: extraDetails.getBlackColor()),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(5.00),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new SizedBox(
                        child: new TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Password';
                            }
                            if (value.length < 6) {
                              return 'Enter Password is too short';
                            }
                          },
                          controller: pwd,
                          enabled: enable,
                          obscureText: true,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelText: 'Password',
                            hintText: 'Enter Password ',
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: extraDetails.getBlueColor(),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'quickReg',
                              color: extraDetails.getBlackColor()),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(5.00),
                    new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new SizedBox(
                        child: new TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Confirm Password';
                            } else if (pwd.text.toString() !=
                                cpwd.text.toString()) {
                              return 'Password & Confirm Password does not match';
                            }
                          },
                          controller: cpwd,
                          enabled: enable,
                          obscureText: true,
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'quickReg',
                                color: extraDetails.getBlackColor()),
                            labelText: 'Confirm Password',
                            alignLabelWithHint: true,
                            hintText: 'Enter Confirm Password',
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: extraDetails.getBlueColor(),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'quickReg',
                              color: extraDetails.getBlackColor()),
                        ),
                      ),
                    ),
                    extraDetails.getDivider(15.00),
                    _isSubmitted
                        ? new Center(
                            child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                extraDetails.getBlackColor()),
                          ))
                        : new InkWell(
                            child: new Padding(
                              padding: new EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.05,
                                  right:
                                      MediaQuery.of(context).size.height * 0.05,
                                  bottom: 8.0),
                              child: new SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.height * 0.6,
                                child: new FlatButton(
                                    color: extraDetails.getBlueColor(),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: new AutoSizeText("CONTINUE",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'quickReg',
                                            color:
                                                extraDetails.getWhiteColor())),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        showInSnackBar(
                                            "Sending OTP to Verify...");
                                        _getOtpParams();
                                        //  showForm() ;
                                      } else {
                                        showInSnackBar(
                                            "Check Details and try again");
                                      }
                                    }),
                              ),
                            ),
                          ),
                    extraDetails.getDivider(5.00),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInterest extends StatefulWidget {
  @override
  _UserInterestState createState() => _UserInterestState();
}

class _UserInterestState extends State<UserInterest> {
  List _catData, data;
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController contact = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pwd = new TextEditingController();
  TextEditingController cpwd = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKeyInte =
      new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  String photo = "";
  bool _isSubmitted = false, enable = true, _isLoaded = false;
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setState(() {
      _getCat();
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKeyInte.currentState.showSnackBar(new SnackBar(
      content: new AutoSizeText(value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.0, fontFamily: 'quickReg', color: Colors.white)),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
    ));
  }

  _save(user_id) async {
    setState(() {
      _isSubmitted = true;
    });
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "UserInterest",
          "user_id": user_id,
          "check_list": tags
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got " + form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          data = jsonval["results"];
          if (data[0]['status'] == "failed") {
            showInSnackBar("Something went wrong, try again");
            _isSubmitted = false;
          } else if (data[0]['status'] == "success") {
            showInSnackBar("Completed, please wait...");
            Future.delayed(new Duration(seconds: 2), () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            });
            _isSubmitted = false;
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoInternet()),
            ModalRoute.withName('/NoInternet'));
      }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  List<String> tags = [];
  List<String> options = [];
  _getCat() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({"Dd_Details": "category"});
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got " + form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          _catData = jsonval["results"];
          if (_catData[0]['status'] == "failed") {
            showInSnackBar("Something went wrong, try again later");
            _isLoaded = false;
          } else if (_catData[0]['status'] == "success") {
            _isLoaded = true;
            for (int c = 0; c < _catData.length; c++) {
              options.add(_catData[c]['cat_name']);
            }
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NoInternet()),
            ModalRoute.withName('/NoInternet'));
      }
    } catch (e, s) {
      print("Error " + e.toString() + " Stack " + s.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKeyInte,
      body: new SafeArea(
        child: Center(
            // padding: const EdgeInsets.all(5.0),
            child: _isLoaded
                ? new Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Image.asset(
                            'assets/double_dec.png',
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.contain,
                          ),
                          extraDetails.getDivider(10.0),
                          new Padding(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text("Select interests to continue",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                              ],
                            ),
                            padding: new EdgeInsets.all(20.0),
                          ),
                          new Card(
                            elevation: 3,
                            child: new Padding(
                              padding: new EdgeInsets.all(10.0),
                              child: new SizedBox(
                                child: ChipsChoice<String>.multiple(
                                  value: tags,
                                  onChanged: (val) => setState(() {
                                    tags = val;
                                    print(tags);
                                  }),
                                  choiceItems:
                                      C2Choice.listFrom<String, String>(
                                    source: options,
                                    value: (i, v) => v,
                                    label: (i, v) => v,
                                  ),
                                  wrapped: true,
                                ),
                              ),
                            ),
                          ),
                          extraDetails.getDivider(30.0),
                          new Padding(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new GestureDetector(
                                  child: new Container(
                                    padding: new EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color: extraDetails.getBlueColor(),
                                      // borderRadius: BorderRadius.circular(50),
                                      // color: Colors.white,
                                      //  borderRadius: BorderRadius.circular(10),
                                      // color: Colors.white,

                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: extraDetails.getBlueColor(),
                                            spreadRadius: 3),
                                      ],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: new Text(
                                      "CONTINUE",
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    extraDetails
                                        .getshared("UserAuth")
                                        .then((value) {
                                      if (value != '' &&
                                          value != null &&
                                          value != ' ' &&
                                          value != 'null') {
                                        // fname.text = value.toString();
                                        _save(value);
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            padding: new EdgeInsets.all(20.0),
                          ),
                        ]),
                  )
                : new CircularProgressIndicator()),
      ),
    );
  }
}
