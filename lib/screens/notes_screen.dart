import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_notes/bloc/notes_bloc.dart';
import 'package:sql_notes/model/notes_model.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String createdAt = DateTime.now().toIso8601String();

  void _addNote() {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  context.read<NotesBloc>().add(
                        CreateNewNoteEvent(
                          Notes(
                              title: titleController.text,
                              content: contentController.text,
                              createdAt: createdAt),
                        ),
                      );
                  titleController.clear();
                  contentController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Create'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.event_note_sharp,
          color: Colors.black,
        ),
        title: const Text(
          'My Notes',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.purple.shade200,
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              if (state.status == NoteStateStatus.loading) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.listOfNotes.isEmpty) {
                const Center(
                  child: Text(' Start creating Notes by clicking add button. '),
                );
              } else if (state.listOfNotes.isNotEmpty) {
                Card(
                  color: Colors.purple.shade100,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(state.listOfNotes[index].title),
                    subtitle: Text(state.listOfNotes[index].content),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () => context.read<NotesBloc>().add(
                                  DeleteNoteEvent(
                                      state.listOfNotes[index].noteId!)),
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                const SizedBox();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade200,
        onPressed: _addNote,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
