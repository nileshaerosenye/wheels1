import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels1/Models/UserModel.dart';
import 'package:wheels1/Screens/LoadingScreen.dart';
import 'package:wheels1/Screens/RegisterUser.dart';
import 'package:wheels1/Services/Authentication.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  static const routeName = "/Login";

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _userEmail, _userPassword;
  String _error="";
  final _authentication = Authentication();
  late UserModel _userModel;
  bool _isLoading = false;

  Future<void> _loginUser() async {

    if ( _formKey.currentState!.validate() ) {
      _formKey.currentState!.save();
      print("Logging-in user: " + _userEmail + " with password: " + _userPassword);
      setState(() {
        _isLoading = true;
      });

      _userModel = (await _authentication.LoginUser( _userEmail, _userPassword ))!;
      if ( _userModel.user != null ) {
        print("Redirect to new page");
        Navigator.of(context).pushReplacementNamed("/Welcome");
      }
      else {
        setState(() {
          _error = _userModel.error!;
          _isLoading = false;
        });
        print("Stay here as login failed");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingScreen() : Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Login"),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              print("Add user pressed");
              Navigator.of(context).pushReplacementNamed(RegisterUser.routeName);
            },
            icon: Icon(Icons.person_add, color: Colors.white,),
            label: Text("Register", style: TextStyle(color: Colors.white),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  showAlert(),

                  TextFormField(
                    decoration: InputDecoration( labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: ( value ) {
                      if ( value!.isEmpty ) {
                        return "Enter email address";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      this._userEmail = value!;
                    },
                  ),

                  TextFormField(
                    decoration: InputDecoration( labelText: "Password"),
                    obscureText: true,
                    validator: ( value ) {
                      if ( value!.length<4 ) {
                        return "Password length should be 4 or more";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      this._userPassword = value!;
                    },
                  ),

                  ElevatedButton(
                      onPressed: _loginUser,
                      child: Text("Login")
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget showAlert() {

    if ( _error.isNotEmpty ) {
      return Container(
        color: Colors.lime,
        // padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(_error),
            IconButton(
                icon: Icon( Icons.close),
                onPressed: () {
                  setState(() {
                    _error="";
                  });
                }
                ),
          ],
        ),
      );
    }
    else {
      return Container(
      );
    }

  }

}
