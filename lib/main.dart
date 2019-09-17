// ORIGINAL AUTHOR: https://github.com/roshanrahman 
// MODIFIED BY: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:  


import 'package:flutter/material.dart';
import 'package:notes/services/sharedPref.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/splash.dart';
import 'screens/settings.dart';
import 'data/theme.dart';
import 'services/sharedPref.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = appThemeLight;
  @override
  void initState() {
    super.initState();
    updateThemeFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      routes: {
      '/' : (context) => Login(changeTheme: setTheme),
      '/Splash' : (context) => Splash(changeTheme: setTheme),
      '/Settings' : (context) => SettingsPage(changeTheme: setTheme), 
      '/Home': (context) => MyHomePage(changeTheme: setTheme, title: "Home",),
      }
    );
  }

  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight;
      });
    }
  }

  void updateThemeFromSharedPref() async {
    String themeText = await getThemeFromSharedPref();
    if (themeText == 'light') {
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }
}
