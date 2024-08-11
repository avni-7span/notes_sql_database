part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();
}

class CreateNewNoteEvent extends NotesEvent {
  const CreateNewNoteEvent(this.note);
  final Notes note;
  @override
  List<Object?> get props => [];
}

class UpdateNoteEvent extends NotesEvent {
  const UpdateNoteEvent(this.note);
  final Notes note;
  @override
  List<Object?> get props => [];
}

class DeleteNoteEvent extends NotesEvent {
  const DeleteNoteEvent(this.id);
  final int id;
  @override
  List<Object?> get props => [];
}

class GetNoteByIDEvent extends NotesEvent {
  const GetNoteByIDEvent(this.id);
  final int id;
  @override
  List<Object?> get props => [];
}

class GetListOfNotesEvent extends NotesEvent {
  const GetListOfNotesEvent();
  @override
  List<Object?> get props => [];
}
