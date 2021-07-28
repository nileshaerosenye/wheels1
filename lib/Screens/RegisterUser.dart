import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels1/Models/UserModel.dart';
import 'package:wheels1/Screens/LoadingScreen.dart';
import 'package:wheels1/Screens/LoginUser.dart';
import 'package:wheels1/Services/Authentication.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  static const routeName = "/Register";

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _userName, _userEmail, _userPassword;
  String _error="";
  final _authentication = Authentication();
  bool _isLoading = false;

  Future<void> _registerUser() async {

    if ( _formKey.currentState!.validate() ) {
      _formKey.currentState!.save();
      print("Registering user: " + _userEmail + " with password: " + _userPassword);
      setState(() {
        _isLoading = true;
      });

      UserModel _userModel = (await _authentication.RegisterUser( _userEmail, _userPassword, _userName ))!;

      if ( _userModel.user != null ) {
        User _user = _userModel.user!;
        await _user.updateDisplayName( _userName );
        print("Redirect to Welcome page");
        Navigator.of(context).pushReplacementNamed("/Welcome");
      }
      else {
        setState(() {
          _error = _userModel.error!;
          print("ERROR is: " + _error);
          _isLoading = false;
        });
        print("Stay here as register failed");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingScreen() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Register User"),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              print("Add user pressed");
              Navigator.of(context).pushReplacementNamed(LoginUser.routeName);
            },
            icon: Icon(Icons.person_add, color: Colors.white,),
            label: Text("Login", style: TextStyle(color: Colors.white),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  showAlert(),

                  TextFormField(
                    decoration: InputDecoration( labelText: "Name"),
                    keyboardType: TextInputType.name,
                    validator: ( value ) {
                      if ( value!.isEmpty ) {
                        return "Enter name";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      this._userName = value!;
                    },
                  ),

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
                      onPressed: _registerUser,
                      child: Text("Register")
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
        // padding: EdgeInsets.all(4.0),
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
