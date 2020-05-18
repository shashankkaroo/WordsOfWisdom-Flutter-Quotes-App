import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordsofwisdom/GoogleLogin.dart';
import 'package:wordsofwisdom/NewQuotePage.dart';

class QuotesPage extends StatefulWidget {
  bool isMainPage = true;
  QuotesPage(isMainPage) {
    this.isMainPage = isMainPage;
  }

  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.launch,
                  color: Colors.black,
                ),
                onPressed: () {
                  GoogleLogin.logout(context);
                }),
          ],
          title: Text(
            'Quotes',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addNewQuotePage,
          heroTag: "demoTag",
          elevation: 10,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('quotes').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new CircularProgressIndicator();
                  default:
                    return PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, position) {
                          final document = snapshot.data.documents[position];
                          return Container(
                            color: Colors.white,
                            child: Center(
                                child: ListTile(
                                    title: Container(
                                        margin: EdgeInsets.all(8),
                                        child: Text(document['quote'],
                                            style: GoogleFonts.playfairDisplay(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 35,
                                              ),
                                            ))),
                                    subtitle: Container(
                                      margin: EdgeInsets.all(8),
                                      child: Text(document['author'],
                                          style: GoogleFonts.playfairDisplay(
                                            textStyle: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 20),
                                          )),
                                    ))),
                          );
                        });
                }
              },
            )));
  }

  void addNewQuotePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewQuotePage()),
    );
  }

}
