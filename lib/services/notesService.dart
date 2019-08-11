import 'dart:convert';
import 'package:http/http.dart';
import "package:notes/data/models.dart";

fetchNotes() async {
  print("fetching notes");
  String username = 'oskar';
  String password =
      'nqDnFKTM5jJ34hTWY4xoiXJJ8pbT7w9EtC4VPpcM8yYaLZ7D42MpCfczoKBeuvHR4G75EA2';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print(basicAuth);

  Response r = await get('https://nx4562.your-next.cloud/index.php/apps/notes/api/v0.2/notes',
      headers: {'authorization': basicAuth});
  var notes = json.decode(r.body);
  List<NotesModel> notesList = [];
  for (var note in notes) {
    print("NOTE INCOMING");
    var content = note["content"];
    // var contentWords = note["content"].split("\n");
    // String content = contentWords.sublist(1);
    notesList.add(new NotesModel(content: content, title: note["title"], date: DateTime.now(),id: note["id"], isImportant: false));
  }
  return notesList;
}

void createNewNote(note) async {
  String username = 'oskar';
  String password =
      'nqDnFKTM5jJ34hTWY4xoiXJJ8pbT7w9EtC4VPpcM8yYaLZ7D42MpCfczoKBeuvHR4G75EA2';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  String content = note.title + '\n' + note.content;

  await post(
      'https://nx4562.your-next.cloud/index.php/apps/notes/api/v0.2/notes',
      headers: {'authorization': basicAuth},
      body: {'content': content});
}

void deleteNote(noteId) async {
  String username = 'oskar';
  String password =
      'nqDnFKTM5jJ34hTWY4xoiXJJ8pbT7w9EtC4VPpcM8yYaLZ7D42MpCfczoKBeuvHR4G75EA2';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print("DELETING");
  print(noteId);
  await delete(
      'https://nx4562.your-next.cloud/index.php/apps/notes/api/v0.2/notes/'+noteId.toString(),
      headers: {'authorization': basicAuth});
}


void updateNote(note) async {
  String username = 'oskar';
  String password =
      'nqDnFKTM5jJ34hTWY4xoiXJJ8pbT7w9EtC4VPpcM8yYaLZ7D42MpCfczoKBeuvHR4G75EA2';
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  print("UPDATING NOTE");
  String noteId = note.id.toString();
  String content = note.title + '\n' + note.content;
  print("pushing");
  print(content);
  await put(
      'https://nx4562.your-next.cloud/index.php/apps/notes/api/v0.2/notes/'+noteId,
      headers: {'authorization': basicAuth},
      body: {"content": content});
}
