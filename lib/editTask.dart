import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  EditTask({this.title, this.dueDate, this.notes, this.index});
  final String title;
  final String notes;
  final DateTime dueDate;
  final index;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  TextEditingController controllerTitle;
  TextEditingController controllerNotes;

  DateTime _dueDate;
  String _dateText = '';

  String newTask;
  String notes;

  void _updateTask() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot =
      await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "title" : newTask,
        "notes" : notes,
        "dueDate" : _dueDate
      });
    });
    Navigator.pop(context);
  }

  Future<Null> _selectDueDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2018),
        lastDate: DateTime(2080));

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        _dateText = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dueDate = widget.dueDate;
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";

    newTask = widget.title;
    notes = widget.notes;

    controllerTitle = new TextEditingController(text: widget.title);
    controllerNotes = new TextEditingController(text: widget.notes);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/header.jpg"),
                      fit: BoxFit.cover),
                  color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "My Task",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        letterSpacing: 2.0,
                        fontFamily: "Pacifico"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text("Edit Task",
                        style:
                        new TextStyle(fontSize: 24.0, color: Colors.white)),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32.0,
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerTitle,
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.dashboard),
                  hintText: "New task",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: new Icon(Icons.date_range),
                ),
                Expanded(
                    child: Text(
                      "Due Date",
                      style: new TextStyle(fontSize: 20.0, color: Colors.black54),
                    )),
                FlatButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text(
                      _dateText,
                      style:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerNotes,
              onChanged: (String str) {
                setState(() {
                  notes = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.note),
                  hintText: "Notes",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.check, size: 40.0,),
                    onPressed: (){
                      _updateTask();
                    }),
                IconButton(
                    icon: Icon(Icons.close, size: 40.0,),
                    onPressed: (){
                      Navigator.pop(context);
                    }),

              ],
            ),
          )
        ],
      ),
    );
  }
}
