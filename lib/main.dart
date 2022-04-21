import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    /*
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference users = firestore.collection('users');

    await users.add({
        'full_name': "Gabriel de Matos Hainzenreder",
        'company': "Stokes and Sons",
        'age': 42,
      });

    throw UnimplementedError();
    */

    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential credential = await auth.createUserWithEmailAndPassword(email: "gabriel@gmail.com", password: "123456");

      print(credential.user);
    } catch (e) {
      print(e);
    }
  } catch (e) {
    print(e);
  }
}
