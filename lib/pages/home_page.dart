import 'package:daily_tasks/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  FirebaseUser firebaseUser;

  HomePage({@required this.firebaseUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser get firebaseUser => widget.firebaseUser;

  void navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(firebaseUser.email),
                  IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((_) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Signed Out Succesfully!'),
                          ));
                          navigateToLoginPage();
                        });
                      })
                ],
              ),
        ),
      ),
      body: Container(),
    );
  }
}
