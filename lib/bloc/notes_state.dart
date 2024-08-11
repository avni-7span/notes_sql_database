part of 'notes_bloc.dart';

enum NoteStateStatus { initial, loaded, error, loading, success }

class NotesState extends Equatable {
  const NotesState(
      {this.status = NoteStateStatus.initial, this.note, this.listOfNotes});

  final NoteStateStatus status;
  final Notes? note;
  final List<Notes>? listOfNotes;

  @override
  List<Object?> get props => [status, note, listOfNotes];

  NotesState copyWith({
    NoteStateStatus? status,
    Notes? note,
    List<Notes>? listOfNotes,
  }) {
    return NotesState(
      status: status ?? this.status,
      note: note ?? this.note,
      listOfNotes: listOfNotes ?? this.listOfNotes,
    );
  }
}
