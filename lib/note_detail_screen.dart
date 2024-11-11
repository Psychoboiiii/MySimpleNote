import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note.dart';
import 'package:sqflite_common_ffi_web/setup.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailsScreen({super.key, this.note});

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  late DatabaseHelper helper;

  @override
  void initState() {
    super.initState();
    helper = DatabaseHelper();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Note note = Note(
        id: widget.note?.id,
        title: _title,
        content: _content,
        date: DateTime.now().toString(),
      );

      if (widget.note == null) {
        await helper.insertNote(note);
      } else {
        await helper.updateNote(note);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.note == null ? 'New Note' : 'Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter content' : null,
                onSaved: (value) => _content = value!,
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
