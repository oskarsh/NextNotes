// AUTHOR: https://github.com/daehruoydeef
// LICENSE: Apache-2.0
// DESCRIPTION:

import 'dart:convert';
import 'package:http/http.dart';
import "package:notes/data/models.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../services/database.dart";
import 'package:connectivity/connectivity.dart';
import 'package:notes/services/sharedPref.dart';
import 'package:localstorage/localstorage.dart';

// Create storage
final storage = new FlutterSecureStorage();
final LocalStorage localstorage = new LocalStorage('offline');

Future fetchNotes() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // NOT CONNECTED SAVE TO UNSYNCED
    print("STILL NO INTERNET DO NOT NEED TO TRY SYNC");
  } else {
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
      var content = note["content"];
      var contentWords = content.split("\n");
      content = contentWords.sublist(1);
      content = content.join(" ");
      print(note["favorite"]);
      notesList.add(new NotesModel(
          content: content,
          title: note["title"],
          date:
              new DateTime.fromMillisecondsSinceEpoch(note["modified"] * 1000),
          id: note["id"],
          isImportant: note["favorite"]));
    }
    return notesList;
  }
}

Future<int> createNewNote(note) async {
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  String content = note.title + '\n' + note.content;
  print(note.id);

// check for internet
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // NOT CONNECTED SAVE TO UNSYNCED
    var createdNotesIDs = [];
    if (localstorage.getItem("createdNotesIDs") != null) {
      createdNotesIDs = localstorage.getItem("createdNotesIDs");
    }
    createdNotesIDs.add(note.id);
    print("ADDED NOTE TO LOCALSTORAGE");
    localstorage.setItem("createdNotesIDs", createdNotesIDs);
  } else {
    await post(nxadress + '/index.php/apps/notes/api/v0.2/notes',
        headers: {'authorization': basicAuth},
        body: {'content': content}).then((value) {
      var decoded = json.decode(value.body);
      note.id = decoded["id"];
      NotesDatabaseService.db.updateNoteInDB(note);
      return value.statusCode;
    });
  }
}

Future<int> deleteNote(noteId) async {
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print("DELETING");
  noteId = noteId.toString();
  print(noteId);
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    // NOT CONNECTED SAVE TO UNSYNCED
    var deletedNotesIDs = [];
    if (localstorage.getItem("deletedNotesIDs") != null) {
      deletedNotesIDs = localstorage.getItem("deletedNotesIDs");
    }
    deletedNotesIDs.add(int.parse(noteId));
    print("ADDED NOTE TO LOCALSTORAGE");
    localstorage.setItem("deletedNotesIDs", deletedNotesIDs);
  } else {
    await delete(nxadress + '/index.php/apps/notes/api/v0.2/notes/' + noteId,
        headers: {'authorization': basicAuth}).then((value) {
      return value.statusCode;
    });
  }
}

Future<int> updateNote(note) async {
  String username = await storage.read(key: "username");
  String password = await storage.read(key: "password");
  String nxadress = await storage.read(key: "nxadress");
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print("UPDATING NOTE");
  String noteId = note.id.toString();
  String content = note.title + '\n' + note.content;
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    // NOT CONNECTED SAVE TO UNSYNCED
    var updatedNotesIDs = [];
    if (localstorage.getItem("updatedNotesIDs") != null) {
      updatedNotesIDs = localstorage.getItem("updatedNotesIDs");
    }
    updatedNotesIDs.add(note.id);
    print("ADDED NOTE TO LOCALSTORAGE");
    localstorage.setItem("createdNotesIDs", updatedNotesIDs);
  } else {
    print("UPDATING: "+ noteId);
    await put(nxadress + '/index.php/apps/notes/api/v0.2/notes/' + noteId,
        headers: {'authorization': basicAuth},
        body: {"content": content}).then((value) {
      return value.statusCode;
    });
  }
}
