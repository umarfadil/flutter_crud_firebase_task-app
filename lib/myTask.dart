import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_firebase_mytask/addTask.dart';
import 'package:flutter_crud_firebase_mytask/editTask.dart';
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
        height: 225.0,
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
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new MyHomePage()));
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                new AddTask(
                  email: widget.firebaseUser.email,
                )));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        elevation: 20.0,
        color: Colors.blue,
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
      body: Stack(
        children: <Widget>[
          //untuk menampilkan data
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("task")
                  .where("email", isEqualTo: widget.firebaseUser.email)
                  .snapshots(),
              builder:
                  (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                return new TaskList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),

          Container(
            height: 170.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("images/header.jpg"),
                    fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 8.0)
                ]),
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
                                image: new NetworkImage(
                                    widget.firebaseUser.photoUrl),
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
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String title = document[i].data['title'].toString();
        String notes = document[i].data['notes'].toString();
        DateTime _date = document[i].data['dueDate'];
        String dueDate = "${_date.day}/${_date.month}/${_date.year}";

        return Dismissible(

          key: new Key(document[i].documentID),
          onDismissed: (direction) {
            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
              await transaction.get(document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Data deleted succesfully.."))
            );
          },

          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(title, style: new TextStyle(
                              fontSize: 20.0, letterSpacing: 1.0),),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.date_range, color: Colors.blue,),
                            ),
                            Text(
                                dueDate, style: new TextStyle(fontSize: 18.0,)),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.note, color: Colors.blue,),
                            ),
                            Expanded(child: Text(
                                notes, style: new TextStyle(fontSize: 18.0,))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                new IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue,),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new EditTask(
                            title: title,
                            notes: notes,
                            dueDate: document[i].data['dueDate'],
                            index: document[i].reference,
                          )));
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
