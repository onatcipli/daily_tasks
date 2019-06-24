import 'package:daily_tasks/models/task.dart';
import 'package:flutter/material.dart';

class BuildTask extends StatefulWidget {
  Task task;

  BuildTask({@required this.task}) : assert(task != null);

  @override
  _BuildTaskState createState() => _BuildTaskState();
}

class _BuildTaskState extends State<BuildTask> {
  Task get task => widget.task;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: task.isDone == true ? Colors.black45 : Colors.white,
      child: CheckboxListTile(
        title: Text(
          task.description,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        value: task.isDone,
        onChanged: (bool value) {
          setState(() {
            task.isDone = !task.isDone;
          });
        },
      ),
    );
  }
}
