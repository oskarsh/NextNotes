// ORIGINAL AUTHOR: https://github.com/roshanrahman
// MODIFIED BY: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import "./login.dart";
import 'package:notes/services/sharedPref.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:notes/services/database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsPage extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  SettingsPage({Key key, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme;
  @override
  Widget build(BuildContext context) {
    setState(() {
      if (Theme.of(context).brightness == Brightness.dark) {
        selectedTheme = 'dark';
      } else {
        selectedTheme = 'light';
      }
    });

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding:
                        const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Icon(OMIcons.arrowBack)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 36, right: 14),
                child: buildHeaderWidget(context),
              ),
              buildCardWidget(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('App Theme',
                      style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24)),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 'light',
                        groupValue: selectedTheme,
                        onChanged: handleThemeSelection,
                      ),
                      Text(
                        'Light theme',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 'dark',
                        groupValue: selectedTheme,
                        onChanged: handleThemeSelection,
                      ),
                      Text(
                        'Dark theme',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Container(
                    height: 300,
                  ),
                  Container(
                      width: 500,
                      child: Material(
                          elevation: 18.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Theme.of(context).primaryColor,
                          clipBehavior: Clip.antiAlias, // Add This
                          child: MaterialButton(
                              minWidth: 200.0,
                              height: 35,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              color: Theme.of(context).primaryColor,
                              child: new Text('Logout',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Theme.of(context).backgroundColor)),
                              onPressed: () async {
                                // Create storage
                                final storage = new FlutterSecureStorage();
                                // Delete all
                                await storage.deleteAll();
                                NotesDatabaseService.db.flushDb();

                                Navigator.pushReplacementNamed(context, '/');

                                // Navigator.popUntil(
                                //     context,
                                //     ModalRoute.withName(
                                //         Navigator.defaultRouteName));
                              })))
                ],
              )),
            ],
          ))
        ],
      ),
    );
  }

  Widget buildCardWidget(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 8),
                color: Colors.black.withAlpha(20),
                blurRadius: 16)
          ]),
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        'Settings',
        style: TextStyle(
            fontFamily: 'ZillaSlab',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  void handleThemeSelection(String value) {
    setState(() {
      selectedTheme = value;
    });
    if (value == 'light') {
      widget.changeTheme(Brightness.light);
    } else {
      widget.changeTheme(Brightness.dark);
    }
    setThemeinSharedPref(value);
  }

  void openGitHub() {
    launch('https://www.github.com/roshanrahman');
  }
}
