import 'package:shared_preferences/shared_preferences.dart';

Future<String> getThemeFromSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString('theme');
}

void setThemeinSharedPref(String val) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString('theme', val);
}

void setUnsyncedDeletedNotes(String noteid) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  List<String> deletedNotes = sharedPref.getStringList("deletedNotes");
  deletedNotes.add(noteid);
  sharedPref.setStringList("deletedNotes", deletedNotes);
}

void removeAllUnsyncedCreatedNotes() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.remove("createdNotes");
}

Future<List<String>> getUnsyncedDeletedNotes() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getStringList("deletedNotes");
}

void setUnsyncedCreatedNotes(String noteid) async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  List<String> createdNotes = sharedPref.getStringList("createdNotes");
  if (createdNotes == null) {
    createdNotes = [];
  }
  createdNotes.add(noteid);
  sharedPref.setStringList("createdNotes", createdNotes);
}

Future<List<String>> getUnsyncedCreatedNotes() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getStringList("createdNotes");
}
