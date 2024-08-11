import 'package:flutter/material.dart';
import 'package:sql_notes/screens/notes_screen.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NoteScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
