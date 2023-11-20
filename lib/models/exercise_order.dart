class ExerciseOrder{
  int workout;
  double order;
  int exercise;

  static const String tableString = 
  '''
    create table if not exists exerciseorder(
      workout INTEGER,
      orderNumber REAL,
      exercise INTEGER 
    );
  ''';

  ExerciseOrder({required this.workout, required this.order, required this.exercise});

  static Map<String, dynamic> toMap(ExerciseOrder exercise){
    Map<String, dynamic> map = {};
    map['workout'] = exercise.workout;
    map['orderNumber'] = exercise.order;
    map['exercise'] = exercise.exercise;
    return map;
  }

  static ExerciseOrder fromMap(Map<String, dynamic> data){
    int workout = 0;
    double order = 0;
    int exercise = 0;
    workout = data['workout'] ?? 0;
    order = data['orderNumber'] ?? 0.0;
    exercise = data['exercise'] ?? 0;
    return ExerciseOrder(workout: workout, order: order, exercise: exercise);
  }
}
