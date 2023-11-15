class ExerciseOrder{
  int id;
  int order;
  int exercise;

  static const String tableString = 
  '''
    create table exerciseorder if not exists(
      workout INTEGER,
      order INTEGER,
      exercise INTEGER 
    );
  ''';

  ExerciseOrder({required this.id, required this.order, required this.exercise});

  static Map<String, dynamic> toMap(ExerciseOrder exercise){
    Map<String, dynamic> map = {};
    return map;
  }

  static ExerciseOrder fromMap(Map<String, dynamic> data){
    int id = 0;
    int order = 0;
    int exercise = 0;
    return ExerciseOrder(id: id, order: order, exercise: exercise);
  }
}
