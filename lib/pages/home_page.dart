import 'package:daily_tasks/pages/login_page.dart';
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
  FirebaseUser get firebaseUser => widget.firebaseUser;

  GoogleSignInAccount get googleUser => widget.googleSignInAccount;

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
          builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      firebaseUser == null
                          ? googleUser.email
                          : firebaseUser.email,
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
                            navigateToLoginPage();
                          });
                        }
                        if (googleUser != null) {
                          GoogleSignIn googleSignIn = GoogleSignIn();
                          googleSignIn.signOut().then((user) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Signed Out Succesfully!'),
                            ));
                            navigateToLoginPage();
                          });
                        }
                      })
                ],
              ),
        ),
      ),
      body: Container(),
    );
  }
}
