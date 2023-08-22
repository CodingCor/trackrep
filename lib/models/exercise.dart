class Exercise{
  int? id;
  String name;

  Exercise({this.id, required this.name});

  static Map<String, dynamic> toMap(Exercise exercise){
    Map<String, dynamic> map = {};
    map['name'] = exercise.name;
    if(exercise.id != null) map['id'] = exercise.id;
    return map;
  }

  static Exercise fromMap(Map<String, dynamic> data){
    int? id = data['id'];
    String name = data['name'] ?? '';
    return Exercise(id: id, name: name);
  }
}
