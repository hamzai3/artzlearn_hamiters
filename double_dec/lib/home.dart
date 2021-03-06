import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'ExtraDetails.dart';
import 'NoInternet.dart';
import 'package:artzlearn/main.dart';
import 'BottomNav.dart';
import 'course_by_cat.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_html/style.dart';
import 'learn.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'payment_webview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_category,
      data_recentCourse,
      data_popularCourse,
      data_mostPopular,
      data_slider;
  int _current = 0;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isCatLoaded = false,
      _isRecetCourseLoaded = false,
      _isPopularCourseLoaded = false,
      _isMostPopularCourseLoaded = false,
      _isSliderLoaded = false,
      enable = true;

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

  _category() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "category",
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        decodeCat(form_response.toString());
        extraDetails.setshared("category", form_response.toString());
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

  _slider() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "GetSlider",
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        extraDetails.setshared("slider", form_response.toString());
        decodeSlider(form_response.toString());
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

  _recentCourse() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_By_Recent",
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        print("So yea now Recent is");
        print(form_response.toString());
        decodeRecentCourse(form_response.toString());
        extraDetails.setshared("recentCourse", form_response.toString());
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

  _popularCourse() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_By_Popularity",
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        decodePopularCourse(form_response.toString());
        extraDetails.setshared("popularCourse", form_response.toString());
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

  _mostPopularCourse() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_By_Popularity",
        });
        try {
          form_response = await dio.post(
            extraDetails.getURL(),
            data: formData,
          );
        } on DioError catch (e) {
          print(e.message);
        }
        decodeMostPopularCourse(form_response.toString());
        extraDetails.setshared("mostPopularCourse", form_response.toString());
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

  decodeCat(js) {
    setState(() {
      var jsonval = json.decode(js);
      data_category = jsonval["results"];
      if (data_category[0]['status'] == "failed") {
        setState(() {
          _isCatLoaded = false;
        });
      } else if (data_category[0]['status'] == "success") {
        setState(() {
          _isCatLoaded = true;
        });
      }
    });
  }

  decodeSlider(js) {
    setState(() {
      var jsonval = json.decode(js);
      data_slider = jsonval["results"];
      if (data_slider[0]['status'] == "failed") {
        setState(() {
          _isSliderLoaded = false;
        });
      } else if (data_slider[0]['status'] == "success") {
        setState(() {
          _isSliderLoaded = true;
        });
      }
    });
  }

  decodeRecentCourse(js) {
    setState(() {
      var jsonval = json.decode(js.toString());
      data_recentCourse = jsonval["results"];
      print(data_recentCourse);
      if (data_recentCourse[0]['status'] == "failed") {
        setState(() {
          _isRecetCourseLoaded = false;
        });
      } else if (data_recentCourse[0]['status'] == "success") {
        setState(() {
          _isRecetCourseLoaded = true;
        });
      }
    });
  }

  decodePopularCourse(js) {
    setState(() {
      var jsonval = json.decode(js.toString());
      data_popularCourse = jsonval["results"];
      if (data_popularCourse[0]['status'] == "failed") {
        setState(() {
          _isPopularCourseLoaded = false;
        });
      } else if (data_popularCourse[0]['status'] == "success") {
        setState(() {
          _isPopularCourseLoaded = true;
        });
      }
    });
  }

  decodeMostPopularCourse(js) {
    setState(() {
      var jsonval = json.decode(js.toString());
      data_mostPopular = jsonval["results"];
      if (data_mostPopular[0]['status'] == "failed") {
        setState(() {
          _isMostPopularCourseLoaded = false;
        });
      } else if (data_mostPopular[0]['status'] == "success") {
        setState(() {
          _isMostPopularCourseLoaded = true;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      print("resumed");
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
      print("inactive");
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      print("paused");
    }
    // else if(state == AppLifecycleState.suspending){
    //   // app suspended (not used in iOS)
    //   print("")
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    extraDetails.getshared("category").then((value) {
      // print("CatVal $value");
      if (value != '' && value != null && value != ' ' && value != 'null') {
        decodeCat(value);
      }
      _category();
    });
    extraDetails.getshared("slider").then((value) {
      // print("CatVal $value");
      if (value != '' && value != null && value != ' ' && value != 'null') {
        decodeSlider(value);
      }
      _slider();
    });
    extraDetails.getshared("recentCourse").then((value) {
      // print("recentCourseVal $value");
      if (value != '' && value != null && value != ' ' && value != 'null') {
        decodeRecentCourse(value);
      }
      _recentCourse();
    });
    extraDetails.getshared("popularCourse").then((value) {
      // print("popularCourseVal $value");
      if (value != '' && value != null && value != ' ' && value != 'null') {
        decodePopularCourse(value);
      }
      _popularCourse();
    });
    extraDetails.getshared("mostPopularCourse").then((value) {
      // print("mostPopularCourseVal $value");
      if (value != '' && value != null && value != ' ' && value != 'null') {
        decodeMostPopularCourse(value);
      }
      _mostPopularCourse();
    });
  }

  TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Padding(
          padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: new SizedBox(
            // height: MediaQuery.of(context).size.height * 0.1,
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
        child: new ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new GestureDetector(
                  child: new Padding(
                    padding: new EdgeInsets.fromLTRB(15, 10, 25, 5),
                    child: new AutoSizeText(
                      "Explore",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseCat(
                          cat_id: 0,
                          c_type: 'rec',
                        ),
                      ),
                    );
                  },
                ),
                new GestureDetector(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        new Padding(
                          padding: new EdgeInsets.fromLTRB(15, 10, 5, 5),
                          child: new AutoSizeText(
                            "Topics",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        new Padding(
                            padding: new EdgeInsets.fromLTRB(0, 20, 25, 5),
                            child: new Icon(Icons.arrow_drop_down))
                      ],
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CatList()))),
              ],
            ),
            _isCatLoaded
                ? new Container(
                    child: new SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: new ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data_category.length < 0
                              ? 0
                              : data_category.length,
                          itemBuilder: (BuildContext context, int i) {
                            return new Container(
                              // height: 80,
                              // width: MediaQuery.of(context).size.height * 0.15,
                              child: new GestureDetector(
                                child: new Padding(
                                  padding:
                                      new EdgeInsets.only(left: 5, right: 1),
                                  child: new Container(
                                      padding: new EdgeInsets.only(
                                          left: 8, right: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            extraDetails.getBlueColorOpc(0.8),
                                        border: new Border.all(
                                          color:
                                              extraDetails.getBlueColorOpc(0.8),
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: new Center(
                                          child: new Padding(
                                        padding: new EdgeInsets.only(left: 1),
                                        child: new AutoSizeText(
                                          data_category[i]['cat_name'],
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  extraDetails.getWhiteColor()),
                                        ),
                                      ))),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CourseCat(
                                                cat_id: data_category[i]
                                                    ['cat_id'],
                                                c_type: 'cat',
                                              )));
                                },
                              ),
                            );
                          }),
                    ),
                  )
                : new Container(),
            extraDetails.getDivider(15.0),
            _isSliderLoaded
                ? new CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.3,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 400),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [0, 1, 2, 3, 4].map((i) {
                      return new Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              child: new Image.network(
                                data_slider[i]['img'],
                                width: MediaQuery.of(context).size.width * 0.2,
                                fit: BoxFit.fill,
                              ));
                        },
                      );
                    }).toList(),
                  )
                : new Container(),
            _isSliderLoaded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [0, 1, 2, 3, 4].map((url) {
                      int index = [0, 1, 2, 3, 4].indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  )
                : new Container(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15, 5, 25, 5),
                  child: new AutoSizeText(
                    "Recent Courses",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                new GestureDetector(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new Padding(
                        padding: new EdgeInsets.fromLTRB(25, 5, 5, 5),
                        child: new AutoSizeText(
                          "See All",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                      new Padding(
                          padding: new EdgeInsets.fromLTRB(0, 5, 25, 5),
                          child: new Icon(Icons.arrow_drop_down))
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseCat(
                        cat_id: 0,
                        c_type: 'rec',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _isRecetCourseLoaded
                ? new SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data_recentCourse.length < 0
                            ? 0
                            : data_recentCourse.length,
                        itemBuilder: (BuildContext context, int i) {
                          return new SizedBox(
                            // height: 80,
                            width: MediaQuery.of(context).size.height * 0.22,
                            child: new GestureDetector(
                                child: new Padding(
                                  padding: new EdgeInsets.all(10),
                                  child: new Container(
                                      child: new Column(
                                    children: [
                                      new Card(
                                        elevation: 3.0,
                                        child: new Image.network(
                                          data_recentCourse[i]["course_img"]
                                                  .toString() ??
                                              "",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      new Container(
                                        padding: new EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: new Row(
                                          children: [
                                            new Expanded(
                                              child: new AutoSizeText(
                                                data_recentCourse[i]
                                                            ["course_name"]
                                                        .toString() ??
                                                    "",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                        padding: new EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: new Row(
                                          children: [
                                            new Expanded(
                                              child: new AutoSizeText(
                                                data_recentCourse[i]["price"] ==
                                                        '0'
                                                    ? 'FREE'
                                                    : data_recentCourse[i]
                                                                ["price"]
                                                            .toString() +
                                                        " Rs",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                        padding: new EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: new Row(
                                          children: [
                                            SmoothStarRating(
                                              
                                              rating: data_recentCourse[i]
                                                          ['rating'] ==
                                                      '0'
                                                  ? 0.0
                                                  : double.parse(
                                                              data_recentCourse[
                                                                          i]
                                                                      ['rating']
                                                                  .toString().trim(),
                                                                  )
                                                          .toDouble() +
                                                      0.0,
                                              
                                              isReadOnly: true,
                                              size: 11,
                                              filledIconData: Icons.star,
                                              halfFilledIconData:
                                                  Icons.star_half,
                                              defaultIconData:
                                                  Icons.star_border,
                                              starCount: 5,
                                              allowHalfRating: true,
                                              spacing: 2.0,
                                            ),
                                            new Text(
                                              "( " +
                                                  data_recentCourse[i]['people']
                                                      .toString() +
                                                  " )",
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CourseDetails(
                                              cid: data_recentCourse[i]
                                                          ["course_id"]
                                                      .toString() ??
                                                  "",
                                            )))),
                          );
                        }),
                  )
                : new Image.network(
                    "http://artzlearn.com/app-api/vertical_list.gif"),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15, 5, 25, 5),
                  child: new AutoSizeText(
                    "Most Liked Courses",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                new GestureDetector(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        new Padding(
                          padding: new EdgeInsets.fromLTRB(25, 5, 5, 5),
                          child: new AutoSizeText(
                            "See All",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        new Padding(
                            padding: new EdgeInsets.fromLTRB(0, 5, 25, 5),
                            child: new Icon(Icons.arrow_drop_down))
                      ],
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourseCat(
                                  cat_id: 0,
                                  c_type: 'm_liked',
                                )))),
              ],
            ),
            _isMostPopularCourseLoaded
                ? new ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: data_mostPopular.length < 0
                        ? 0
                        : data_mostPopular.length,
                    itemBuilder: (BuildContext context, int i) {
                      return new Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.grey.withOpacity(00.6),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: new ListTile(
                            title: new Container(
                              padding: new EdgeInsets.only(top: 5, left: 5),
                              child: new AutoSizeText(
                                data_mostPopular[i]["course_name"].toString() ??
                                    "",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                            subtitle: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                new Container(
                                  padding: new EdgeInsets.only(top: 5, left: 5),
                                  child: new Row(
                                    children: [
                                      new Expanded(
                                        child: new AutoSizeText(
                                          data_mostPopular[i]["price"] == '0'
                                              ? 'FREE'
                                              : data_mostPopular[i]["price"]
                                                      .toString() +
                                                  " Rs",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  padding: new EdgeInsets.only(top: 5, left: 5),
                                  child: new Row(
                                    children: [
                                      SmoothStarRating(
                                        rating: data_mostPopular[i]
                                                    ['rating'] ==
                                                '0'
                                            ? 0.0
                                            : double.parse(data_mostPopular[i]
                                                            ['rating']
                                                        .toString())
                                                    .toDouble() +
                                                0.0,
                                        isReadOnly: true,
                                        size: 11,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star_half,
                                        defaultIconData: Icons.star_border,
                                        starCount: 5,
                                        allowHalfRating: true,
                                        spacing: 2.0,
                                      ),
                                      new Text(
                                        "( " +
                                            data_mostPopular[i]['people']
                                                .toString() +
                                            " )",
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: new Card(
                              elevation: 3.0,
                              child: new Image.network(
                                data_mostPopular[i]["course_img"].toString() ??
                                    "",
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CourseDetails(
                                            cid: data_mostPopular[i]
                                                        ["course_id"]
                                                    .toString() ??
                                                "",
                                          )));
                            },
                          ));
                    })
                : new Image.network(
                    "http://artzlearn.com/app-api/vertical_list.gif"),
          ],
        ),
      ),
      bottomNavigationBar: new BottomNav(
        currentPage: 0,
      ),
    );
  }
}

class CatList extends StatefulWidget {
  @override
  _CatListState createState() => _CatListState();
}

class _CatListState extends State<CatList> {
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_category;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isCatLoaded = false, enable = true;

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

  _category() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "category",
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
          data_category = jsonval["results"];
          if (data_category[0]['status'] == "failed") {
            setState(() {
              _isCatLoaded = false;
            });
          } else if (data_category[0]['status'] == "success") {
            setState(() {
              _isCatLoaded = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _category();
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
        child: _isCatLoaded
            ? new ListView.builder(
                itemCount: data_category.length < 0 ? 0 : data_category.length,
                itemBuilder: (BuildContext context, int i) {
                  return new ListTile(
                    title: new Padding(
                      padding: new EdgeInsets.fromLTRB(5, 20, 5, 20),
                      child: new AutoSizeText(
                        data_category[i]['cat_name'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    trailing: new Icon(Icons.navigate_next_outlined),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseCat(
                                    cat_id: data_category[i]['cat_id'],
                                    c_type: 'cat',
                                  )));
                    },
                  );
                })
            : new Center(child: new CircularProgressIndicator()),
      ),
    );
  }
}

class CourseDetails extends StatefulWidget {
  final cid;
  CourseDetails({this.cid});
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  var rating = 4;
  YoutubePlayerController _controller;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_course, course_Reviews;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController search = new TextEditingController();
  bool _isCourseLoaded = false,
      enable = true,
      _isReviweLoaded = false,
      _no_review = false,
      my_review = false;
  void _settingModalBottomSheet(context, title, amount) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.video_collection_rounded),
                    title: new AutoSizeText('$title'.toUpperCase()),
                    trailing: amount == '0'
                        ? new AutoSizeText("Free")
                        : new AutoSizeText("$amount Rs"),
                    onTap: () => {}),
              ],
            ),
          );
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
          // print(
          //     "So at cid ${(widget.cid)} we have res ${(form_response.toString())}");
          var jsonval = json.decode(form_response.toString());

          data_course = jsonval["results"];
          print("Yaay data course $data_course");
          print(data_course[0]['my_course']);
          if (data_course[0]['status'] == "failed") {
            setState(() {
              _isCourseLoaded = false;
            });
          } else if (data_course[0]['status'] == "success") {
            setState(() {
              _isCourseLoaded = true;
              print('preview_link');
              print(data_course[0]);
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
        print("Yaay data course View ${(form_response.toString())}");
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

  _buyCourse(user_id, price) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "buy_now",
          "course_id": widget.cid.toString() ?? '',
          "user_id": user_id.toString() ?? '',
          "price": price.toString() ?? ''
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
          print("Yaay payment data form_response.toString() " +
              form_response.toString());
          // print(
          //     "So at cid ${(widget.cid)} we have res ${(form_response.toString())}");
          var jsonval = json.decode(form_response.toString());

          var payment_data = jsonval["results"];
          print("Yaay payment data  $payment_data");
          if (payment_data[0]['status'] == "failed") {
            setState(() {
              // _isCourseLoaded = false;
              showInSnackBar("Something went wrong, try again");
            });
          } else if (payment_data[0]['status'] == "success") {
            setState(() {
              if (price.toString().trim() == '0') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LearnPage()));
              } else {
                // WebView
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentWebView(
                              order_id: payment_data[0]['order_id'],
                              amt: price,
                            )));
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

  add_remove_wish(c_id) {
    print("Now added $c_id");
    extraDetails.getshared("wish_list").then((value) {
      setState(() {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          value = value + ',' + c_id;
          var splitted = value.split(",").toSet().toList();
          var new_str = '';
          for (int s = 0; s < splitted.length; s++) {
            // 10,1,2,3   --5
            // if (splitted[s] != c_id) {
            if (s == 0) {
              new_str = splitted[s];
            } else {
              new_str = new_str + ',' + splitted[s];
            }
            // }
          }
          if (new_str != '') {
            // extraDetails.setshared("wish_list", '');
          }
          print("Wish List = $new_str");
          extraDetails.setshared("wish_list", new_str);
          showInSnackBar("Added To Wish List");
        } else {
          print("Wish List Fres = $c_id");
          extraDetails.setshared("wish_list", c_id);
        }
      });
    });
  }

  add_remove_cart(c_id) {
    extraDetails.getshared("cart_list").then((value) {
      setState(() {
        if (value != '' && value != null && value != ' ' && value != 'null') {
          value = value + ',' + c_id;
          var splitted = value.split(",").toSet().toList();
          var new_str = '';
          for (int s = 0; s < splitted.length; s++) {
            if (s == 0) {
              new_str = splitted[s];
            } else {
              new_str = new_str + ',' + splitted[s];
            }
          }
          extraDetails.setshared("cart_list", new_str);
          // Navigator.of(context).pop();
          showInSnackBar("Added To Cart");
        } else {
          extraDetails.setshared("cart_list", c_id);
        }
      });
    });
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
        print("Yaay data course review $course_Reviews");
        if (course_Reviews[0]['status'] == "failed") {
          setState(() {
            _isReviweLoaded = false;
            _no_review = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    extraDetails.getshared("UserAuth").then((value) {
      if (value != '' && value != null && value != ' ' && value != 'null') {
        _courseDetails(value);
        _viewCourseDetails(value);
        _getReview(value);
      }
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    // _controller.de();
    super.deactivate();
  }

  @override
  void dispose() {
    if (data_course[0]['preview_link'].toString() != 'null') {
      _controller.dispose();
    }

    super.dispose();
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: _isCourseLoaded
            ? new ListView(
                //  shrinkWrap: true,
                children: [
                  new Column(
                    children: [
                      new Container(
                        color: extraDetails.getBlueColorOpc(0.7),
                        child: new Padding(
                          padding: new EdgeInsets.fromLTRB(15, 1, 15, 1),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Padding(
                                      padding: new EdgeInsets.all(15.0),
                                      child: new AutoSizeText(
                                        data_course[0]['course_name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                    new Padding(
                                      padding:
                                          new EdgeInsets.fromLTRB(15, 1, 15, 0),
                                      child: new Row(
                                        children: [
                                          new AutoSizeText(
                                            "By",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                      padding:
                                          new EdgeInsets.fromLTRB(15, 5, 15, 0),
                                      child: new Text.rich(
                                        TextSpan(
                                          text: data_course[0]['instr_name'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                          children: <TextSpan>[
                                            // TextSpan(
                                            //     text: 'Name',
                                            //     style: TextStyle(
                                            //         decoration:
                                            //             TextDecoration.underline,
                                            //         decorationStyle:
                                            //             TextDecorationStyle.double,
                                            //         color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              data_course[0]['course_img'] != ''
                                  ? new Image.network(
                                      data_course[0]['course_img'],
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.20,
                                      fit: BoxFit.contain,
                                    )
                                  : new SizedBox()
                            ],
                          ),
                        ),
                      ),
                      data_course[0]['preview_link'].toString() != 'null'
                          ? new SizedBox(
                              child: new Padding(
                                padding:
                                    new EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                ),
                              ),
                            )
                          : new SizedBox(),
                    ],
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: new Row(
                      children: [
                        new Icon(
                          Icons.info_outline,
                          color: extraDetails.getBlueColor(),
                        ),
                        new SizedBox(
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
                          data: data_course[0]['description'].toString() ?? "",
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
                            "h3": Style(
                                fontSize: FontSize.small,
                                textAlign: TextAlign.justify),
                            "p": Style(
                                fontSize: FontSize.small,
                                textAlign: TextAlign.justify),
                            "br": Style(fontSize: FontSize.xxSmall),
                            "tr": Style(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey)),
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
                          Icons.list_alt,
                          color: extraDetails.getBlueColor(),
                        ),
                        new SizedBox(
                          child: new AutoSizeText(
                            " Requirements",
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
                          data: data_course[0]['description'].toString() ?? "",
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
                            "p": Style(
                                fontSize: FontSize.small,
                                textAlign: TextAlign.justify),
                            "h3": Style(
                                fontSize: FontSize.small,
                                textAlign: TextAlign.justify),
                            "br": Style(fontSize: FontSize.xxSmall),
                            "tr": Style(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey)),
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
                          Icons.settings_ethernet_sharp,
                          color: extraDetails.getBlueColor(),
                        ),
                        new SizedBox(
                          child: new AutoSizeText(
                            " Course Outline",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black.withOpacity(0.8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      // height: MediaQuery.of(context).size.height * 0.9,
                      child: new ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: data_course[0]['course_section'].length < 0
                              ? 0
                              : data_course[0]['course_section'].length,
                          itemBuilder: (BuildContext context, int i) {
                            return new Padding(
                              padding: new EdgeInsets.fromLTRB(15, 1, 15, 5),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: new AutoSizeText(
                                  (i + 1).toString() +
                                      ") " +
                                      data_course[0]['course_section'][i]
                                          ['sec_name'],
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black.withOpacity(0.8)),
                                ),
                                children: [
                                  new ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: data_course[0]
                                                          ['course_section'][i]
                                                      ['res']
                                                  .length <
                                              0
                                          ? 0
                                          : data_course[0]['course_section'][i]
                                                  ['res']
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int j) {
                                        return new Padding(
                                          padding: new EdgeInsets.fromLTRB(
                                              15, 15, 15, 5),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              new AutoSizeText(
                                                (Az[j]).toString() +
                                                    ") " +
                                                    data_course[0][
                                                            'course_section'][i]
                                                        ['res'][j]['res_title'],
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black
                                                        .withOpacity(0.8)),
                                              ),
                                              data_course[0]['course_section']
                                                              [i]['res'][j]
                                                          ['type'] ==
                                                      'file'
                                                  ? new Icon(Icons.file_present,
                                                      color: extraDetails
                                                          .getBlueColor())
                                                  : new Icon(Icons.play_arrow,
                                                      color: extraDetails
                                                          .getBlueColor()),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            );
                          })),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      data_course[0]['my_course'] == 'N'
                          ? new Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: new GestureDetector(
                                  // leading: new Icon(Icons.payment, color: Colors.white),
                                  // tileColor: Colors.black.withOpacity(0.6),
                                  // leading: new Icon(Icons.video_collection_rounded),
                                  child: Container(
                                    margin: new EdgeInsets.all(10.0),
                                    padding: new EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    decoration: BoxDecoration(
                                        color: extraDetails.getBlueColor(),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0),
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0))),
                                    child: new Padding(
                                      padding: new EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: new AutoSizeText(
                                        data_course[0]['price'] == '0'
                                            ? 'ENROLL FOR FREE'
                                            : 'BUY NOW',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
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
                                        _buyCourse(
                                            value, data_course[0]['price']);
                                      }
                                    });
                                  }),
                            )
                          : new SizedBox(),
                      data_course[0]['my_course'] == 'Y'
                          ? new Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: new GestureDetector(
                                // leading: new Icon(Icons.payment, color: Colors.white),
                                // tileColor: Colors.black.withOpacity(0.6),
                                // leading: new Icon(Icons.video_collection_rounded),
                                child: Container(
                                  margin: new EdgeInsets.all(10.0),
                                  padding: new EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  decoration: BoxDecoration(
                                      color: extraDetails.getBlueColor(),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0))),
                                  child: new Padding(
                                    padding: new EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: new AutoSizeText(
                                      'CONITNUE TO COURSE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SingleCourse(
                                                cid: widget.cid.toString(),
                                              )));
                                },
                              ),
                            )
                          : new Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: new GestureDetector(
                                  // leading: new Icon(Icons.payment, color: Colors.white),
                                  // tileColor: Colors.black.withOpacity(0.6),
                                  // leading: new Icon(Icons.video_collection_rounded),
                                  child: Container(
                                    margin: new EdgeInsets.all(10.0),
                                    padding: new EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    decoration: BoxDecoration(
                                        color: extraDetails.getBlueColor(),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0),
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0))),
                                    child: new Padding(
                                      padding: new EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: new AutoSizeText(
                                        'ADD TO CART',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    print("Going for cart");
                                    add_remove_cart(widget.cid.toString());
                                  }),
                            ),
                      data_course[0]['my_course'] == 'N'
                          ? new Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: new GestureDetector(
                                  // tileColor: Colors.black.withOpacity(0.6),
                                  // leading: new Icon(Icons.add_shopping_cart,
                                  //     color: Colors.white),
                                  child: Container(
                                    margin: new EdgeInsets.all(10.0),
                                    padding: new EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: extraDetails.getBlueColor(),
                                        ),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight: Radius.circular(20.0),
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0))),
                                    child: new Padding(
                                      padding: new EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: new AutoSizeText(
                                        'ADD TO WISHLIST',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: extraDetails.getBlueColor(),
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    add_remove_wish(widget.cid.toString());
                                  }),
                            )
                          : new SizedBox(),
                    ],
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                    child: new Row(
                      children: [
                        new Icon(
                          Icons.rate_review_outlined,
                          color: extraDetails.getBlueColor(),
                        ),
                        new SizedBox(
                          child: new AutoSizeText(
                            " Reviews ",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black.withOpacity(0.8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isReviweLoaded
                      ? new SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.5,
                          child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: course_Reviews.length < 0
                                  ? 0
                                  : course_Reviews.length,
                              itemBuilder: (BuildContext context, int i) {
                                return new Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black.withOpacity(0.4),
                                        width: 1.0,
                                      ),
                                    )),
                                    padding:
                                        new EdgeInsets.fromLTRB(15, 1, 15, 1),
                                    child: new ListTile(
                                      subtitle: SmoothStarRating(
                                        rating: double.parse(course_Reviews[i]
                                                ['rating']
                                            .toString()),
                                        isReadOnly: true,
                                        size: 15,
                                        filledIconData: Icons.star,
                                        halfFilledIconData: Icons.star_half,
                                        defaultIconData: Icons.star_border,
                                        starCount: 5,
                                        allowHalfRating: true,
                                        spacing: 2.0,
                                      ),
                                      title: new Text(
                                        course_Reviews[i]['review'].toString(),
                                        style: new TextStyle(fontSize: 14),
                                      ),
                                      trailing: new Text(
                                          course_Reviews[i]['name'].toString() +
                                              "\n" +
                                              course_Reviews[i]['added_on']
                                                  .toString(),
                                          style: new TextStyle(fontSize: 12)),
                                    ));
                              }))
                      : _no_review
                          ? new Padding(
                              padding: new EdgeInsets.fromLTRB(15, 15, 15, 5),
                              child: new Row(
                                children: [
                                  new SizedBox(
                                      child: AutoSizeText.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: "No Reviews Yet\n",
                                            style: new TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black
                                                    .withOpacity(0.8))),
                                        data_course[0]['my_course'] == 'Y'
                                            ? TextSpan(
                                                text:
                                                    "Go to Overview tab to review this course",
                                                style: new TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black
                                                        .withOpacity(0.8)))
                                            : new TextSpan(text: " ")
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            )
                          : new SizedBox(),
                  new SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ],
              )
            : new Image.network(
                "http://artzlearn.com/app-api/vertical_list.gif"),
      ),
      bottomNavigationBar: new BottomNav(
        currentPage: 0,
      ),
      backgroundColor: Colors.white,
    );
  }
}
