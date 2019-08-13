import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:notes/services/database.dart';
import './home.dart';
import 'package:notes/services/notesService.dart';
import 'package:notes/services/database.dart';
import 'package:loading/loading.dart';
import "./home.dart";

class Splash extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  Splash({Key key, this.title, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }
  final String title;
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.flushDb();
    NotesDatabaseService.db.init();
    syncNextcloud();
  }

  syncNextcloud() async {
    print("getting called");
    // fetching notes with NotesService from Nextcloud
    fetchNotes().then((notes) {
      print(notes);
      for (var note in notes) {
        NotesDatabaseService.db.addNoteInDBWithId(note);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _loadingView(context) {
    print("is loading");
    print(_isLoading);
    if (_isLoading) {
      return Loading(indicator: BallPulseIndicator(), size: 100.0);
    } else {
      return (Center(
          child: Column(
        children: <Widget>[
          Text("Syncing done"),
          Material(
            elevation: 18.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Color(0xff01A0C7),
            clipBehavior: Clip.antiAlias, // Add This
            child: MaterialButton(
              minWidth: 200.0,
              height: 35,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              color: Color(0xff01A0C7),
              child: new Text('Explore the App',
                  style: new TextStyle(fontSize: 16.0, color: Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                            title: "Home", changeTheme: widget.changeTheme)));
              },
            ),
          )
        ],
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
            alignment: Alignment.center, child: _loadingView(context)));
  }
}
