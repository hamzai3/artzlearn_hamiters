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
import 'home.dart';
import 'package:artzlearn/main.dart';
import 'package:flutter/material.dart';
import 'ExtraDetails.dart';
import 'BottomNav.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'learn.dart';
import 'package:artzlearn/payment_webview.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CourseCat extends StatefulWidget {
  final cat_id, c_type;
  CourseCat({this.cat_id, this.c_type});
  @override
  _CourseCatState createState() => _CourseCatState();
}

class _CourseCatState extends State<CourseCat> {
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_course;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isCourseLoaded = false, enable = true;
  String catName = '';

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

  _courseList() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Dd_Course_By_Category",
          "category_id": widget.cat_id.toString() ?? '',
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
          print(
              "Course List here for ${(widget.cat_id)} is ${(form_response.toString())}");
          var jsonval = json.decode(form_response.toString());
          data_course = jsonval["results"];
          if (data_course[0]['status'] == "failed") {
            setState(() {
              _isCourseLoaded = false;
            });
          } else if (data_course[0]['status'] == "success") {
            setState(() {
              _isCourseLoaded = true;
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

  _categoryName() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "category",
          "category_id": widget.cat_id ?? '',
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
          // jsonval["results"];
          if (jsonval["results"][0]['status'] == "success") {
            setState(() {
              catName = jsonval["results"][0]['cat_name'];
              print(catName);
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
      data_course = jsonval["results"];
      if (data_course[0]['status'] == "failed") {
        setState(() {
          _isCourseLoaded = false;
        });
      } else if (data_course[0]['status'] == "success") {
        setState(() {
          _isCourseLoaded = true;
        });
      }
    });
  }

  decodeRecentCourse(js) {
    setState(() {
      var jsonval = json.decode(js.toString());
      data_course = jsonval["results"];
      if (data_course[0]['status'] == "failed") {
        setState(() {
          _isCourseLoaded = false;
        });
      } else if (data_course[0]['status'] == "success") {
        setState(() {
          _isCourseLoaded = true;
        });
      }
    });
  }

  decodePopularCourse(js) {
    setState(() {
      var jsonval = json.decode(js.toString());
      data_course = jsonval["results"];
      if (data_course[0]['status'] == "failed") {
        setState(() {
          _isCourseLoaded = false;
        });
      } else if (data_course[0]['status'] == "success") {
        setState(() {
          _isCourseLoaded = true;
        });
      }
    });
  }

  decodeMostPopularCourse(js) {
    setState(() {
      var jsonval = json.decode(js.toString());
      data_course = jsonval["results"];
      if (data_course[0]['status'] == "failed") {
        setState(() {
          _isCourseLoaded = false;
        });
      } else if (data_course[0]['status'] == "success") {
        setState(() {
          _isCourseLoaded = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.c_type == 'cat') {
      _categoryName();
      _courseList();
    } else if (widget.c_type == 'rec') {
      // _categoryName();
      catName = "Recent Course";
      _recentCourse();
    } else if (widget.c_type == 'pop') {
      // _categoryName();
      catName = "Popular Course";
      _popularCourse();
    } else if (widget.c_type == 'm_liked') {
      // _categoryName();
      catName = "Most Liked Course";
      _mostPopularCourse();
    } else {}
  }

  TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Padding(
          padding: new EdgeInsets.only(top: 18.0),
          child: new SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
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
          child: _isCourseLoaded
              ? new ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Padding(
                          padding:
                              new EdgeInsets.only(bottom: 5, top: 5, left: 20),
                          child: new AutoSizeText(
                            catName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 2,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    new Divider(
                      height: 2.0,
                    ),
                    new ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            data_course.length < 0 ? 0 : data_course.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  //                   <--- left side
                                  color: Colors.black.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: new ListTile(
                              title: new Padding(
                                padding: new EdgeInsets.only(top: 5, left: 5),
                                child: new AutoSizeText(
                                  data_course[i]["course_name"].toString() ??
                                      "",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              subtitle: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  new Container(
                                    padding:
                                        new EdgeInsets.only(top: 5, left: 5),
                                    child: new Row(
                                      children: [
                                        new Expanded(
                                          child: new AutoSizeText(
                                            data_course[i]["price"] == '0'
                                                ? 'FREE'
                                                : data_course[i]["price"]
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
                                    padding:
                                        new EdgeInsets.only(top: 5, left: 5),
                                    child: new Row(
                                      children: [
                                        new SmoothStarRating(
                                          rating:
                                              data_course[i]['rating'] == '0'
                                                  ? 0.0
                                                  : double.parse(data_course[i]
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
                                              data_course[i]['people']
                                                  .toString() +
                                              " )",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: new Image.network(
                                data_course[i]['course_img'].toString(),
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CourseDetails(
                                              cid: data_course[i]['course_id']
                                                  .toString(),
                                            )));
                              },
                            ),
                          );
                        }),
                  ],
                )
              : new Center(child: new CircularProgressIndicator())),
      bottomNavigationBar: new BottomNav(
        currentPage: 0,
      ),
    );
  }
}

class CartList extends StatefulWidget {
  final type;
  CartList({this.type});
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_course;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isCourseLoaded = false,
      enable = true,
      _notFound = false,
      isSubmitted = false;
  String catName = '', order_id_list = '';
  var total = 0.0;
  _courseList(cat_id) async {
    print("getting ${(widget.type)} and $cat_id");
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Wishlist_fetching",
          "course_list": cat_id.toString() ?? '',
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
          print("Course List here for    is ${(form_response.toString())}");
          var jsonval = json.decode(form_response.toString());
          data_course = jsonval["results"];
          if (data_course[0]['status'] == "failed") {
            setState(() {
              _isCourseLoaded = false;
            });
          } else if (data_course[0]['status'] == "success") {
            setState(() {
              for (int c = 0; c < data_course.length; c++) {
                total = total + double.parse(data_course[c]['price']);
              }

              _isCourseLoaded = true;
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

  _buyCourse(user_id, index) async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "buy_now",
          "course_id": data_course[index]['course_id'].toString() ?? '',
          "user_id": user_id.toString() ?? '',
          "price": data_course[index]['price'].toString() ?? '',
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

          var payment_data = jsonval["results"];
          if (payment_data[0]['status'] == "failed") {
            setState(() {
              showInSnackBar("Something went wrong, try again");
            });
          } else if (payment_data[0]['status'] == "success") {
            setState(() {
              if (order_id_list == '') {
                order_id_list = payment_data[0]['order_id'];
              } else {
                order_id_list =
                    order_id_list + "," + payment_data[0]['order_id'];
              }
              print(order_id_list);
            });
            go();
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
    if (widget.type == 'wish') {
      extraDetails.getshared("wish_list").then((value) {
        print("hey See Wish $value");
        if (value != '' && value != null && value != ' ' && value != 'null') {
          _courseList(value);
        } else {
          setState(() {
            _notFound = true;
            _isCourseLoaded = true;
          });
        }
      });
    }
    if (widget.type == 'cart') {
      extraDetails.getshared("cart_list").then((value) {
        print("hey See Cart $value");
        if (value != '' && value != null && value != ' ' && value != 'null') {
          _courseList(value);
        } else {
          setState(() {
            _notFound = true;
            _isCourseLoaded = true;
          });
        }
      });
    }
    // print()
  }

  go() {
    print(order_id_list.split(",").length);
    print(data_course.length);
    if (order_id_list.split(",").length == data_course.length) {
      setState(() {
        isSubmitted = false;
      });
      if (total == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LearnPage()));
      } else {
        print('order_id_list $order_id_list');
        // WebView
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentWebView(
                      order_id: order_id_list,
                      amt: total,
                    )));
      }
    }
  }

  TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Padding(
          padding: new EdgeInsets.only(top: 18.0),
          child: new SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
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
          child: _isCourseLoaded
              ? !_notFound
                  ? new ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Padding(
                              padding: new EdgeInsets.only(
                                  bottom: 5, top: 5, left: 20),
                              child: new AutoSizeText(
                                widget.type == 'wish' ? "Wishlist" : "Cart",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        new Divider(
                          height: 2,
                        ),
                        new ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                data_course.length < 0 ? 0 : data_course.length,
                            itemBuilder: (BuildContext context, int i) {
                              return new Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      //                   <--- left side
                                      color: Colors.black.withOpacity(0.4),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: new ListTile(
                                  title: new Padding(
                                    padding:
                                        new EdgeInsets.only(top: 5, left: 5),
                                    child: new AutoSizeText(
                                      data_course[i]["course_name"]
                                              .toString() ??
                                          "",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  subtitle: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      new Container(
                                        padding: new EdgeInsets.only(
                                            top: 5, left: 5),
                                        child: new Row(
                                          children: [
                                            new Expanded(
                                              child: new AutoSizeText(
                                                data_course[i]["price"] == '0'
                                                    ? 'FREE'
                                                    : data_course[i]["price"]
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
                                            new SmoothStarRating(
                                              rating: data_course[i]
                                                          ['rating'] ==
                                                      '0'
                                                  ? 0.0
                                                  : double.parse(data_course[i]
                                                                  ['rating']
                                                              .toString())
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
                                                  data_course[i]['people']
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
                                  ),
                                  trailing: new Image.network(
                                    data_course[i]['course_img'].toString(),
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CourseDetails(
                                                  cid: data_course[i]
                                                          ['course_id']
                                                      .toString(),
                                                )));
                                  },
                                ),
                              );
                            }),
                        widget.type == 'cart'
                            ? new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  new Padding(
                                    padding:
                                        new EdgeInsets.fromLTRB(15, 25, 25, 5),
                                    child: new AutoSizeText(
                                      total == 0
                                          ? "Get above courses free."
                                          : "Total $total Rs",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  isSubmitted
                                      ? new Center(
                                          child:
                                              new CircularProgressIndicator(),
                                        )
                                      : new GestureDetector(
                                          child: new Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              margin: new EdgeInsets.all(20.0),
                                              padding: new EdgeInsets.all(0.0),
                                              decoration: BoxDecoration(
                                                  color: extraDetails
                                                      .getBlueColor(),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20.0),
                                                      bottomRight:
                                                          Radius.circular(20.0),
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight: Radius.circular(
                                                          20.0))),
                                              child: new Center(
                                                child: new AutoSizeText(
                                                  "CHECKOUT",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                              )),
                                          onTap: () {
                                            setState(() {
                                              isSubmitted = true;
                                            });
                                            showInSnackBar("Please wait");
                                            for (int c = 0;
                                                c < data_course.length;
                                                c++) {
                                              // total = total + double.parse(data_course[c]['price']);
                                              extraDetails
                                                  .getshared("UserAuth")
                                                  .then((value) {
                                                if (value != '' &&
                                                    value != null &&
                                                    value != ' ' &&
                                                    value != 'null') {
                                                  _buyCourse(value, c);
                                                }
                                              });
                                            }
                                          }),
                                ],
                              )
                            : new SizedBox(),
                      ],
                    )
                  : new Center(
                      child: new Text(
                      "Oops, Its Empty",
                      style: new TextStyle(fontSize: 26),
                    ))
              : new Center(child: new CircularProgressIndicator())),
      bottomNavigationBar: new BottomNav(
        currentPage: widget.type == 'cart' ? 2 : 0,
      ),
    );
  }
}

class SearchList extends StatefulWidget {
  final keyword;
  SearchList({this.keyword});
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  ExtraDetails extraDetails = new ExtraDetails();
  Response form_response;
  List data_course;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isCourseLoaded = false,
      enable = true,
      _notFound = false,
      isSubmitted = false;
  String catName = '', order_id_list = '';
  var total = 0.0;
  _search() async {
    try {
      var dio = Dio();
      dio.transformer = new FlutterTransformer();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData = new FormData.fromMap({
          "Dd_Details": "Search_Query",
          "title": widget.keyword.toString() ?? '',
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
          print("Course List here for    is ${(form_response.toString())}");
          var jsonval = json.decode(form_response.toString());
          data_course = jsonval["results"];
          if (data_course[0]['status'] == "failed") {
            setState(() {
              print("Yup Failed");
              _isCourseLoaded = true;
              _notFound = true;
            });
          } else if (data_course[0]['status'] == "success") {
            setState(() {
              for (int c = 0; c < data_course.length; c++) {
                total = total + double.parse(data_course[c]['price']);
              }
              _isCourseLoaded = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _search();
    // print()
  }

  TextEditingController search = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Padding(
          padding: new EdgeInsets.only(top: 18.0),
          child: new SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
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
          child: _isCourseLoaded
              ? !_notFound
                  ? new ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       
                       new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Padding(
                          padding:
                              new EdgeInsets.only(bottom: 5, top: 5, left: 20),
                          child: new AutoSizeText(
                                                            "Search: " +
                                    widget.keyword.toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle( 
                                height: 2,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                       new Divider(height: 2,),
                        new ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount:
                                data_course.length < 0 ? 0 : data_course.length,
                            itemBuilder: (BuildContext context, int i) {
                              return new Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      //                   <--- left side
                                      color: Colors.black.withOpacity(0.4),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: new ListTile(
                                  title: new Padding(
                                padding: new EdgeInsets.only(top: 5, left: 5),
                                child: new AutoSizeText(
                                  data_course[i]["course_name"].toString() ??
                                      "",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                                  subtitle:  new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  new Container(
                                    padding:
                                        new EdgeInsets.only(top: 5, left: 5),
                                    child: new Row(
                                      children: [
                                        new Expanded(
                                          child: new AutoSizeText(
                                            data_course[i]["price"] == '0'
                                                ? 'FREE'
                                                : data_course[i]["price"]
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
                                    padding:
                                        new EdgeInsets.only(top: 5, left: 5),
                                    child: new Row(
                                      children: [
                                        new SmoothStarRating(
                                          rating:
                                              data_course[i]['rating'] == '0'
                                                  ? 0.0
                                                  : double.parse(data_course[i]
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
                                              data_course[i]['people']
                                                  .toString() +
                                              " )",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                                  trailing: new Image.network(
                                    data_course[i]['course_img'].toString(),
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CourseDetails(
                                                  cid: data_course[i]
                                                          ['course_id']
                                                      .toString(),
                                                )));
                                  },
                                ),
                              );
                            }),
                      ],
                    )
                  : new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Padding(
                          padding: new EdgeInsets.fromLTRB(15, 25, 25, 5),
                          child: new AutoSizeText(
                            "No matching keywords found for " +
                                widget.keyword.toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    )
              : new Center(child: new CircularProgressIndicator())),
      bottomNavigationBar: new BottomNav(
        currentPage: 0,
      ),
    );
  }
}
