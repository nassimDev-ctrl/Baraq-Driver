abstract class TripNoteState {}

class TripNoteInitial extends TripNoteState {}

class TripNoteLoading extends TripNoteState {}

class TripNoteSuccess extends TripNoteState {
  final String note;
  TripNoteSuccess(this.note);
}

class TripNoteFailure extends TripNoteState {
  final String errMessage;
  TripNoteFailure(this.errMessage);
}