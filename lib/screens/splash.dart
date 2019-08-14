import 'package:flutter/material.dart';
import 'package:notes/services/database.dart';
import './home.dart';
import 'package:notes/services/notesService.dart';
import 'package:notes/services/database.dart';
import "./home.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    // fetching notes with NtesService from Nextcloud
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
    if (_isLoading) {
      return (Column(children: <Widget>[
        Text("Syncing with Nextcloud this can take up to minute"),
        SpinKitFoldingCube(
          color: Theme.of(context).primaryColor,
          size: 100.0,
        ),
      ]));
    } else {
      return (Container(
          alignment: Alignment.center,
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "NextNotes is now fully synced, \n go ahead and explore the App",
                    style: TextStyle(fontFamily: "ZillaSlab", color: Theme.of(context).primaryTextTheme.body1.color),
                  )),
              Material(
                elevation: 18.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor,
                clipBehavior: Clip.antiAlias, // Add This
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 35,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  color: Theme.of(context).primaryColor,
                  child: new Text('Explore the App',
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                title: "Home",
                                changeTheme: widget.changeTheme)));
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
            alignment: Alignment.center,
            child: _loadingView(context)));
  }
}
