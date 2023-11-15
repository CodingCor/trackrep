class Workout{
  int? id;
  String name;

  static const String tableString = 
  '''
    create table workout if not exists(
      id INTEGER primary key ASC,
      name varchar(60) unique
    );
  ''';

  Workout({this.id, required this.name});

  static Map<String, dynamic> toMap(Workout exercise){
    Map<String, dynamic> map = {};
    map['name'] = exercise.name;
    if(exercise.id != null) map['id'] = exercise.id;
    return map;
  }

  static Workout fromMap(Map<String, dynamic> data){
    int? id = data['id'];
    String name = data['name'] ?? '';
    return Workout(id: id, name: name);
  }
}
