import 'package:cipherx/features/product.dart';
import 'package:cipherx/firebase/homepage.dart';
import 'package:cipherx/firebase/messaging/tasks_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get curretUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeTasks(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('failed login')));
    }

    User? user = FirebaseAuth.instance.currentUser;

    return user;
  }

  Future<User?> createUserWithEmainAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeTasks(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('registration failed')));
    }

    User? user = FirebaseAuth.instance.currentUser;

    return user;
  }

  Future<void> signout() async {
    _firebaseAuth.signOut();
  }
}
