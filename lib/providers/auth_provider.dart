import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isAuth = false;

  bool get isAuth {
    return _isAuth;
  }

  String? get token {
    return _user?.uid;
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isAuth')) return;

    _isAuth = prefs.getBool('isAuth') ?? false;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _isAuth = true;
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAuth', true);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isAuth = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isAuth');
    _user = null;
    notifyListeners();
  }
}
