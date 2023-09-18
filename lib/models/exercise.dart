class Exercise{
  int? id;
  String name;

  ///types:
  /// R ... Rep based exercise
  /// T ... Time based exercise
  String type;

  static const String defaultType = 'R';
  static const String timedEventType = 'T';

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
