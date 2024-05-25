import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> submitAuthForm(String email, String password, String username, bool isLogin) async {
    try {
      if (isLogin) {
        final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        print(userCredentials);
      } else {
        final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        await _firebaseFirestore.collection("users").doc(userCredentials.user!.uid).set({'email': email, 'username': username});
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      return true;
    } on FirebaseAuthException catch (error) {
      print(error.message ?? "Login/Registration failed.");
      return false;
    }
  }
}
