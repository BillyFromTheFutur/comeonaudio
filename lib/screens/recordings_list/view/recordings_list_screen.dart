import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/recording_group.dart';
import '../cubit/files/files_cubit.dart';

class RecordingsListScreen extends StatefulWidget {
  const RecordingsListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecordingsListScreenState createState() => _RecordingsListScreenState();
}

class _RecordingsListScreenState extends State<RecordingsListScreen> {
  final AudioPlayer controller = AudioPlayer();
  String played = '';

  // state manager pour changer la couleur lorsqu'un element de la liste est lu mais ne marche pas ...
  void _changevalue(String newvalue) {
    setState(() {
      played = newvalue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FilesCubit, FilesState>(
        builder: (context, state) {
          // Si les fichier sont déja charger
          if (state is FilesLoaded) {
            String _durationString(Duration duration) {
              String twoDigits(int n) => n.toString().padLeft(2, "0");
              String twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
              String twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));
              return "$twoDigitMinutes:$twoDigitSeconds";
            }

            // Auquel cas on créer le widget pour les afficher et ensuite on l'appel dans un .map
            Random random = Random();
            Widget buildGroup(RecordingGroup rGroup) {
              final List uniqueList = Set.from(rGroup.recordings).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...rGroup.recordings
                      .map(
                        (groupRecording) => Padding(
                          // Clés avec un random pour son unicité
                          key: Key(groupRecording.fileDuration.toString() +
                              random.nextInt(100000).toString()),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                              title: Text(
                                "${uniqueList.length - uniqueList.indexOf(groupRecording)}.mp3",
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w400),
                              ),
                              trailing: Text(
                                _durationString(groupRecording.fileDuration),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onTap: () async {
                                await controller.stop();
                                await controller
                                    .setFilePath(groupRecording.file.path);
                                await controller.play();
                                await controller.stop();
                              }),
                        ),
                      )
                      .toList()
                ],
              );
            }

            if (state.sortedRecordings.isNotEmpty) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: state.sortedRecordings
                          // On map a travers les enregistrements
                          .map((RecordingGroup recordingGroup) {
                        if (recordingGroup.recordings.isNotEmpty) {
                          // et on appel le widget pour les afficher
                          return buildGroup(recordingGroup);
                        } else {
                          return const SizedBox(
                            child: Text(
                                "L'application n'as pas réussis a charger les enregistrements"),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Aucun enregistrement'),
              );
            }
          } // Ecran de chargement
          else if (state is FilesLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          } // Ecran en cas d'erreur
          else {
            return const Center(
              child: Text('Erreur lors du chargement'),
            );
          }
        },
      ),
    );
  }

  // Fonction pour arreter la lecture
  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
