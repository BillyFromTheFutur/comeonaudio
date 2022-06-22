part of 'record_cubit.dart';

//on creer notre classe abstraites qui va contenir les states
abstract class RecordState {}

// et on  créer les classes héritants des propriété de RecordState et corréspondant a différent événnement
class RecordInitial extends RecordState {}

class RecordOn extends RecordState {}

class RecordStopped extends RecordState {}
