import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:wheels1/Models/UserModel.dart';
import 'package:wheels1/Services/Authentication.dart';

import 'LoginUser.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  static const routeName = "/ForgotPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _userEmail;
  final _authentication = Authentication();
  late UserModel _userModel;

  Future<void> _forgotPassword() async {

    if ( _formKey.currentState!.validate() ) {
      _formKey.currentState!.save();
      print("Resetting password of user: " + _userEmail );

      _userModel = (await _authentication.ForgotPassword(_userEmail));
      if ( _userModel.error != null ) {

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

      }
      else {
        showToast("Email sent to reset password",
          context: context,
          animation: StyledToastAnimation.scale,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          duration: Duration(seconds: 15),
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

      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(70,60,0, 1),
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

                  SizedBox(height: 10.0,),

                  ElevatedButton(
                      onPressed: _forgotPassword,
                      child: Text("Email password reset link", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white38)
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
