import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("images/header.jpg"), fit: BoxFit.cover),
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 8.0
              )
            ]
          )),
    );
  }
}
