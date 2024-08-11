import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_notes/bloc/notes_bloc.dart';
import 'package:sql_notes/screens/notes_screen.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc()..add(const GetListOfNotesEvent()),
      child: const MaterialApp(
        home: NoteScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
