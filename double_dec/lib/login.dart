import 'package:artzlearn/home.dart';
import 'package:flutter/material.dart';
import 'ExtraDetails.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'register.dart';
import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'NoInternet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  ExtraDetails extraDetails = new ExtraDetails();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleSignInAccount _currentUser;
  String _contactText;
  String result;
  bool _isLoading = false, no_results;
  List data = [];
  String err = "";
  Response form_response;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
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
  }

  Future<void> _handleSignOut() {
    _googleSignIn.disconnect();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((user) {
        // showInSnackBar("Please Wait");
        print(user.displayName);
        print(user.email);
        print(user.photoUrl);
        extraDetails.setshared("UserEmail", user.email.toString());
        extraDetails.setshared("UserFName", user.displayName.toString());
        extraDetails.setshared("UserPhotoUrl", user.photoUrl.toString());
        _checkLogin(user.email, 'Google');
      });
    } catch (error) {
      print(error);
    }
  }

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _fb_login() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        final FacebookAccessToken icon = result.accessToken;
        // accessToken
        // showInSnackBar('''
        //  Logged in!

        //  Token: ${accessToken.token}
        //  User id: ${accessToken.userId}
        //  Expires: ${accessToken.expires}
        //  Permissions: ${accessToken.permissions}
        //  Declined permissions: ${accessToken.declinedPermissions}
        //  ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        showInSnackBar('Login cancelled, try again.');
        break;
      case FacebookLoginStatus.error:
        showInSnackBar('Something went wrong, try again');
        break;
    }
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    print(profile);
    print(profile['email']);

    extraDetails.setshared("UserEmail", profile['email']);
    extraDetails.setshared("UserFName", profile['first_name']);
    extraDetails.setshared("UserLName", profile['last_name']);
    extraDetails.setshared("UserPhotoUrl",
        'http://graph.facebook.com/${(profile['id'])}/picture?width=300&height=300');
    _checkLogin(profile['email'], 'facebook');
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
    showInSnackBar('Logged out.');
  }

  var msg = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  showForm() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text("Enter Login Details"),
                  new GestureDetector(
                    child: Icon(Icons.close, size: 24),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              content: new SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: new Form(
                  key: _formKey,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics()'',
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.01,
                            right: MediaQuery.of(context).size.height * 0.01,
                            bottom: 8.0),
                        child: new SizedBox(
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Email is Mandatory';
                              }
                            },
                            controller: email,
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
                              labelText: 'Email',
                              alignLabelWithHint: true,
                              hintText: 'Enter Email',
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
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.01,
                            right: MediaQuery.of(context).size.height * 0.01,
                            bottom: 8.0),
                        child: new SizedBox(
                          child: new TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Password is Mandatory';
                              }
                            },
                            controller: password,
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
                              alignLabelWithHint: true,
                              hintText: 'Enter Password',
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: extraDetails.getBlueColor(),
                          child: Text(
                            "Continue",
                            style:
                                TextStyle(color: extraDetails.getWhiteColor()),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              Navigator.pop(context);
                              _checkLogin(email.text.toString(), 'Email');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Row(children: [
        new Expanded(
          child: new AutoSizeText(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'ralewayRegular',
                  color: Colors.white)),
        )
      ]),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 5.0,
    ));
  }

  _checkLogin(email, type) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
// print("url "+"https://www.azido.in/cms/REST-API/REST-Functions.php"+"\n"+"email "+email.text+"\n"+"password "+password.text);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "login",
          "email": email,
          "type": type,
          "password": password.text.toString(),
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            // 'https://rachanasansad.edu.in//admin/home/api/Restapi_r.php',
            data: formData,
