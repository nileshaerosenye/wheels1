import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wheels1/Models/UserModel.dart';
import 'package:wheels1/Screens/BottomBar.dart';
import 'package:wheels1/Screens/ForgotPassword.dart';
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

      _userModel = (await _authentication.LoginUser( _userEmail, _userPassword ))!;
      if ( _userModel.user != null ) {
        print("Redirect to new page");
        Navigator.of(context).pushReplacementNamed("/Welcome");
      }
      else {

        // display login errors
        showToast(_userModel.error,
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red[100],
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );

        print("Stay here as login failed");
      }
    }

  }

  void _handleMenuItems( BuildContext context, item ) {
    switch (item) {
      case 0:
        Navigator.of(context).pushReplacementNamed(RegisterUser.routeName);
        break;
      case 1:
        print("Handle Settings page");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(70,60,0, 1),
        title: Text("X-Opt"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Register')),
              PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
            onSelected: (item) => { _handleMenuItems( context, item ) },
          ),
        ],
      ),

      bottomNavigationBar: BottomBar(),


      body: Container(
        // color: Colors.brown,
        padding: EdgeInsets.all(10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

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

                  SizedBox(height: 10.0,),

                  ElevatedButton(

                      onPressed: _loginUser,
                      child: Text("      Login      ", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white38)
                  ),

                  Divider(
                      color: Colors.black,
                  ),

                  SizedBox(height: 10.0,),

                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                      },
                      child: Text("Reset Password", style: TextStyle(decoration: TextDecoration.underline),),
                  ),

                  TextButton(
                    onPressed: () { Navigator.of(context).pushReplacementNamed("/Register"); },
                    child: Text("Sign Up", style: TextStyle(decoration: TextDecoration.underline)),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
