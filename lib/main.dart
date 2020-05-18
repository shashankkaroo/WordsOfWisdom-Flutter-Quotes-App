import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordsofwisdom/GoogleLogin.dart';
import 'package:wordsofwisdom/QuotesPage.dart';
import 'package:wordsofwisdom/Utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Connectivity _connectivity = new Connectivity();
  var _connectionStatus;
  bool isLoading = false;
  GlobalKey _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        body: Center(
            child: Stack(children: <Widget>[
          Image.asset(
            "images/aa.gif",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            color: Colors.black26,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text(
              'Words of Wisdom',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 70,
                    fontWeight: FontWeight.bold),
              ),
            )),
          ),
          Container(
            color: Colors.transparent,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: BorderSide(color: Colors.white)),
              onPressed: _onClickGooglelogin,
              child: Text("Google Login",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.droidSans(
                      textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          (isLoading)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container()
        ])));
  }

  _onClickGooglelogin() {
    _connectivity.checkConnectivity().then((status) async {
      _connectionStatus = status.toString();

      if (_connectionStatus != "ConnectivityResult.none") {
        setState(() {
          isLoading = true;
        });
        FirebaseUser user = await GoogleLogin.signInWithGoogle();
        addUserToFirebaseDB(user).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => QuotesPage(true)));
        });
      } else {
        UiUtils.showInSnackBar(
            "Please check internet connection", context, _key);
      }
    });
  }

  //.......create firebase user...........

  Future addUserToFirebaseDB(FirebaseUser data) async {
    try {
      return await Firestore.instance
          .collection('users')
          .document(data.email.toString())
          .setData(
              {'email': data.email, 'name': data.displayName });
    } catch (e) {
      print(e);
    }
  }
}
