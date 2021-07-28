import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wheels1/Screens/LoginUser.dart';
import 'package:wheels1/Screens/RegisterUser.dart';
import 'package:wheels1/Screens/Welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginUser(),
      routes: {
        RegisterUser.routeName: (ctx) => RegisterUser(),
        LoginUser.routeName: (ctx) => LoginUser(),
        Welcome.routeName: (ctx) => Welcome(),
      },

    );
  }
}
