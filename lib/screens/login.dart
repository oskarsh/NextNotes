// AUTHOR: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:

import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/home.dart';
import "./home.dart";
import "./splash.dart";
import "../components/cards.dart";

class Login extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  Login({Key key, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _username;
  String _password;
  String _nxadress;
  bool _loggedIn = false;

  @override
  void initState() {
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    final storage = new FlutterSecureStorage();
    storage.read(key: "password").then((value) {
      if (value != null ) {
        setState(() {
          _loggedIn = true;
        });
      }
    });
  }

  void handleLogin() async {

    // force https
    if (!_nxadress.startsWith("https://")) {
      _nxadress = "https://" + _nxadress;
    }
    // Create storage
    final storage = new FlutterSecureStorage();
    // Write value
    await storage.write(key: "username", value: _username);
    await storage.write(key: "password", value: _password);
    await storage.write(key: "nxadress", value: _nxadress);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Splash(
                  title: "Splash",
                  changeTheme: widget.changeTheme,
                )));
  }

  _showAuthOrApp(
      context, usernameField, passwordField, nextcloudAdressField, loginButton) {
    if (!_loggedIn) {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 30,
            color: Theme.of(context).backgroundColor,
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Text(
              "NextNotes",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Container(
              alignment: Alignment.center,
              height: 340,
              padding: const EdgeInsets.all(30.0),
              margin: const EdgeInsets.all(30.0),
              decoration: new BoxDecoration(
                color: Theme.of(context).backgroundColor, 
                borderRadius: new BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  new BoxShadow(
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  usernameField,
                  SizedBox(height: 15),
                  passwordField,
                  SizedBox(height: 15),
                  nextcloudAdressField,
                  SizedBox(height: 25),
                  loginButton
                ],
              ))
        ],
      ));
    } else {
      return (MyHomePage(
        title: "home",
        changeTheme: widget.changeTheme,
      ));
    }
   }

    @override
    Widget build(BuildContext context) {
      TextStyle style = TextStyle(
          fontFamily: 'ZillaSlab', fontSize: 20.0, color: Theme.of(context).backgroundColor);

      final usernameField = TextField(
        obscureText: false,
        style: style,
        autofocus: true,
        onChanged: (text) {
          _username = text;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Username",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      );
      final passwordField = TextField(
        obscureText: true,
        enableInteractiveSelection: true,
        style: style,
        onChanged: (text) {
          _password = text;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)), focusColor: Theme.of(context).accentIconTheme.color,),
      );
      final nextcloudAdressField = TextField(
        obscureText: false,
        style: style,
        onChanged: (text) {
          _nxadress = text;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Nextcloud Server",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      );
      final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: handleLogin,
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Theme.of(context).backgroundColor, fontWeight: FontWeight.bold)),
        ),
      );

      // if (_loggedIn) {
      //        Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => MyHomePage(
      //                 title: "Home",
      //                 changeTheme: widget.changeTheme)));
      // }

      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Center(
              child: _showAuthOrApp(context, usernameField, passwordField,
                  nextcloudAdressField, loginButton)));
    }
  }

