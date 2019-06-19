import 'package:daily_tasks/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseUser _firebaseUser;
  GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  String email = '';
  String password = '';

  bool checkStrings(BuildContext context) {
    if (email == '') {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please Type Email')));
      return false;
    } else if (password == '') {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please Type Password')));
      return false;
    } else {
      return true;
    }
  }

  void signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((FirebaseUser user) {
      _firebaseUser = user;
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(_firebaseUser.email + 'Account created succesfully!')));
      navigateToHomePage();
    }).catchError((e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    });
  }

  void signInWithEmailAndPassword(
      String email, String password, BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((FirebaseUser user) {
      _firebaseUser = user;
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(_firebaseUser.email + 'Signed in succesfully!')));
      navigateToHomePage();
    }).catchError((e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    });
  }

  void navigateToHomePage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  firebaseUser: _firebaseUser,
                )),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) {
        _firebaseUser = user;
        navigateToHomePage();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size currentSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
              child: Container(
                width: currentSize.width - currentSize.width / 7,
                height: currentSize.height - currentSize.height / 3,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: currentSize.width - currentSize.width / 4,
                        child: TextField(
                          onChanged: (String text) {
                            email = text;
                          },
                          decoration: InputDecoration(
                              hintText: 'Type your mail',
                              labelText: 'example@gmail.com'),
                        ),
                      ),
                      Container(
                        width: currentSize.width - currentSize.width / 4,
                        child: TextField(
                          onChanged: (String text) {
                            password = text;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Type your password',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          OutlineButton(
                              onPressed: () {
                                if (checkStrings(context)) {
                                  signUpWithEmailAndPassword(
                                      email, password, context);
                                }
                              },
                              child: Text('Sign-up')),
                          OutlineButton(
                              onPressed: () {
                                if (checkStrings(context)) {
                                  signInWithEmailAndPassword(
                                      email, password, context);
                                }
                              },
                              child: Text('Sign-in')),
                        ],
                      ),
                      OutlineButton(
                          onPressed: () {}, child: Text('Google SignIn')),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
