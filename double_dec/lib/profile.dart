import 'package:artzlearn/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ExtraDetails.dart';
import 'home.dart';
import 'BottomNav.dart';
import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'NoInternet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'course_by_cat.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GoogleSignInAccount _currentUser;
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_profile;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isProfileLoaded = false, enable = true;
  String catName = '';

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  Future<void> _handleSignOut() {
    _googleSignIn.disconnect();
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
  }

  _logout() async {
    _handleSignOut();
    _logOut();
    extraDetails.setshared("UserAuth", '');
    extraDetails.setshared("UserEmail", "");
    extraDetails.setshared("UserFName", "");
    extraDetails.setshared("UserLName", "");
    extraDetails.setshared("UserPhotoUrl", "");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/MyApp', (Route<dynamic> route) => false);
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

  String name = '', photo = '';
  _profile(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_User_Profile",
          "user_id": user_id,
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        decodeProfile(form_response.toString());
        extraDetails.setshared("my_profile", form_response.toString());
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

  decodeProfile(js) {
    setState(() {
      print(js.toString());
      var jsonval = json.decode(js.toString());
      data_profile = jsonval["results"];
      if (data_profile[0]['status'] == "failed") {
        setState(() {
          _isProfileLoaded = false;
        });
      } else if (data_profile[0]['status'] == "success") {
        setState(() {
          name = data_profile[0]['first_name'];
          photo = data_profile[0]['photo'] ?? '';
          _isProfileLoaded = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    extraDetails.getshared("my_profile").then((value) {
      if (value != '' && value != null && value != ' ' && value != 'null') {
        decodeProfile(value);
      } else {
        extraDetails.getshared("UserAuth").then((value) {
          if (value != '' && value != null && value != ' ' && value != 'null') {
            _profile(value);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
          child: new ListView(
        children: [
          new Container(
            color: extraDetails.getBlueColor(),
            child: new Column(
              children: [
                new Padding(
                  padding: new EdgeInsets.all(15.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        child: new AutoSizeText(
                          "Profile",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                extraDetails.getDivider(25.0),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15, 15, 15, 20),
                  child: new Column(
                    children: [
                      photo == ''
                          ? new Icon(
                              Icons.person_pin_rounded,
                              size: 75,
                              color: extraDetails.getWhiteColor(),
                            )
                          : new Image.network(data_profile[0]['photo'],
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.2),
                      new Padding(
                        padding: new EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: new AutoSizeText(
                          "Welcome $name",
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                extraDetails.getDivider(25.0)
              ],
            ),
          ),
          _isProfileLoaded
              ? new Padding(
                  padding: new EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: new Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Card(
                        child: new ListTile(
                          leading: new Icon(
                            Icons.phone_android,
                            color: extraDetails.getBlueColor(),
                          ),
                          title: new AutoSizeText(
                            data_profile[0]['phone_no'],
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
                      new Card(
                        child: new ListTile(
                          leading: new Icon(
                            Icons.email_outlined,
                            color: extraDetails.getBlueColor(),
                          ),
                          title: new AutoSizeText(
                            data_profile[0]['email_id'],
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
                      new GestureDetector(
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(
                              Icons.lock_open,
                              color: extraDetails.getBlueColor(),
                            ),
                            title: new AutoSizeText(
                              "Change Password",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(),
                            ),
                          );
                        },
                      ),
                      new GestureDetector(
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(
                              Icons.shopping_cart_outlined,
                              color: extraDetails.getBlueColor(),
                            ),
                            title: new AutoSizeText(
                              "Cart",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartList(
                                type: 'cart',
                              ),
                            ),
                          );
                        },
                      ),
                      new GestureDetector(
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(
                              Icons.card_giftcard_outlined,
                              color: extraDetails.getBlueColor(),
                            ),
                            title: new AutoSizeText(
                              "Wish List",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartList(
                                type: 'wish',
                              ),
                            ),
                          );
                        },
                      ),
                      new GestureDetector(
                        child: new Card(
                          child: new ListTile(
                            leading: new Icon(
                              Icons.help,
                              color: extraDetails.getBlueColor(),
                            ),
                            isThreeLine: true,
                            subtitle: new AutoSizeText(
                                "Mail us at info@artzlearn.com \nOr\nCall us at +91 73030 93862"),
                            title: new AutoSizeText(
                              "Support",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        onTap: () {
                          launch('mailto:info@artzlearn.com');
                        },
                      ),
                      new GestureDetector(
                          child: new Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.04,
                              margin: new EdgeInsets.all(20.0),
                              padding: new EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                  color: extraDetails.getBlueColor(),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0))),
                              child: new Center(
                                child: new AutoSizeText(
                                  "LOGOUT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              )),
                          onTap: () {
                            _logout();
                          }),
                      new Text("Version: 1.0.6")
                    ],
                  ),
                )
              : new Image.network(
                  "https://artzlearn.com/app-api/vertical_list.gif"),
          extraDetails.getDivider(105.0)
        ],
      )),
      bottomNavigationBar: new BottomNav(
        currentPage: 3,
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  List data;
  TextEditingController pwd = new TextEditingController();
  TextEditingController cpwd = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  String photo = "";
  bool _isSubmitted = false, enable = true;
  void initState() {
    super.initState();
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

  _change(user_id) async {
    setState(() {
      _isSubmitted = true;
    });
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Change_Pwd",
          "password": pwd.text.toString(),
          "user_id": user_id,
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
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: new SafeArea(
            child: new ListView(
          children: [
            new Form(
              key: _formKey,
              child: new Center(
                child: new Column(
                  // shrinkWrap: true,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05,
                          bottom: 8.0),
                      child: new Container(
                        child: new AutoSizeText(
                          "Change Password",
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
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: new TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter New Password';
                            }
                            if (value.length < 6) {
                              return 'Enter New Password is too short';
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
                            labelText: ' New Password',
                            hintText: 'Enter New Password ',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
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
                        height: MediaQuery.of(context).size.height * 0.07,
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
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
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
                                    color: extraDetails.getBlackColor(),
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
                                        showInSnackBar("Please wait...");
                                        extraDetails
                                            .getshared("UserAuth")
                                            .then((value) {
                                          if (value != '' &&
                                              value != null &&
                                              value != ' ' &&
                                              value != 'null') {
                                            print("Changing $value");
                                            print(pwd.text.toString());
                                            _change(value);
                                          }
                                        });
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
        )));
  }
}
