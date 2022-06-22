import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../models/recording.dart';
import '../../../../models/recording_group.dart';
part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  FilesCubit() : super(FilesInitial()) {
    getFiles();
  }

  Future<void> getFiles() async {
    List<Recording> recordings = [];
    emit(FilesLoading());
    PermissionStatus permissionGranted = await Permission.storage.request();
    if (permissionGranted == PermissionStatus.granted) {
      // On liste les fichiers
      final List<FileSystemEntity> files =
          Directory('/storage/emulated/0/comeonaudio/audio').listSync();

      for (final file in files) {
        final AudioPlayer controller = AudioPlayer();

        // on s'assure bien que le fichier n'est pas nul pour eviter les erreurs
        Duration? fileDuration = await controller.setFilePath(file.path);
        if (fileDuration != null) {
          recordings.add(Recording(file: file, fileDuration: fileDuration));
        }
      }

      //On emite au cubit ce nouvelle évent pour changer le state et donc ajouter le fichier a la liste des enregistrements
      emit(FilesLoaded(recordings: recordings));
    } else {
      emit(FilesPermisionNotGranted());
    }
  }
}
