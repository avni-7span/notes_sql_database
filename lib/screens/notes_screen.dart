import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_notes/bloc/notes_bloc.dart';
import 'package:sql_notes/widgets/add_note_bottom_sheet.dart';
import 'package:sql_notes/widgets/update_note_bottom_sheet.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String createdAt = DateTime.now().toIso8601String();
  int? id;

  void _addNote() {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<NotesBloc>(context),
        child: AddBottomSheetWidget(
          titleController: titleController,
          contentController: contentController,
          createdAt: createdAt,
        ),
      ),
    );
  }

  void _updateNote() {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<NotesBloc>(context),
        child: UpdateBottomSheetWidget(
          titleController: titleController,
          contentController: contentController,
          createdAt: createdAt,
          id: id ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.listOfNotes != current.listOfNotes,
      listener: (context, state) {
        if (state.status == NoteStateStatus.failure) {
          print('error aavi chhe : .... ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went wrong"),
            ),
          );
        }
      },
      child: Scaffold(
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
            if (state.status == NoteStateStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == NoteStateStatus.listLoaded &&
                state.listOfNotes.isEmpty) {
              return const Center(
                child: Text(' Start creating Notes by clicking add button. '),
              );
            } else if (state.listOfNotes.isNotEmpty &&
                state.status == NoteStateStatus.listLoaded) {
              return ListView.builder(
                itemCount: state.listOfNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.purple.shade100,
                    child: ListTile(
                      title: Text(state.listOfNotes[index].title),
                      subtitle: Text(state.listOfNotes[index].content),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  titleController.text =
                                      state.listOfNotes[index].title;
                                  contentController.text =
                                      state.listOfNotes[index].content;
                                  context.read<NotesBloc>().add(
                                      GetNoteByIDEvent(
                                          state.listOfNotes[index].noteId!));
                                  _updateNote();
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                              onPressed: () {
                                context.read<NotesBloc>().add(
                                      DeleteNoteEvent(
                                          state.listOfNotes[index].noteId!),
                                    );
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple.shade200,
          onPressed: () {
            _addNote();
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
