import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Task {

  final DateTime createTime;
  final String description;


  bool isDone;

  Task(
      {@required this.createTime,
      @required this.description,
      this.isDone = false});

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : createTime = convertTimeStampToDateTime(snapshot['createTime']),
        description = snapshot['description'],
        isDone = snapshot['isDone'];

  Task.fromMap(Map<String, dynamic> map)
      : createTime = map['createTime'],
        description = map['description'],
        isDone = map['isDone'];

  Map<String, dynamic> toMap() =>
      {'createTime': createTime, 'description': description, 'isDone': isDone};

  static Future<Task> getTask() {
    return null;
  }

  static List<Task> createListOfTasks(List<Map> maps) {
    List<Task> tasks = [];
    maps ??
        maps.forEach((Map _map) {
          tasks.add(Task.fromMap(_map));
        });
    return tasks;
  }

  static DateTime convertTimeStampToDateTime(Timestamp timestamp){
    return timestamp.toDate();
  }

  static List<Task> createListOfTasksFromListOfSnapshots(
      List<DocumentSnapshot> snapshots) {
    List<Task> tasks = [];
    snapshots.forEach((DocumentSnapshot snapshot) {
      tasks.add(Task.fromSnapshot(snapshot));
    });
    return tasks;
  }
}