//            onSendProgress: showDownloadProgress,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        setState(() {
          print("Response got in login" + form_response.toString().trim());
          var jsonval = json.decode(form_response.toString());
          data = jsonval["results"];

          if (data[0]['status'] == 'failed') {
            if (data[0]['reason'] == 'type_mismatch') {
              setState(() {
                _isLoading = false;
              });
              if (type != 'facebook' || type != 'Google') {
                showInSnackBar("You have registered using Email, try again");
              } else {
                showInSnackBar(
                    "You have registered using Social Media Account, try again");
              }
            } else if (data[0]['reason'] == 'no_record_found') {
              if (type != 'Email') {
                setState(() {
                  _isLoading = false;
                });
                showInSnackBar("Welcome to Artzlearn, please wait...");
                Future.delayed(new Duration(seconds: 2), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Register(
                                l_type: type,
                              )));
                });
              } else {
                showInSnackBar("Incorrect Password, try again");
                setState(() {
                  _isLoading = false;
                });
              }
            } else {
              showInSnackBar("Incorrect Password, try again");
              setState(() {
                _isLoading = false;
              });
            }
            _isLoading = false;
            no_results = true;
          } else {
            if (data[0]['login_status'] == 'A') {
              setState(() {
                _isLoading = false;
              });
              showInSnackBar("Successfull, please wait...");

              extraDetails.setshared("UserAuth", data[0]['id']);
              extraDetails.setshared("UserFName", data[0]['first_name']);
              extraDetails.setshared("UserLName", data[0]['last_name']);
              extraDetails.setshared("UserEmail", data[0]['email_id']);
              extraDetails.setshared("UserCont", data[0]['phone']);
              extraDetails.setshared("UserPhotoUrl", data[0]['img']);
              _isLoading = false;
              no_results = false;
              Future.delayed(new Duration(seconds: 2), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              });
            } else {
              setState(() {
                _isLoading = false;
              });
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Account not verified, check your email for verifictaion link",
                  style: new TextStyle(color: Colors.white),
                ),
                backgroundColor: extraDetails.getBlackColor(),
                duration: Duration(seconds: 15),
                action: SnackBarAction(
                  label: "Resend Link",
                  textColor: Colors.white,
                  onPressed: () async {
                    _scaffoldKey.currentState.hideCurrentSnackBar;
                    try {
                      form_response = await dio.post(
                        extraDetails.getURL(),
                        data: new FormData.fromMap({
                          "Dd_Details": "ResendMail",
                          "email": data[0]['email_id'],
                        }),
                      );
                    } on DioError catch (e) {
                      print(e.message);
                    }
                    print(form_response.toString());
                    showInSnackBar("Mail Sent!");
                  },
                ),
              ));
            }
          }
        });
      } else {
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoInternet()));
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: new SafeArea(
        child: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Image.asset(
                      'assets/double_dec.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.contain,
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(25.00),
                      child: new AutoSizeText(
                        'Learn from best instructors on Artzlearn, all your music learning in one app',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    new GestureDetector(
                      child: new Container(
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            new Image.asset(
                              "assets/google.png",
                              width: 30,
                            ),
                            new AutoSizeText(
                              'Continue with Google',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => HomePage()));
                        _handleSignIn();
                      },
                    ),
                    extraDetails.getDivider(20.0),
                    new GestureDetector(
                      child: new Container(
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            new Image.asset(
                              "assets/FB.png",
                              width: 40,
                            ),
                            new AutoSizeText(
                              'Continue With Facebook',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _fb_login();
                      },
                    ),
                    extraDetails.getDivider(15.0),
                    new Container(
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.black,
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        height: 5,
                        child: new AutoSizeText("")),
                    extraDetails.getDivider(15.0),
                    new GestureDetector(
                      child: new Container(
                        decoration: BoxDecoration(
                          border: new Border.all(
                            color: Colors.grey.shade600,
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.grey.shade600,
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new AutoSizeText(
                              'Continue with Email',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        showForm();
                      },
                    ),
                    extraDetails.getDivider(20.0),
                    new GestureDetector(
                        child: new Padding(
                          padding: new EdgeInsets.all(25.00),
                          child: new AutoSizeText(
                            'New to Artzlearn? Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                // fontWeight: FontWeight.bold,
                                color: extraDetails.getBlueColor()),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register(
                                        l_type: 'Email',
                                      )));

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => UserInterest()));
                        }),
                    extraDetails.getDivider(20.0),
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(25, 5, 25, 5),
                      child: new AutoSizeText(
                        "By creating an account, you accept Artzlearn's",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    new GestureDetector(
                      child: new Padding(
                          padding: new EdgeInsets.fromLTRB(25, 5, 25, 25),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new GestureDetector(
                                child: new AutoSizeText(
                                  "Terms of Service",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      // fontWeight: FontWeight.bold,
                                      color: extraDetails.getBlueColor()),
                                ),
                                onTap: () {
                                  launch(
                                      'http://artzlearn.com/T&C.php');
                                },
                              ),
                              new AutoSizeText(
                                " & ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    // fontWeight: FontWeight.bold,
                                    color: extraDetails.getBlueColor()),
                              ),
                              new GestureDetector(
                                child: new AutoSizeText(
                                  "Privacy Policy",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      // fontWeight: FontWeight.bold,
                                      color: extraDetails.getBlueColor()),
                                ),
                                onTap: () {
                                  launch(
                                      'http://artzlearn.com/privacy.php');
                                },
                              ),
                            ],
                          )),
                      onTap: () {
                        // launch('http://artzlearn.com/T&C.php');
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
