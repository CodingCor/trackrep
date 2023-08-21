class ExerciseLog{
  DateTime timestamp;
  int value;
  int exercise;

  ExerciseLog({required this.timestamp, required this.value, required this.exercise});

  Map<String, String> toMap(){
    Map<String, String> map = {};
    map['logdate'] = _toDateString(timestamp);
    map['logdate'] = _toTimeString(timestamp);
    map['exercise'] = exercise.toString();
    map['value'] = value.toString();
    return map;
  }

  void fromMap(Map<String, String> data){
    timestamp = _toTimeStamp(data['logdate'] ?? '', data['time'] ?? ''); 
    value = int.tryParse(data['value'] ?? '') ?? 0;
    exercise = int.tryParse(data['exercise'] ?? '') ?? 0; 
  }

  String _toDateString(DateTime stamp){
    String year = stamp.year.toString().padLeft(4, '0');
    String month = stamp.month.toString().padLeft(2, '0');
    String day = stamp.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
  String _toTimeString(DateTime stamp){
    String hour = stamp.hour.toString().padLeft(2, '0');
    String minute = stamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  DateTime _toTimeStamp(String date, String time){
    List<String> dateSplit = date.split('-');
    List<String> timeSplit = time.split(':');

    int year = 1;
    int month = 1;
    int day = 1;
    int hour = 1;
    int minute = 1;

    if(dateSplit.length == 3){
      year =  int.tryParse(dateSplit[0]) ?? 1;
      month = int.tryParse(dateSplit[1]) ?? 1;
      day =   int.tryParse(dateSplit[2]) ?? 1;
    }
    if(timeSplit.length == 2){
      hour =    int.tryParse(timeSplit[0]) ?? 1;
      minute =  int.tryParse(timeSplit[1]) ?? 1;
    }

    return DateTime(year, month, day, hour, minute);
  }

}
