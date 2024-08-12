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
        emit(state.copyWith(status: NoteStateStatus.loadingListOfNotes));
        final listOfNotes = await SQLHelper.getListOfNotes();
        emit(state.copyWith(
            status: NoteStateStatus.listLoaded, listOfNotes: listOfNotes));
      } catch (e) {
        emit(state.copyWith(
            status: NoteStateStatus.failure, error: e.toString()));
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
          } else {
            print('else bloc ma gayu...res<0=0 aavyo');
          }
        } catch (e) {
          emit(state.copyWith(
              status: NoteStateStatus.failure, error: e.toString()));
        }
      },
    );
    on<UpdateNoteEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final res = await SQLHelper.updateNote(Notes(
              noteId: event.note.noteId,
              title: event.note.title,
              content: event.note.content,
              createdAt: event.note.createdAt));
          if (res > 0) {
            emit(state.copyWith(status: NoteStateStatus.updateSuccess));
            add(const GetListOfNotesEvent());
          }
        } catch (e) {
          emit(state.copyWith(
              status: NoteStateStatus.failure, error: e.toString()));
        }
      },
    );
    on<DeleteNoteEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final res = await SQLHelper.deleteNote(event.id);
          if (res > 0) {
            emit(state.copyWith(status: NoteStateStatus.deleteSuccess));
            add(const GetListOfNotesEvent());
          } else {
            print('else bloc ma gayu...res<0=0 aavyo');
          }
        } catch (e) {
          emit(state.copyWith(
              status: NoteStateStatus.failure, error: e.toString()));
        }
      },
    );
    on<GetNoteByIDEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: NoteStateStatus.loading));
          final notes = await SQLHelper.getNoteById(event.id);
          emit(state.copyWith(status: NoteStateStatus.loaded, note: notes));
        } catch (e) {
          emit(state.copyWith(
              status: NoteStateStatus.failure, error: e.toString()));
        }
      },
    );
  }
}
