import 'package:notes/services/sharedPref.dart';
import 'package:connectivity/connectivity.dart';
import 'package:notes/services/notesService.dart';

import 'package:notes/services/database.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage localstorage = new LocalStorage('offline');
const keys = ["updatedNotesIDs", "createdNotesIDs", "deletedNotesIDs"];

class OfflineService {
  bool _isOnline = false;

  OfflineService() {
    print("ADDING OFFLINE SERVICE");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print(result);
      if (result == ConnectivityResult.none) {
        _isOnline = false;
      } else {
        print("CHECKING IF I CAN SYNC");
        if (_canSync()) {
          print("I CAN SYNC!");
          syncAll();
        }
        _isOnline = true;
      }
    });
  }

  bool _canSync() {
    print("CHECKING IF THERE ARE ANY ITEMS");
    List<dynamic> item1 = localstorage.getItem("updatedNotesIDs");
    if (item1 != null) {
      return true;
    }
    List<dynamic> item2 = localstorage.getItem("createdNotesIDs");
    if (item2 != null) {
      return true;
    }
    List<dynamic> item3 = localstorage.getItem("deletedNotesIDs");
    if (item3 != null) {
      return true;
    }
    return false;
  }

  syncAll() {
    syncCreatedNotes();
    syncUpdatedNotes();
    syncDeletedNotes();
  }

  syncDatabase() async {
    await fetchNotes().then((notes) {
      if (notes != null) {
        print(notes);
        NotesDatabaseService.db.flushDb();
        for (var note in notes) {
          NotesDatabaseService.db.addNoteInDBWithId(note);
        }
      }
    });
  }

  syncDeletedNotes() async {
    List<dynamic> items = localstorage.getItem("deletedNotesIDs");
    print("syncing deleted notes");
    if (items != null) {
      for (var id in items) {
        await NotesDatabaseService.db
            .getNoteWithId(id.toString())
            .then((notes) {
          print(notes);
          if (notes.length != 0) {
            print("SYNCING deleted OFFLINE NOTE:");
            print(notes[0].title);
            deleteNote(notes[0].id).then((statusCode) {
              print("REMOVING ID: " + id.toString());
              items.remove(id);
            });
          }
        });
      }
    }
  }

  syncUpdatedNotes() {
    List<dynamic> items = localstorage.getItem("updatedNotesIDs");
    print("syncing updated notes");
    if (items != null) {
      for (var id in items) {
        NotesDatabaseService.db.getNoteWithId(id).then((notes) {
          print(notes);
          if (notes.length != 0) {
            print("SYNCING updated OFFLINE NOTE:");
            print(notes[0].title);
            updateNote(notes[0]).then((statusCode) {
              print("REMOVING updated ID: " + id.toString());
              items.remove(id);
            });
          }
        });
      }
    }
  }

  syncCreatedNotes() {
    List<dynamic> items = localstorage.getItem("createdNotesIDs");
    print("syncing created notes");
    if (items != null) {
      print("ITEMS: " + items.toString());
      for (var id in items) {
        NotesDatabaseService.db.getNoteWithId(id).then((notes) {
          print(notes);
          if (notes.length != 0) {
            print("SYNCING new created OFFLINE NOTE:");
            print(notes[0].title);
            createNewNote(notes[0]).then((statusCode) {
              print(statusCode);
              print("REMOVING ID: " + id.toString());
              items.remove(id);
              localstorage.setItem("createdNotesIDs", items);
            });
          }
        });
      }
    }
  }

  bool get isOnline {
    return _isOnline;
  }
}
