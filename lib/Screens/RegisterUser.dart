import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wheels1/Models/UserModel.dart';
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
  late String _userName, _userFirstName, _userLastName, _userEmail, _userPassword;
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

      // concat first and last names to store in firebase
      _userName = _userFirstName + ", " + _userLastName;
      UserModel _userModel = (await _authentication.RegisterUser( _userEmail, _userPassword, _userName ))!;

      if ( _userModel.user != null ) {
        User _user = _userModel.user!;
        await _user.updateDisplayName( _userName );
        print("Redirect to Welcome page");
        Navigator.of(context).pushReplacementNamed("/Welcome");
      }
      else {
        print("Stay here as register failed");

        // display registration errors
        showToast(_userModel.error,
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red[100],
          textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        );

      }

    }
  }

  void _handleMenuItems( BuildContext context, item ) {
    switch (item) {
      case 0:
        Navigator.of(context).pushReplacementNamed(LoginUser.routeName);
        break;
      case 1:
        print("Handle Settings page");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("X-opt"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Login')),
              PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
            onSelected: (item) => { _handleMenuItems( context, item ) },
          ),
        ],
      ),

      body: Container(
        color: Colors.teal[100],
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  TextFormField(
                    decoration: InputDecoration( labelText: "First Name"),
                    keyboardType: TextInputType.name,
                    validator: ( value ) {
                      if ( value!.isEmpty ) {
                        return "Enter first name";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      this._userFirstName = value!;
                    },
                  ),

                  TextFormField(
                    decoration: InputDecoration( labelText: "Last Name"),
                    keyboardType: TextInputType.name,
                    validator: ( value ) {
                      if ( value!.isEmpty ) {
                        return "Enter last name";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      this._userLastName = value!;
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

                  SizedBox(height: 10.0,),

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

}
