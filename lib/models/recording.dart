import 'dart:io';

import 'package:equatable/equatable.dart';

// modèle fournis par une explication de code sur stack overflow

// ignore: must_be_immutable
class Recording extends Equatable {
  final FileSystemEntity file;

  final Duration fileDuration;
  late DateTime dateTime;

  Recording({
    required this.file,
    required this.fileDuration,
  }) {
    final millisecond = int.parse(file.path.split('/').last.split('.').first);
    dateTime = DateTime.fromMillisecondsSinceEpoch(millisecond);
  }
  // On retourne les différentes informations a affiché de chaque enregistrement
  @override
  List<Object?> get props => [file, fileDuration];

  @override
  bool? get stringify => true;
}
