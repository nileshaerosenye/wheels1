import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

  final CollectionReference stocksCollection = FirebaseFirestore.instance.collection('UserStocks');




}