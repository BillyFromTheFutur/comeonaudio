part of 'files_cubit.dart';

enum LoadStatus {
  initial,
  loading,
  loaded,
}

// Logique de state placé ici
abstract class FilesState {}

class FilesInitial extends FilesState {}

class FilesLoading extends FilesState {}

//Dans File Loaded on va chercher placer la logique pour charger les fichier pour éviter de
//de surcharger la view qui rendrait le code difficile a lire
class FilesLoaded extends FilesState {
  final List<Recording> recordings;
// La logique qui suit a été inspiré de la documentation
  FilesLoaded({required this.recordings});

  List<RecordingGroup> get sortedRecordings {
    List<RecordingGroup> recordingGroups = [];

    final recordingsList = recordings;

    for (var i = 0; i < recordingsList.length; i++) {
      final selectedRecording = recordingsList[i];

      bool recordingAdded = false;

      for (var j = 0; j < recordingGroups.length; j++) {
        if (recordingGroups[j].recordings.any((recording) =>
            recording.dateTime.difference(selectedRecording.dateTime).inDays ==
            0)) {
          recordingGroups[j].addRecording(selectedRecording);
          recordingAdded = true;
        }
      }

      if (!recordingAdded) {
        recordingGroups.add(RecordingGroup.initial(selectedRecording));
      }
    }

    ///Tri les enregistrements
    for (var group in recordingGroups) {
      group.recordings.sort((a, b) {
        return b.dateTime.compareTo(a.dateTime);
      });
    }

    ///Trie par groupe en cas ou plusieurs groupe disponible
    ///nottament en fonction les jours
    recordingGroups.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    return recordingGroups;
  }
}

class FilesPermisionNotGranted extends FilesState {}
