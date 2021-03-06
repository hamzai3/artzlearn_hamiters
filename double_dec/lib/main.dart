import 'package:artzlearn/home.dart';

import 'login.dart';
import 'package:flutter/material.dart';
import 'ExtraDetails.dart';  
void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
        color: Colors.white,
        child: new Center(
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff3278ce)),
          ),
        ));
  };
  runApp(MyApp());
}
//  keytool -exportcert -alias androiddebugkey -keystore "C:\Users\hamza\.android\debug.keystore" | "C:\Users\hamza\Downloads\openssl\bin\openssl" sha1 -binary | "C:\Users\hamza\Downloads\openssl\bin\openssl" base64
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artzlearn',
      theme: ThemeData(
        fontFamily: 'MMed', 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
       routes: <String, WidgetBuilder>{
        '/MyApp': (BuildContext context) => new MyApp(), 
      },
      home: MyHomePage(title: 'Artzlearn'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

ExtraDetails extraDetails = new ExtraDetails();

class _MyHomePageState extends State<MyHomePage> {
  check() {
    extraDetails.getshared("UserAuth").then((value) {
      if (value != 'null' && value != '') {
        // Navigator.of(context).pop();

        Future.delayed(Duration(seconds: 2), () {
          // 5s over, navigate to a new page
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }else{
        // Navigator.of(context).pop();

        Future.delayed(Duration(seconds: 2), () {
          // 5s over, navigate to a new page
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserLogin()));
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new SafeArea(
          child: new Center(
        child: new Column(
          // seconds: 2,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Image.asset(
              'assets/double_dec.png',
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.contain,
            ),
            new CircularProgressIndicator(),
          ],
        ),
      )),
    );
  }
}
