import 'package:flutter/material.dart';
import 'note_list_screen.dart';
import 'package:sqflite_common_ffi_web/setup.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() {
  runApp(MySimpleNoteApp());
}

class MySimpleNoteApp extends StatelessWidget {
  const MySimpleNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySimpleNote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoteListScreen(),
      debugShowCheckedModeBanner: false, // Removes the debug banner
    );
  }
}
