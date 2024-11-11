import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note.dart';
import 'note_detail_screen.dart'; // Adjust import path if necessary

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NoteDetailsScreen(), // Opens NoteDetailScreen for a new note
      ),
    );
    _loadNotes(); // Reload notes after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MySimpleNote')),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          Note note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.date),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailsScreen(
                      note: note), // Passes selected note for editing
                ),
              );
              _loadNotes(); // Reload notes after editing
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _dbHelper.deleteNoteById(note.id!);
                _loadNotes();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
