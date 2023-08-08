import 'exercise.dart';

class ExerciseJournalEntry{
  int id;
  DateTime time;
  int value;
  Exercise exercise;

  ExerciseJournalEntry({required this.id, required this.time, required this.value, required this.exercise});
}
