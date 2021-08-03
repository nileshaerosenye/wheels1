import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wheels1/Models/UserModel.dart';

class Authentication {


  final _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> RegisterUser( String _userEmail, String _userPassword, String _userName ) async {

    final _userModel = UserModel();

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
          email: _userEmail, password: _userPassword);
        print("User created: " + userCredential.user.toString());
        _userModel.user = userCredential.user!;

        _firebaseAuth.currentUser!.updateDisplayName(_userName);

        return _userModel;
    }
    on FirebaseAuthException catch ( e ) {
      _userModel.error = e.code;
      return _userModel;
    }

  }

  Future<UserModel?> LoginUser( String _userEmail, String _userPassword ) async {

    final _userModel = UserModel();
    print("Trying to login here");

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: _userEmail, password: _userPassword);
      print("User created: " + userCredential.user.toString());
      _userModel.user = userCredential.user!;
      return _userModel;
    }
    on FirebaseAuthException catch ( e ) {
      _userModel.error = e.code;
      return _userModel;
    }

  }

  Future<UserModel> ForgotPassword ( String _userEmail ) async {

    final _userModel = UserModel();
    print("Trying to reset user password");

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: _userEmail);
      return _userModel;
    }
    on FirebaseAuthException catch ( e ) {
      _userModel.error = e.code;
      return _userModel;
    }

  }

  void LogoutUser() {

    _firebaseAuth.signOut();

  }


}