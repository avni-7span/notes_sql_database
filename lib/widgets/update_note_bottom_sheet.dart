import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_notes/bloc/notes_bloc.dart';
import 'package:sql_notes/model/notes_model.dart';

class UpdateBottomSheetWidget extends StatelessWidget {
  const UpdateBottomSheetWidget(
      {super.key,
      required this.titleController,
      required this.contentController,
      required this.createdAt,
      required this.id});

  final TextEditingController titleController;
  final TextEditingController contentController;
  final String createdAt;
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Container(
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
                          UpdateNoteEvent(
                            Notes(
                                noteId: state.note?.noteId,
                                title: titleController.text,
                                content: contentController.text,
                                createdAt: createdAt),
                          ),
                        );
                    titleController.clear();
                    contentController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'))
            ],
          ),
        );
      },
    );
  }
}
