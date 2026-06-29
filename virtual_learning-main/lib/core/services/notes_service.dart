import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/note_model.dart';

class NotesService {
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  String get _notesKey => 'student_notes_$_uid';

  Future<List<NoteModel>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawNotes = prefs.getStringList(_notesKey) ?? [];

    final notes = rawNotes
        .map(
          (rawNote) =>
              NoteModel.fromJson(jsonDecode(rawNote) as Map<String, dynamic>),
        )
        .toList();

    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return notes;
  }

  Future<void> saveNote(NoteModel note) async {
    final notes = await getNotes();
    final index = notes.indexWhere(
      (existingNote) => existingNote.id == note.id,
    );

    if (index == -1) {
      notes.insert(0, note);
    } else {
      notes[index] = note;
    }

    await _saveNotes(notes);
  }

  Future<void> deleteNote(String noteId) async {
    final notes = await getNotes();

    notes.removeWhere((note) => note.id == noteId);

    await _saveNotes(notes);
  }

  Future<void> _saveNotes(List<NoteModel> notes) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _notesKey,
      notes.map((note) => jsonEncode(note.toJson())).toList(),
    );
  }
}
