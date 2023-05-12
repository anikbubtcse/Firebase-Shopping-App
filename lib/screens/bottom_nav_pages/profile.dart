import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_app/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.email)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    provider.updateUserData(
                        _nameController, _phoneController, _ageController);
                  },
                  child: Text('UPDATE')),
              ElevatedButton(
                  onPressed: () {
                    provider.signOut(context);
                  },
                  child: Text('Sign Out'))
            ],
          )
        ],
      ),
    );
  }
}
