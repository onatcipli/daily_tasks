import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_tasks/models/task.dart';

class User {
  String uid;

  List<Task> tasks;

  User({this.uid, this.tasks});

  User.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot['uid'],
        tasks = snapshot['tasks'] ??
            Task.createListOfTasks(List.from(snapshot['tasks']));

  User.fromMap(Map map)
      : uid = map['uid'],
        tasks = map['tasks'] ?? Task.createListOfTasks(List.from(map['tasks']));

  Map<String, dynamic> toMap() => {'tasks': tasks};
}
