part of 'notes_bloc.dart';

enum NoteStateStatus {
  initial,
  loaded,
  failure,
  loading,
  loadingListOfNotes,
  listLoaded,
  updateSuccess,
  deleteSuccess,
}

class NotesState extends Equatable {
  const NotesState({
    this.status = NoteStateStatus.initial,
    this.note,
    this.listOfNotes = const [],
    this.error = '',
  });

  final NoteStateStatus status;
  final Notes? note;
  final List<Notes> listOfNotes;
  final String error;

  @override
  List<Object?> get props => [status, listOfNotes, note, error];

  NotesState copyWith({
    NoteStateStatus? status,
    Notes? note,
    List<Notes>? listOfNotes,
    String? error,
  }) {
    return NotesState(
      status: status ?? this.status,
      note: note ?? this.note,
      listOfNotes: listOfNotes ?? this.listOfNotes,
      error: error ?? this.error,
    );
  }
}
