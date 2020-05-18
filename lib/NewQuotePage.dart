import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordsofwisdom/GoogleLogin.dart';
import 'package:wordsofwisdom/Utils.dart';

class NewQuotePage extends StatefulWidget {
  @override
  _NewQuotePageState createState() => _NewQuotePageState();
}

class _NewQuotePageState extends State<NewQuotePage> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  Connectivity _connectivity = new Connectivity();
  var _connectionStatus;
  bool isLoading = false;
  TextEditingController quotesController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
          title: Text(
            'Add Quotes',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: addNewQuotePage,
          backgroundColor: Colors.black,
          icon: Icon(Icons.save),
          label: Text("Save"),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 50),
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(20),
                            child: new TextFormField(
                                maxLines: 10,
                                controller: quotesController,
                                keyboardType: TextInputType.multiline,
                                decoration: new InputDecoration(
                                  labelText: "Enter Quote",
                                  fillColor: Colors.black,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.length == 0) {
                                    return "Quote text cannot be empty";
                                  } else {
                                    return null;
                                  }
                                })),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(20),
                            child: new TextFormField(
                                maxLines: 2,
                                controller: authorController,
                                keyboardType: TextInputType.multiline,
                                decoration: new InputDecoration(
                                  labelText: "Author",
                                  fillColor: Colors.black,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                validator: (val) {
                                  if (val.length == 0) {
                                    return "Author cannot be empty";
                                  } else {
                                    return null;
                                  }
                                }))
                      ],
                    )),
                (isLoading)
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ],
            )));
  }

  Future addQuotesToFirebaseDB() async {
    try {
      String author = authorController.text.toString();
      String quote = quotesController.text.toString();
      final collRef = Firestore.instance.collection('quotes');
      DocumentReference docReference = collRef.document();
      return await docReference.setData(
          {'author': author, 'quote': quote, 'id': docReference.documentID});
    } catch (e) {
      print(e);
    }
  }

  addNewQuotePage() {
    _connectivity.checkConnectivity().then((status) async {
      _connectionStatus = status.toString();
      if (_connectionStatus != "ConnectivityResult.none") {
        if (_formKey.currentState.validate()) {
          setState(() {
            isLoading = true;
          });
          addQuotesToFirebaseDB().then((value) {
            setState(() {
              isLoading = false;
            });
            UiUtils.showInSnackBar("Quote saved successfully", context, _key);
          });
        }
      } else {
        UiUtils.showInSnackBar(
            "Please check internet connection", context, _key);
      }
    });
  }
}
