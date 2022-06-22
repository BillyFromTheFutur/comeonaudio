import 'package:equatable/equatable.dart';

import 'recording.dart';

// modèle fournis par une explication de code sur stack overflow
class RecordingGroup extends Equatable {
  final DateTime date;
  //On créer la liste dans laquel on va stocker les enregistrements
  final List<Recording> recordings;

  const RecordingGroup({required this.date, required this.recordings});

  factory RecordingGroup.initial(Recording recording) {
    return RecordingGroup(date: recording.dateTime, recordings: [recording]);
  }

  addRecording(Recording recording) {
    recordings.add(recording);
  }

  // permet de retourner les props de l'objet
  @override
  List<Object?> get props => [date, recordings];

  @override
  bool? get stringify => true;

  RecordingGroup copyWith({
    DateTime? date,
    List<Recording>? recordings,
  }) {
    return RecordingGroup(
      date: date ?? this.date,
      recordings: recordings ?? this.recordings,
    );
  }
}
