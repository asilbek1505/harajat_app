import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harajat_app/pages/Login.dart';

class AuthServise{
  static final _auth = FirebaseAuth.instance;

  static String currentUserId(){
    final User? firebaseUser=_auth.currentUser;
    return firebaseUser!.uid;
  }
  static String? currentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }


  static Future<User?> loginUser(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    final User firebaseUser = _auth.currentUser!;
    return firebaseUser;
  }
  static Future<User?> signUp(
      String email, String password, String name) async {
    var result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user;
  }
  static Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
     return LoginPage();
   }));
  }

}