import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels1/Screens/LoginUser.dart';
import 'package:wheels1/Services/Authentication.dart';

import 'BottomBar.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  static const routeName = "/Welcome";

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  final _authentication = Authentication();
  final _firebaseAuth = FirebaseAuth.instance;
  late User _user;
  String _userName="", _uid="";

  @override
  void initState() {
    print("Initstate function");

    // get the logged-in user details
    _user = _firebaseAuth.currentUser!;
    _uid = _user.uid;
    print("Welcome user: " + _user.displayName! + " UID: " + _uid);
    setState(() {
      _userName = _user.displayName!;
    });

  }

  void _logoutUser() {
    _authentication.LogoutUser();
  }


  @override
  Widget build(BuildContext context) {
    print("Build function. User is : " + _user.displayName!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(70,60,0, 1),
        title: Text("Welcome " + _userName),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white,),
            label: Text("Logout", style: TextStyle(color: Colors.white),),
            onPressed: () {
              print("logout pressed");

              Navigator.of(context).pushReplacementNamed(LoginUser.routeName);
            },
          )
        ],
      ),
      bottomNavigationBar: BottomBar(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Card(
          color: Colors.white70,
          child: Column(
            children: [
              Text("SYM: AAPL"),
              Text("Contracts: 2"),
              Text("Purchased at: 1.67")
            ],
          ),
        ),
      ),
    );
  }
}
