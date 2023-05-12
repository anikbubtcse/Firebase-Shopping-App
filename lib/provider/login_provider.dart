import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _obsecureText = true;

  bool get obsecureText => _obsecureText;

  String? _emailData;

  String? get emailData => _emailData;

  String? _passwordData;

  String? get passwordData => _passwordData;

  Future<void> signIn(TextEditingController email,
      TextEditingController password, BuildContext context) async {
    TextEditingController _emailController = email;
    TextEditingController _passwordController = password;

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var userCredential = credential.user;

        if (userCredential!.uid.isNotEmpty) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', _emailController.text);
          await prefs.setString('password', _passwordController.text);
          Navigator.of(context).pushReplacementNamed('/bottom_nav_screen');
        } else {
          Fluttertoast.showToast(msg: 'Something wrong');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      Fluttertoast.showToast(msg: 'Email and Password can\'t be empty');
    }
    notifyListeners();
  }

  toggleobsecureText() {
    if (_obsecureText == true) {
      _obsecureText = false;
    } else if (_obsecureText == false) {
      _obsecureText = true;
    }
    notifyListeners();
  }

  signUp(TextEditingController email, TextEditingController password,
      BuildContext context) async {
    TextEditingController _emailController = email;
    TextEditingController _passwordController = password;

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var userCredential = credential.user;

        if (userCredential!.uid.isNotEmpty) {
          Navigator.of(context).pushReplacementNamed('/user_form_screen');
        } else {
          Fluttertoast.showToast(msg: 'Something wrong');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: 'The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      Fluttertoast.showToast(msg: 'Email and Password must be provided');
    }
  }
}
