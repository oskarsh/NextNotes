
// AUTHOR: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:  


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
  String test = "TEST";

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
    fetchNotes().then((notes)  {
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
      return RaisedButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                    title: "Home", changeTheme: widget.changeTheme)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center, child: _loadingView(context)));
  }
}
