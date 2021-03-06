import 'package:artzlearn/OTP.dart';
import 'package:artzlearn/payment_webview.dart';
import 'package:flutter/material.dart';
import 'ExtraDetails.dart';
import 'BottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'NoInternet.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'course_by_cat.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnPage extends StatefulWidget {
  //  final  cid;
  //  LearnPage({this.cid});
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  String video_og_length = '', video_updated_lenght = '', course_id = '';
  List data_my_courses;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isListLoaded = false, enable = true, _noFound = false;

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

  List duration_min_left, duration_sec_left;
  _myCourse(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_By_Particular_User",
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
        extraDetails.setshared("LearnTab", form_response.toString());
        decodeJson(form_response.toString());
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

  List track_min = [], track_sec = []; //current+5000
  decodeJson(js) {
    setState(() {
      print("course data is" + js);
      var jsonval = json.decode(js);
      data_my_courses = jsonval["results"];
      // print(data_my_courses);
      if (data_my_courses[0]['status'] == "failed") {
        setState(() {
          _isListLoaded = true;
          _noFound = true;
        });
      } else if (data_my_courses[0]['status'] == "success") {
        setState(() {
          track_min = new List(data_my_courses.length);
          track_sec = new List(data_my_courses.length);
          duration_min_left = new List(data_my_courses.length);
          duration_sec_left = new List(data_my_courses.length);

          for (int tc = 0; tc < data_my_courses.length; tc++) {
            track_min[tc] =
                (double.parse(data_my_courses[tc]['hours'].toString()) * 60);
            track_sec[tc] = double.parse(data_my_courses[tc]['mins'].toString())
                .toStringAsFixed(2);
            // extraDetails
            //     .getshared("course_track_" +
            //         data_my_courses[tc]['course_id']) //seconds
            //     .then((value) {
            // if (value != '' &&
            //     value != null &&
            //     value != ' ' &&
            //     value != 'null') {
            //     // track[tc] = (track[tc] - double.parse(value.toString())).toStringAsFixed(2);
            //     // .toStringAsFixed(2);
            //     extraDetails.setshared(
            //         "hours_" + data_my_courses[tc]['course_id'],
            //         data_my_courses[tc]['hours'].toString());
            //     extraDetails.setshared(
            //         "mins_" + data_my_courses[tc]['course_id'],
            //         data_my_courses[tc]['mins'].toString());
            //     // print(extraDetails.getshared("hours").then((value){}));
            //     // print(extraDetails.getshared("mins").then((value){}));
            //     var return_hours = extraDetails.getshared('hours');
            //     print("got hours of video " + return_hours.toString());
            //     var return_time = extraDetails.getshared('mins');
            //     print("got mins of video " + return_time.toString());
            //   }
            // });
            // print(track[tc;
            // if (double.parse(track[tc].toString()) > 60.00) {
            //   duration_left[tc] = ((double.parse(track[tc].toString()) / 60)
            //           .toStringAsFixed(2)) +
            //       " Mins left";
            // } else if (double.parse(track[tc].toString()) > 3600.00) {
            //   duration_left[tc] =
            //       ((double.parse(track[tc].toString()) / 60) / 60).toString() +
            //           " Hours left";
            // } else {
            //   duration_left[tc] =
            //       ((double.parse(track[tc].toString()) / 0.6)).toString() +
            //           " Seconds left";
            // }

            // var min=extraDetails.getshared("get");
            // extraDetails.setshared(
            //     "had_min_" + data_my_courses[tc]['course_id'],
            //     track_min[tc].toString()); //240

            // extraDetails.setshared(
            //     "had_sec_" + data_my_courses[tc]['course_id'],
            //     track_sec[tc]); //47
            extraDetails
                .getshared("had_min_" + data_my_courses[tc]['course_id'])
                .then((value) {
                  print("Hey so now my had min on main is $value");
              if (value != '' &&
                  value != null &&
                  value != ' ' &&
                  value != 'null' ) {
                duration_min_left[tc] = value; //3
              } else {
                extraDetails.setshared(
                    "had_min_"+data_my_courses[tc]['course_id'], (double.parse(data_my_courses[tc]['hours'].toString()) * 60).toString());
                duration_min_left[tc] =
                    (double.parse(data_my_courses[tc]['hours'].toString()) * 60)
                        .toStringAsFixed(2);
              }
            });
            extraDetails
                .getshared("had_sec_" + data_my_courses[tc]['course_id'])
                .then((value) {
                  print("Hey so now my had sec on main is $value");
              if (value != '' &&
                  value != null &&
                  value != ' ' &&
                  value != 'null' &&
                  value != '0') {
                duration_sec_left[tc] = value;
              } else {
                extraDetails.setshared(
                    "had_sec_", data_my_courses[tc]['mins'].toString());
                duration_sec_left[tc] = data_my_courses[tc]['mins'].toString();
              }
            });
            // duration_left[tc] = new Duration(seconds: int.parse(track[tc].toStringAsFixed())).inSeconds;
          }

          _isListLoaded = true;

          // print(data_my_courses[tc]['hours']);
          // print(data_my_courses[tc]['mins']);
        });
      }

      // end
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    extraDetails.getshared("UserAuth").then((value) {
      if (value != '' && value != null && value != ' ' && value != 'null') {
        extraDetails.getshared("LearnTab").then((valueJS) {
          if (valueJS != '' &&
              valueJS != null &&
              valueJS != ' ' &&
              valueJS != 'null') {
            decodeJson(valueJS);
          }
        });
        _myCourse(value);
      }
    });
  }

  TextEditingController search = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Padding(
          padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: new SizedBox(
            // height: MediaQuery.of(context).size.height * 0.09,
            child: new TextFormField(
              keyboardType: TextInputType.text,
              controller: search,
              onEditingComplete: () {
                if (search.text.toString() != '') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchList(keyword: search.text.toString())));
                }
              },
              decoration: new InputDecoration(
                suffixIcon: new GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onTap: () {
                      if (search.text.toString() != '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchList(
                                    keyword: search.text.toString())));
                      }
                    }),
                // border: OutlineInputBorder(),
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
                labelStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
                // labelText: 'Search Catalog',
                hintText: 'Enter keywords',
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xffffff), width: 2.0),
                  // borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: new SafeArea(
          child: new Stack(
        children: [
          new Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.shade600,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.2,
                    0.5,
                    0.2,
                  ],
                  colors: [
                    extraDetails.getBlueColor(),
                    extraDetails.getBlueColor(),
                    Colors.white,
                  ]),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
              ),
            ),
          ),
          _isListLoaded
              ? _noFound
                  ? new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Padding(
                            padding: new EdgeInsets.all(15.0),
                            child: new Text(
                              "Explore fresh courses today",
                              style: new TextStyle(
                                  fontSize: 22, color: Colors.white),
                            )),
                      ],
                    )
                  : new ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: data_my_courses.length < 0
                          ? 0
                          : data_my_courses.length,
                      itemBuilder: (BuildContext context, int i) {
                        return new Padding(
                            padding: new EdgeInsets.all(15.0),
                            child: new GestureDetector(
                              child: new Card(
                                child: new Container(
                                  padding:
                                      new EdgeInsets.fromLTRB(20, 15, 15, 0),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Row(
                                        children: [
                                          Text(
                                            data_my_courses[i]['course_name']
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.fromLTRB(
                                            0, 15, 15, 0),
                                        child: new Row(
                                          children: [
                                            Text(
                                              "By " +
                                                  data_my_courses[i]
                                                          ['instructor']
                                                      .toString(),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Html(
                                        data: data_my_courses[i]['description']
                                                    .length <
                                                120
                                            ? data_my_courses[i]['description']
                                                .toString()
                                            : data_my_courses[i]['description']
                                                .toString()
                                                .substring(0, 120),
                                        style: {
                                          "html":
                                              Style(fontSize: FontSize.medium),
                                          "table": Style(
                                            backgroundColor: Color.fromARGB(
                                                0x50, 0xee, 0xee, 0xee),
                                          ),
                                          "h2":
                                              Style(fontSize: FontSize.medium),
                                          "li":
                                              Style(fontSize: FontSize.medium),
                                          "h3":
                                              Style(fontSize: FontSize.medium),
                                          "br":
                                              Style(fontSize: FontSize.xxSmall),
                                          "tr": Style(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey)),
                                          ),
                                          "th": Style(
                                            padding: EdgeInsets.all(6),
                                            backgroundColor: Colors.grey,
                                          ),
                                          "td": Style(
                                            padding: EdgeInsets.all(6),
                                          ),
                                          "var": Style(fontFamily: 'serif'),
                                        },
                                        onLinkTap: (url) {
                                          print("Opening $url...");
                                        },
                                        onImageTap: (src) {
                                          print(src);
                                        },
                                        onImageError: (exception, stackTrace) {
                                          print(exception);
                                        },
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.fromLTRB(
                                            0, 15, 15, 5),
                                        child: new Row(children: [
                                          Row(
                                            children: [
                                              new Text(
                                                // 'Course Duration is ${(double.parse(track[i].toString()).toStringAsFixed(2))}',
                                                // var hbh=extraDetails.getshared("hours");
                                                // print();
                                                // "heyy  time" + hours,
                                                "Total Length " +
                                                    data_my_courses[i]['hours']
                                                        .toString() +
                                                    ":" +
                                                    data_my_courses[i]['mins']
                                                        .toString() +
                                                    " Mins",
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                      new Row(
                                        children: [
                                          Text("Check your progress below",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ))
                                        ],
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.fromLTRB(
                                            0, 5, 15, 15),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.black12,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            extraDetails.getBlueColor(),
                                          ),
                                          value: 0.3,
                                        ),
                                      ),
                                      new Container(
                                        decoration: new BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              //                    <--- top side
                                              color: Colors.black12,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: new Padding(
                                          padding: new EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              new AutoSizeText(
                                                // double.parse(track[i]
                                                //             .toString()) <
                                                //         1
                                                //     ? "${(double.parse(track[i].toString()) * 60).toStringAsFixed(2).replaceAll(".", ":")} Mins Left"
                                                //     : "${(double.parse(track[i].toString()).toStringAsFixed(2).replaceAll(".", ":"))} Hours Left",
                                                // String newValue = Integer.toString((int)percentageValue);
                                                // String.format("%.0f", percentageValue),

                                                (double.parse(duration_min_left[
                                                                    i]
                                                                .toString()) /
                                                            60)
                                                        .toInt()
                                                        .toString() +
                                                    " : " +
                                                    (double.parse(
                                                            duration_sec_left[i]
                                                                .toString()))
                                                        .toInt()
                                                        .toString() +
                                                    " Mins Left",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                              ),
                                              new GestureDetector(
                                                child: new Icon(
                                                  Icons
                                                      .play_circle_fill_rounded,
                                                  color: extraDetails
                                                      .getBlueColor(),
                                                  size: 35,
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  SingleCourse(
                                                                    cid: data_my_courses[i]
                                                                            [
                                                                            'course_id']
                                                                        .toString(),
                                                                  )));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleCourse(
                                              cid: data_my_courses[i]
                                                      ['course_id']
                                                  .toString(),
                                            )));
                              },
                            ));
                      })
              : new Center(child: new CircularProgressIndicator()),
        ],
      )),
      bottomNavigationBar: new BottomNav(
        currentPage: 1,
      ),
    );
  }
}

class SingleCourse extends StatefulWidget {
  final cid;
  SingleCourse({this.cid});
  @override
  _SingleCourseState createState() => _SingleCourseState();
}

class _SingleCourseState extends State<SingleCourse> {
  ExtraDetails extraDetails = new ExtraDetails();
  YoutubePlayerController _controller;
  TextEditingController review = new TextEditingController();
  TextEditingController question = new TextEditingController();

  TextEditingController search = new TextEditingController();
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  Response form_response;
  List data_course, course_Reviews, _qAndA;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isCourseLoaded = false,
      enable = true,
      _isReviweLoaded = false,
      _no_review = false,
      my_review = false;
  var _rating = 0.0;
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

  _courseDetails(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_App",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id
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
          var jsonval = json.decode(form_response.toString());

          data_course = jsonval["results"];
          print("Yaay data course $data_course");
          if (data_course[0]['status'] == "failed") {
            setState(() {
              _isCourseLoaded = false;
            });
          } else if (data_course[0]['status'] == "success") {
            setState(() {
              _isCourseLoaded = true;
              print('preview_link ${(widget.cid)}');
              print(data_course[0]['course_question']);
              if (data_course[0]['preview_link'].toString() != 'null') {
                _controller = YoutubePlayerController(
                  initialVideoId:
                      data_course[0]['preview_link'] ?? '37GmCb3SCrg',
                );
              }
            });
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

  _viewCourseDetails(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_Views",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id.toString() ?? ''
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        print("Response is see");
        print(form_response.toString());
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

  _getReview(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "GetReview",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id.toString() ?? ''
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        var jsonval = json.decode(form_response.toString());
        course_Reviews = jsonval["results"];
        print("Yaay data course $course_Reviews");
        if (course_Reviews[0]['status'] == "failed") {
          setState(() {
            _no_review = true;
            _isReviweLoaded = false;
          });
        } else if (course_Reviews[0]['status'] == "success") {
          setState(() {
            _isReviweLoaded = true;
            for (int cr = 0; cr < course_Reviews.length; cr++) {
              if (course_Reviews[cr]['my_view'] == 'Y') {
                my_review = true;
              }
            }
          });
        }
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

  _giveReview(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "AddReview",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id.toString() ?? '',
          "rating": _rating.toString() ?? '',
          "review": review.text.toString() ?? ''
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        var jsonval = json.decode(form_response.toString());
        // course_Reviews = jsonval["results"];
        print(jsonval);
        if (jsonval["results"][0]['status'] == "failed") {
        } else if (jsonval["results"][0]['status'] == "success") {
          setState(() {
            my_review = true;
            _isReviweLoaded = true;
            course_Reviews.add(review.text.toString());
          });
          showInSnackBar("Review Sent");
          Future.delayed(new Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleCourse(cid: widget.cid)));
          });
        }
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

  _askQues(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "AddQuestion",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id.toString() ?? '',
          "question": question.text.toString() ?? '',
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        print(form_response.toString());
        var jsonval = json.decode(form_response.toString());
        print("Yaay question ${(jsonval["results"])}");
        if (jsonval["results"][0]['status'] == "failed") {
        } else if (jsonval["results"][0]['status'] == "success") {
          showInSnackBar("Question Added");
          Future.delayed(new Duration(seconds: 2), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleCourse(cid: widget.cid)));
          });
        }
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

  _getQnA(user_id) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "GetReview",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id ?? '',
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        var jsonval = json.decode(form_response.toString());
        _qAndA = jsonval["results"];
        print("Yaay data course QnA $_qAndA");
        if (_qAndA[0]['status'] == "failed") {
          setState(() {
            _isReviweLoaded = false;
          });
        } else if (_qAndA[0]['status'] == "success") {
          setState(() {
            _isReviweLoaded = true;
            for (int cr = 0; cr < _qAndA.length; cr++) {
              if (_qAndA[cr]['my_view'] == 'Y') {
                my_review = true;
              }
            }
          });
        }
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

  showForm() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text("Ask Question"),
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
                  key: _formKey,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(bottom: 8.0),
                        child: new SizedBox(
                          child: new TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Something';
                              }
                            },
                            controller: question,
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
                              labelText: 'Question',
                              alignLabelWithHint: true,
                              hintText: 'Enter Question',
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
                          child: Text("ASK",
                              style: new TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              extraDetails.getshared("UserAuth").then((value) {
                                if (value != '' &&
                                    value != null &&
                                    value != ' ' &&
                                    value != 'null') {
                                  Navigator.pop(context);

                                  _askQues(value);
                                }
                              });
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

  List Az = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];
  Widget tab() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TabBar(
          indicatorColor: extraDetails.getBlueColor(),
          tabs: [
            Tab(
              child: new AutoSizeText(
                "Course",
                style: new TextStyle(
                    color: Colors.black.withOpacity(0.7), fontSize: 10),
              ),
            ),
            Tab(
              child: new AutoSizeText(
                "Updates",
                style: new TextStyle(
                    color: Colors.black.withOpacity(0.7), fontSize: 10),
              ),
            ),
            Tab(
              child: new AutoSizeText(
                "QnA",
                style: new TextStyle(
                    color: Colors.black.withOpacity(0.7), fontSize: 10),
              ),
            ),
            Tab(
              child: new AutoSizeText(
                "Overview",
                style: new TextStyle(
                    color: Colors.black.withOpacity(0.7), fontSize: 10),
              ),
            ),
          ],
        ),
        body: TabBarView(children: [
          new Column(
            children: [
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: new Row(
                  children: [
                    new Icon(
                      Icons.settings_ethernet_sharp,
                      color: extraDetails.getBlueColor(),
                    ),
                    new Expanded(
                      child: new AutoSizeText(
                        "Course",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                  // height: MediaQuery.of(context).size.height * 0.5,
                  child: new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: data_course[0]['course_section'].length < 0
                          ? 0
                          : data_course[0]['course_section'].length,
                      itemBuilder: (BuildContext context, int i) {
                        return new Padding(
                          padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: new AutoSizeText(
                              (i + 1).toString() +
                                      ") " +
                                      data_course[0]['course_section'][i]
                                          ['sec_name'] ??
                                  "",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                            children: [
                              new ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: data_course[0]['course_section'][i]
                                                  ['res']
                                              .length <
                                          0
                                      ? 0
                                      : data_course[0]['course_section'][i]
                                              ['res']
                                          .length,
                                  itemBuilder: (BuildContext context, int j) {
                                    return new Padding(
                                      padding: new EdgeInsets.fromLTRB(
                                          15, 15, 15, 5),
                                      child: new GestureDetector(
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            new Expanded(
                                              child: new AutoSizeText(
                                                (Az[j]).toString() +
                                                        ") " +
                                                        data_course[0][
                                                                    'course_section']
                                                                [i]['res'][j]
                                                            ['res_title'] ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black
                                                        .withOpacity(0.8)),
                                              ),
                                            ),
                                            data_course[0]['course_section'][i]
                                                        ['res'][j]['type'] ==
                                                    'file'
                                                ? new Icon(Icons.file_present,
                                                    color: extraDetails
                                                        .getBlueColor())
                                                : new Icon(Icons.play_arrow,
                                                    color: extraDetails
                                                        .getBlueColor()),
                                          ],
                                        ),
                                        onTap: () {
                                          data_course[0]['course_section'][i]
                                                      ['res'][j]['type'] ==
                                                  'file'
                                              ? launch(data_course[0]
                                                          ['course_section'][i]
                                                      ['res'][j]['res_url']
                                                  .toString())
                                              // ? Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => ViewFiles(
                                              // url: data_course[0]['course_section']
                                              //             [i]['res']
                                              //         [j]['res_url']
                                              //     .toString())))
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              FullVideo(
                                                                video: data_course[0]['course_section'][i]
                                                                            [
                                                                            'res'][j]
                                                                        [
                                                                        'res_url']
                                                                    .toString(),
                                                                cid: widget.cid
                                                                    .toString(),
                                                                vid: data_course[0]['course_section'][i]
                                                                            [
                                                                            'res'][j]
                                                                        [
                                                                        'res_url']
                                                                    .toString(),
                                                              )));
                                        },
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        );
                      })),
            ],
          ),
          new ListView(
            children: [
              new Padding(
                padding: new EdgeInsets.fromLTRB(25, 25, 25, 15),
                child: new Row(
                  children: [
                    new Expanded(
                      child: new AutoSizeText(
                        data_course[0]['announcements'] ?? "",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          new ListView(
            children: [
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: new Column(
                  children: [
                    _isCourseLoaded
                        ? data_course[0]['course_question'].length <= 0
                            ? new ListTile(
                                title: new Text("No Questions Asked!"),
                                subtitle: new Text(
                                    "Click on icon below to ask your questions!"),
                              )
                            : new Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: new ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: data_course[0]['course_question']
                                                .length <
                                            0
                                        ? 0
                                        : data_course[0]['course_question']
                                            .length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return new ExpansionTile(
                                        title: new AutoSizeText(
                                          data_course[0]['course_question'][i]
                                                      ['question']
                                                  .toString() ??
                                              " ",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                        subtitle: Text.rich(
                                          TextSpan(
                                            text: data_course[0]
                                                        ['course_question'][i]
                                                    ['name']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: data_course[0][
                                                                  'course_question']
                                                              [i]['question_on']
                                                          .toString() ??
                                                      " ",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black87)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                        children: [
                                          new Padding(
                                            padding: new EdgeInsets.fromLTRB(
                                                15, 5, 15, 5),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                new AutoSizeText(
                                                  data_course[0]['course_question']
                                                              [i]['answer']
                                                          .toString() ??
                                                      " ",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black
                                                          .withOpacity(0.8)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Padding(
                                            padding: new EdgeInsets.fromLTRB(
                                                15, 5, 15, 5),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                new AutoSizeText(
                                                  data_course[0]['course_question']
                                                              [i]['answer_on']
                                                          .toString() ??
                                                      " ",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black
                                                          .withOpacity(0.8)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              )
                        : new Center(child: new CircularProgressIndicator())
                  ],
                ),
              ),
            ],
          ),
          new ListView(
            children: [
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Image.network(
                      data_course[0]['course_img'],
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: new Row(
                  children: [
                    new Icon(
                      Icons.info_outline,
                      color: extraDetails.getBlueColor(),
                    ),
                    new Expanded(
                      child: new AutoSizeText(
                        " About Course",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 5, 15, 15),
                child: new Row(
                  children: [
                    new Expanded(
                        child: new Html(
                      data: data_course[0]["description"].length > 60
                          ? data_course[0]["description"].toString()
                          : data_course[0]["description"].toString(),
                      style: {
                        "html": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "table": Style(
                          backgroundColor:
                              Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                        ),
                        "h2": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "li": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "h3": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "br": Style(fontSize: FontSize.xxSmall),
                        "tr": Style(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        "th": Style(
                          padding: EdgeInsets.all(6),
                          backgroundColor: Colors.grey,
                        ),
                        "td": Style(
                          padding: EdgeInsets.all(6),
                        ),
                        "var": Style(fontFamily: 'serif'),
                      },
                      onLinkTap: (url) {
                        print("Opening $url...");
                      },
                      onImageTap: (src) {
                        print(src);
                      },
                      onImageError: (exception, stackTrace) {
                        print(exception);
                      },
                    )),
                  ],
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: new Row(
                  children: [
                    new Icon(
                      Icons.list_alt_rounded,
                      color: extraDetails.getBlueColor(),
                    ),
                    new Expanded(
                      child: new AutoSizeText(
                        " Requirments",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                child: new Row(
                  children: [
                    new Expanded(
                        child: new Html(
                      data: data_course[0]["requirement"].length > 60
                          ? data_course[0]["requirement"].toString()
                          : data_course[0]["requirement"],
                      style: {
                        "html": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "h2": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "li": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "h3": Style(
                            fontSize: FontSize.small,
                            textAlign: TextAlign.justify),
                        "br": Style(fontSize: FontSize.xxSmall),
                        "tr": Style(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        "th": Style(
                          padding: EdgeInsets.all(6),
                          backgroundColor: Colors.grey,
                        ),
                        "td": Style(
                          padding: EdgeInsets.all(6),
                        ),
                        "var": Style(fontFamily: 'serif'),
                      },
                      onLinkTap: (url) {
                        print("Opening $url...");
                      },
                      onImageTap: (src) {
                        print(src);
                      },
                      onImageError: (exception, stackTrace) {
                        print(exception);
                      },
                    )),
                  ],
                ),
              ),
              !my_review
                  ? new Padding(
                      padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SmoothStarRating(
                            rating: _rating,
                            isReadOnly: false,
                            size: 30,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: false,
                            spacing: 2.0,
                            onRated: (value) {
                              setState(() {
                                _rating = value;
                              });
                              // print("rating value dd -> ${value.truncate()}");
                            },
                          )
                        ],
                      ),
                    )
                  : new SizedBox(),
              !my_review
                  ? new Padding(
                      padding: new EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.height * 0.02,
                          bottom: 8.0),
                      child: new SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: new TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter Review';
                            }
                          },
                          controller: review,
                          enabled: enable,
                          maxLength: 120,
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
                            labelText: 'Review',
                            alignLabelWithHint: true,
                            hintText: 'Enter Review',
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
                    )
                  : new SizedBox(),
              !my_review
                  ? new Padding(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new GestureDetector(
                            child: new Container(
                              padding: new EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right:
                                      MediaQuery.of(context).size.height * 0.02,
                                  top: 5.0,
                                  bottom: 5.0),
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
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: new Text(
                                "SUBMIT",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {
                              extraDetails.getshared("UserAuth").then((value) {
                                if (value != '' &&
                                    value != null &&
                                    value != ' ' &&
                                    value != 'null') {
                                  if (_rating == 0.0 ||
                                      review.text.toString() == "") {
                                    showInSnackBar(
                                        "Please select rating to continue");
                                  } else {
                                    _giveReview(value);
                                  }
                                }
                              });
                            },
                          )
                        ],
                      ),
                      padding: new EdgeInsets.all(5.0),
                    )
                  : new SizedBox()
            ],
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    extraDetails.getshared("UserAuth").then((value) {
      if (value != '' && value != null && value != ' ' && value != 'null') {
        _viewCourseDetails(value);
        _courseDetails(value);
        _getReview(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: new Stack(
        children: [
          _isCourseLoaded
              ? new ListView(
                  children: [
                    new Container(
                      color: extraDet.getBlueColorOpc(0.8),
                      child: new Column(
                        children: [
                          new Padding(
                            padding: new EdgeInsets.fromLTRB(15, 20, 15, 15),
                            child: new Row(
                              children: [
                                new Expanded(
                                    child: new Text.rich(
                                  TextSpan(
                                    text: data_course[0]['instr_name']
                                            .toString() +
                                        '\n',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: data_course[0]['course_name'],
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationStyle:
                                                  TextDecorationStyle.double,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      // can add more TextSpans here...
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                        padding: new EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.01,
                            right: MediaQuery.of(context).size.height * 0.01,
                            bottom: 8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: tab(),
                            )
                          ],
                        )),
                  ],
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                ),
        ],
      )),
      bottomNavigationBar: new BottomNav(
        currentPage: 1,
      ),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        backgroundColor: Colors.white,
        onPressed: () {
          showForm();
        },
        child: Icon(
          Icons.question_answer,
          color: extraDetails.getBlueColor(),
          size: 26,
        ),
      ),
    );
  }
}

class FullVideo extends StatefulWidget {
  final video, cid, vid;
  FullVideo({this.video, this.cid, this.vid});
  @override
  _FullVideoState createState() => _FullVideoState();
}

class _FullVideoState extends State<FullVideo> {
  YoutubePlayerController _controller;
  PlayerState _playerState;
  ExtraDetails extraDetails = new ExtraDetails();
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String stop_time_video = '', two_second_delay = '';
  var had_min = 0.0, had_sec = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    print("So now we have video");
    print(widget.video);
    _videoMetaData = const YoutubeMetaData();
    print(_videoMetaData);
    _playerState = PlayerState.buffering;
    _controller = YoutubePlayerController(
      initialVideoId: widget.video,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        disableDragSeek: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    // strart timer
    // callStart();

    extraDetails.getshared("had_min_" + widget.cid).then((value) {
      if (value != '' &&
          value != null &&
          value != ' ' &&
          value != 'null' &&
          value != 0.0 &&
          value != '0.0') {
        had_min = double.parse(value.toString());
      } else {
        had_min = 0.0;
      }
    });
    extraDetails.getshared("had_sec_" + widget.cid).then((value) {
      if (value != '' &&
          value != null &&
          value != ' ' &&
          value != 'null' &&
          value != 0.0 &&
          value != '0.0') {
        had_sec = double.parse(value.toString());
      } else {
        had_sec = 0.0;
      }
    });
    start_loop();
  }

  start_loop() async {
    if (_controller.value.isPlaying) {
      Future.delayed(new Duration(seconds: 1), () {
        next_loop();
      });
    } else {
      Future.delayed(new Duration(seconds: 1), () {
        start_loop();
      });
    }
  }

  next_loop() async {
    print("now my sec is $had_sec and my mins are $had_min");
    if (had_sec > 0) {
      had_sec = had_sec - 1.0;
      start_loop();
      return true;
    } else {
      if (had_min > 0) {
        had_min = had_min - 1.0;
        start_loop();
        return true;
      } else {
        updateSetShared();
        return true;
      }
    }
  }

  updateSetShared() async {
    
    print("Uploading sec $had_sec and  mins  $had_min");
    extraDetails.setshared("had_min_" + widget.cid, had_min.toString());
    extraDetails.setshared("had_sec_" + widget.cid, had_sec.toString());
// update in set shared
  }

  // callStart() async {
  //   if (_controller.value.isPlaying) {
  //     start_timer();
  //   } else {
  //     Future.delayed(new Duration(seconds: 1), () {
  //       callStart();
  //     });
  //   }
  // }

  // void start_timer() async {
  //   print("\nOn timer, start_timer\n");
  //   // getShareSec
  //   // if sec>=0 reduce from sec, update setShared -3
  //   // else getShaed min

  //   // reduce from mins, update setSHaredMins
  //   extraDetails.getshared("had_min_" + widget.cid).then((value) {
  //     print("My had mins in start is $value");
  //     if (value != '' &&
  //         value != null &&
  //         value != ' ' &&
  //         value != 'null' &&
  //         value != 0.0 &&
  //         value != '0.0') {
  //       call_delay_timer();
  //     } else {
  //       print("Not going");
  //     }
  //   });
  // }

  // double current_value_sec = 0.0,
  //     current_value_min = 0.0,
  //     set_delay_value_sec = 0.0,
  //     set_delay_value_min = 0.0;
  // void call_delay_timer() async {
  //   print("\nOn Delay, call_delay\n");
  //   print("Hey is it playing?" + _controller.value.isPlaying.toString());
  //   if (_controller.value.isPlaying) {
  //     // if (1 == 1) {
  //     print("\nNow Is playing Delay, call_delay\n");
  //     Future.delayed(const Duration(seconds: 2), () {
  //       extraDetails.getshared("had_sec_" + widget.cid).then((value) {
  //         if (value != '' &&
  //             value != null &&
  //             value != ' ' &&
  //             value != 'null' &&
  //             value != 0.0 &&
  //             value != '0.0') {
  //           current_value_sec = double.parse(value.toString());
  //           set_delay_value_sec = current_value_sec - 1.0;
  //           print("\n\n\ndelay sec $set_delay_value_sec");
  //           extraDetails.setshared(
  //               "had_sec_" + widget.cid, set_delay_value_sec.toString());
  //           start_timer();
  //         } else {
  //           extraDetails.getshared("had_min_" + widget.cid).then((value) {
  //             if (value != '' &&
  //                 value != null &&
  //                 value != ' ' &&
  //                 value != 'null' &&
  //                 value != 0.0 &&
  //                 value != '0.0') {
  //               current_value_min = double.parse(value.toString());
  //               set_delay_value_min = current_value_min - 1.0;
  //               print("\n\n\n\ndelay min $set_delay_value_min");
  //               extraDetails.setshared(
  //                   "had_min_" + widget.cid, set_delay_value_min.toString());
  //               start_timer();
  //             }
  //           });
  //         }
  //         String min =
  //             extraDetails.getshared("had_min_" + widget.cid).toString();
  //         String sec =
  //             extraDetails.getshared("had_sec_" + widget.cid).toString();
  //         // extraDetails.setshared("had_min_" + widget.cid, value);
  //       });

  //       //     });
  //       // });
  //       // stop_time_video = b + 1;
  //       // extraDetails.setshared("Current_video_length", stop_time_video);
  //     });
  //   }
  //   start_timer();
  //   // var get_current_stop_time = extraDetails.getshared("Current_video_length");
  //   // print(get_current_stop_time.toString().trim());
  // }

  var this_dura = 0;
  void listener() {
    if (_isPlayerReady && mounted && this_dura == 0) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
        print("Duartion is");
        print(_videoMetaData.duration);
        print(_videoMetaData.duration.inSeconds);
        this_dura = _videoMetaData.duration.inSeconds;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    // _controller.dispose();
    updateSetShared();
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // _controller.dispose();
    updateSetShared();
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        child: WillPopScope(
      onWillPop: () {
        updateSetShared();
        _controller.pause();
        // _controller.dispose();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleCourse(
                      cid: widget.cid.toString(),
                    )));
      },
      child: new Padding(
        padding: new EdgeInsets.all(0),
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    ));
  }
}

class ViewFiles extends StatefulWidget {
  final url;
  ViewFiles({this.url});
  @override
  _ViewFilesState createState() => _ViewFilesState();
}

class _ViewFilesState extends State<ViewFiles> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.url");
    print(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        child: InAppWebView(
          initialUrl: widget.url.toString() ?? '',
          initialHeaders: {},
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            setState(() {
              this.url = url;
            });
          },
          onLoadStop: (InAppWebViewController controller, String url) async {
            setState(() {
              this.url = url;
            });
          },
          onProgressChanged: (InAppWebViewController controller, int progress) {
            setState(() {
              this.progress = progress / 100;
            });
          },
        ),
      ),
    );
  }
}
