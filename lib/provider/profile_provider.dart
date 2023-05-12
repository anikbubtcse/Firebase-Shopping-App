import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  updateUserData(
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController ageController,
  ) {
    TextEditingController _nameController = nameController;
    TextEditingController _phoneController = phoneController;
    TextEditingController _ageController = ageController;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
          'Name': _nameController.text,
          'Age': _ageController.text,
          'Phone Number': _phoneController.text
        })
        .then((value) =>
            Fluttertoast.showToast(msg: 'User information has been updated'))
        .catchError((error) => print("Failed to update user: $error"));

    notifyListeners();
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    Navigator.of(context).pushReplacementNamed('/login_screen');
    notifyListeners();
  }
}
