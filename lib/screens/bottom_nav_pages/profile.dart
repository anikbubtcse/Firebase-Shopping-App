import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_app/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  _updateUserData() {
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange),
                  );
                }

                var data = snapshot.data!.data();
                _nameController.text = data?['Name'];
                _ageController.text = data?['Age'];
                _phoneController.text = data?['Phone Number'];

                return Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                      ),
                      TextFormField(
                        controller: _ageController,
                      ),
                      TextFormField(
                        controller: _phoneController,
                      ),
                    ],
                  ),
                );
              }),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: AppColors.deep_orange,
            ),
            onPressed: () {
              _updateUserData();
            },
            child: Text('UPDATE'),
          )
        ],
      ),
    );
  }
}
