class Exercise{
  int? id;
  String name;

  ///types:
  /// R ... Rep based exercise
  /// T ... Time based exercise
  /// P ... Rest time (Pause) between exercises
  String type;

  static const String tableName = 'exercise';
  static const String tableString = 
  '''
    create table exercise (
      id INTEGER primary key ASC,
      type varchar(1),
      name varchar(60) unique
    );
  ''';

  static const String defaultType = 'R';
  static const String timedEventType = 'T';
  static const String restTime = 'P';

  Exercise({this.id, required this.name, this.type = defaultType});

  static Map<String, dynamic> toMap(Exercise exercise){
    Map<String, dynamic> map = {};
    map['name'] = exercise.name;
    map['type'] = exercise.type;
    if(exercise.id != null) map['id'] = exercise.id;
    return map;
  }

  static Exercise fromMap(Map<String, dynamic> data){
    int? id = data['id'];
    String name = data['name'] ?? '';
    String type = data['type'] ?? defaultType;
    return Exercise(id: id, name: name, type: type);
  }
}
