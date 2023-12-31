class ExerciseLog{
  DateTime timestamp;
  int value;
  int exercise;

  ExerciseLog({required this.timestamp, required this.value, required this.exercise});
  
  static const String tableString = 
  '''
    create table exerciselog(
      timestamp INTEGER,
      logdate varchar(10),
      logtime varcahr(5),
      exercise INTEGER,
      value int,
      primary key (timestamp, exercise)
    );
  ''';

  static Map<String, dynamic> toMap(ExerciseLog log){
    Map<String, dynamic> map = {};
    map['timestamp'] = log.timestamp.millisecondsSinceEpoch;
    map['logdate'] = ExerciseLog.toDateString(log.timestamp);
    map['logtime'] = ExerciseLog.toTimeString(log.timestamp);
    map['exercise'] = log.exercise;
    map['value'] = log.value;
    return map;
  }

  static ExerciseLog fromMap(Map<String, dynamic> data){
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp'] ?? 0); 
    int value = data['value'] ?? 0;
    int exercise = data['exercise'] ?? 0; 
    return ExerciseLog(timestamp: timestamp, value: value, exercise: exercise);
  }

  static String toDateString(DateTime stamp){
    String year = stamp.year.toString().padLeft(4, '0');
    String month = stamp.month.toString().padLeft(2, '0');
    String day = stamp.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
  static String toTimeString(DateTime stamp){
    String hour = stamp.hour.toString().padLeft(2, '0');
    String minute = stamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  //static DateTime _toTimeStamp(String date, String time){
  //  List<String> dateSplit = date.split('-');
  //  List<String> timeSplit = time.split(':');

  //  int year = 1;
  //  int month = 1;
  //  int day = 1;
  //  int hour = 1;
  //  int minute = 1;

  //  if(dateSplit.length == 3){
  //    year =  int.tryParse(dateSplit[0]) ?? 1;
  //    month = int.tryParse(dateSplit[1]) ?? 1;
  //    day =   int.tryParse(dateSplit[2]) ?? 1;
  //  }
  //  if(timeSplit.length == 2){
  //    hour =    int.tryParse(timeSplit[0]) ?? 1;
  //    minute =  int.tryParse(timeSplit[1]) ?? 1;
  //  }

  //  return DateTime(year, month, day, hour, minute);
  //}

}
