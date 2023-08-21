class Exercise{
  int? id;
  String name;

  Exercise({this.id, required this.name});

  Map<String, String> toMap(){
    Map<String, String> map = {};
    map['name'] = name;
    if(id != null) map['id'] = id.toString();
    return map;
  }

  void fromMap(Map<String, String> data){
    id = int.tryParse(data['id'] ?? 'x');
    name = data['name'] ?? '';
  }
}
