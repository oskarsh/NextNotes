
// AUTHOR: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:  

import 'dart:convert';
import 'package:http/http.dart';
import "package:notes/data/models.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = new FlutterSecureStorage();

Future fetchNotes() async {
  print("fetching notes");
  // Read value
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  Response r = await get(nxadress + '/index.php/apps/notes/api/v0.2/notes',
      headers: {'authorization': basicAuth});
  var notes = json.decode(r.body);
  List<NotesModel> notesList = [];
  for (var note in notes) {
    print("NOTE INCOMING");
    var content = note["content"];
    // var contentWords = note["content"].split("\n");
    // String content = contentWords.sublist(1);
    notesList.add(new NotesModel(
        content: content,
        title: note["title"],
        date: DateTime.now(),
        id: note["id"],
        isImportant: false));
  }
  return notesList;
}

void createNewNote(note) async {
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  String content = note.title + '\n' + note.content;

  await post(nxadress + '/index.php/apps/notes/api/v0.2/notes',
      headers: {'authorization': basicAuth}, body: {'content': content});
}

void deleteNote(noteId) async {
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print("DELETING");
  print(noteId);
  await delete(
      nxadress + '/index.php/apps/notes/api/v0.2/notes' + noteId.toString(),
      headers: {'authorization': basicAuth});
}

void updateNote(note) async {
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print("UPDATING NOTE");
  String noteId = note.id.toString();
  String content = note.title + '\n' + note.content;
  print("pushing");
  print(content);
  await put(nxadress + '/index.php/apps/notes/api/v0.2/notes/' + noteId,
      headers: {'authorization': basicAuth}, body: {"content": content});
}
