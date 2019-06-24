import 'package:daily_tasks/models/task.dart';
import 'package:daily_tasks/models/user_model.dart';
import 'package:daily_tasks/pages/login_page.dart';
import 'package:daily_tasks/widgets/build_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  FirebaseUser firebaseUser;
  GoogleSignInAccount googleSignInAccount;

  HomePage({this.firebaseUser, this.googleSignInAccount});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> currentTasks = [];

  User currentUser;

  Task newTask;

  FirebaseUser get firebaseUser => widget.firebaseUser;

  GoogleSignInAccount get googleUser => widget.googleSignInAccount;

  void navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  Task task = Task(
      createTime: DateTime.now(), description: 'my first task description');

  @override
  void initState() {
    currentTasks.add(task);
    currentUser = new User(
        uid: firebaseUser == null ? googleUser.id : firebaseUser.uid,
        tasks: currentTasks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  firebaseUser == null ? googleUser.email : firebaseUser.email,
                  overflow: TextOverflow.fade,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    if (firebaseUser != null) {
                      FirebaseAuth.instance.signOut().then((_) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Signed Out Succesfully!'),
                        ));
//                              navigateToLoginPage();
                      });
                    }
                    if (googleUser != null) {
                      GoogleSignIn googleSignIn = GoogleSignIn();
                      googleSignIn.signOut().then((user) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Signed Out Succesfully!'),
                        ));
//                              navigateToLoginPage();
                      });
                    }
                  })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_circle_outline),
            elevation: 10.0,
            highlightElevation: 20.0,
            onPressed: () async {
              String description = '';
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheet(
                      builder: (context) => Column(
                            children: <Widget>[
                              TextField(
                                onChanged: (text) {
                                  description = text;
                                },
                              ),
                              OutlineButton(
                                  child: Text('Add today task'),
                                  onPressed: () {
                                    newTask = Task(
                                        createTime: DateTime.now(),
                                        description: description);
                                    currentUser.tasks.add(newTask);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Row(
                                      children: <Widget>[
                                        Text('You Add new task '),
                                        FlatButton(
                                          child: Text('Undo'),
                                          onPressed: () {
                                            setState(() {
                                              currentUser.tasks.remove(newTask);
                                            });
                                          },
                                        )
                                      ],
                                    )));
                                  })
                            ],
                          ),
                      onClosing: () {
                        print('bottom modal closing');
                      },
                    );
                  });
            }),
        body: Builder(
          builder: (context) => Column(
                children: currentUser.tasks.map((Task task) {
                  return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          currentUser.tasks.remove(task);
                        });
                      },
                      child: BuildTask(task: task));
                }).toList(),
              ),
        ));
  }
}
