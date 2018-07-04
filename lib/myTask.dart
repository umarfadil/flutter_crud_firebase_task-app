import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_firebase_mytask/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTask extends StatefulWidget {
  MyTask({this.firebaseUser, this.googleSignIn});

  final FirebaseUser firebaseUser;
  final GoogleSignIn googleSignIn;

  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  void _signOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 250.0,
        child: Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(widget.firebaseUser.photoUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "R U Sure want to sign out??",
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) => new MyHomePage())
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(padding: const EdgeInsets.all(5.0)),
                      Text("Yes")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(padding: const EdgeInsets.all(5.0)),
                      Text("Cancel")
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 170.0,
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("images/header.jpg"), fit: BoxFit.cover),
            boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 8.0)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                new NetworkImage(widget.firebaseUser.photoUrl),
                            fit: BoxFit.cover)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Welcome",
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                          new Text(
                            widget.firebaseUser.displayName,
                            style: new TextStyle(
                                fontSize: 24.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        _signOut();
                      })
                ],
              ),
            ),
            new Text(
              "My Task",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 2.0,
                  fontFamily: "Pacifico"),
            )
          ],
        ),
      ),
    );
  }
}
