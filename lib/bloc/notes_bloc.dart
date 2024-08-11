import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_notes/model/notes_model.dart';
import 'package:sql_notes/sql-helper/sql_helper.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(const NotesState(status: NoteStateStatus.initial)) {
    on<NotesEvent>((event, emit) {});
    on<GetListOfNotesEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: NoteStateStatus.loading));
        final listOfNotes = await SQLHelper.getListOfNotes();
        emit(state.copyWith(
            status: NoteStateStatus.loaded, listOfNotes: listOfNotes));
      } catch (e) {
        emit(state.copyWith(status: NoteStateStatus.error));
      }
    });
    on<CreateNewNoteEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final res = await SQLHelper.createNewNote(Notes(
              title: event.note.title,
              content: event.note.content,
              noteId: event.note.noteId,
              createdAt: event.note.createdAt));
          if (res > 0) {
            emit(state.copyWith(status: NoteStateStatus.loaded));
            add(const GetListOfNotesEvent());
          }
        } catch (e) {
          emit(state.copyWith(status: NoteStateStatus.error));
        }
      },
    );
    on<UpdateNoteEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final res = await SQLHelper.updateNote(Notes(
              title: event.note.title,
              content: event.note.content,
              noteId: event.note.noteId,
              createdAt: event.note.createdAt));
          if (res > 0) {
            emit(state.copyWith(status: NoteStateStatus.loaded));
            add(const GetListOfNotesEvent());
          }
        } catch (e) {
          emit(state.copyWith(status: NoteStateStatus.error));
        }
      },
    );
    on<DeleteNoteEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final res = await SQLHelper.deleteNote(event.id);
          if (res > 0) {
            emit(state.copyWith(status: NoteStateStatus.loading));
            emit(state.copyWith(status: NoteStateStatus.loaded));
            add(const GetListOfNotesEvent());
          }
        } catch (e) {
          emit(state.copyWith(status: NoteStateStatus.error));
        }
      },
    );
    on<GetNoteByIDEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final note = await SQLHelper.getNoteById(event.id);
          emit(state.copyWith(status: NoteStateStatus.loaded, note: note));
        } catch (e) {
          emit(state.copyWith(status: NoteStateStatus.error));
        }
      },
    );
  }
}
