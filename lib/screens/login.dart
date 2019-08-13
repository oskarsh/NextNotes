// AUTHOR: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:

import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/home.dart';
import "./home.dart";
import "./splash.dart";

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
  bool _loggedIn = true;

  @override
  void initState() {
    checkLoggedIn();
  }

  void checkLoggedIn() async{
    final storage = new FlutterSecureStorage();
    storage.read(key: "password").then((value) {
      print(value);
      // if (value != null) {
      //   setState(() {
      //     _loggedIn = true;
      //   });
      // }
    });
  }

  void handleLogin() async {
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
      context, emailField, passwordField, nextcloudAdressField, loginButton) {
    if (!_loggedIn) {
      return (ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "NextNotes",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: Colors.blue),
          ),
          Container(
              alignment: Alignment.center,
              height: 350,
              padding: const EdgeInsets.all(30.0),
              margin: const EdgeInsets.all(30.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  emailField,
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: "Home",
                    changeTheme: widget.changeTheme,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(fontFamily: 'ZillaSlab', fontSize: 20.0, color: Colors.black);
    final emailField = TextField(
      obscureText: false,
      style: style,
      onChanged: (text) {
        _username = text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          fillColor: Colors.red,
          hintText: "Email",
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
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
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
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: handleLogin,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: _showAuthOrApp(context, emailField, passwordField,
                nextcloudAdressField, loginButton)));
  }
}
