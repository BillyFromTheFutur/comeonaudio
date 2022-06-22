import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
part 'record_state.dart';

// Ici on place toute la logique que l'on va utiliser dans les fonctions basique du composant
class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());

  final Record _audioRecorder = Record();

  void startRecording() async {
    // On liste les permission nécéssaire pour utiliser l'appli
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (permissionsGranted) {
      Directory appFolder = Directory('/storage/emulated/0/comeonaudio/audio');
      bool appFolderExists = await appFolder.exists();
      if (!appFolderExists) {
        final created = await appFolder.create(recursive: true);
        print(created.path);
      }
      // le code au dessus permet la vérification et en cas d'échec la demande des permissions
      final filepath =
          '/storage/emulated/0/comeonaudio/audio/${DateTime.now().millisecondsSinceEpoch}.mp3';
      print(filepath);

      // on lance l'enregistrement
      await _audioRecorder.start(path: filepath);

      // la logique des cubits nous obliges a emmetres des évennements pour changer le state de l'application
      emit(RecordOn());
    } else {
      print('Permissions not granted');
    }
  }

  void stopRecording() async {
    // stop et store l'emplacement du fichier dans path
    String? path = await _audioRecorder.stop();

    // la logique des cubits nous obliges a emmetres des évennements pour changer le state de l'application
    emit(RecordStopped());
    print('Output path $path');
  }
}
