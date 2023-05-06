import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../const/appcolors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

final List<String> list = ['Male', 'Female', 'Other'];

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Widget _myTextField(TextInputType keyboardType,
      TextEditingController controller, String hintText, double fontsize) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.sp,
          )),
    );
  }

  _setTextFieldDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2030))
        .then((value) {
      if (value == null) {
        return;
      }
      _dateOfBirthController.text = DateFormat.yMMMMEEEEd().format(value);
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> _addUser() {
    final user = FirebaseAuth.instance.currentUser;
    return users
        .doc(user!.email)
        .set({
          'Name': _nameController.text, // John Doe
          'Phone Number': _phoneNumberController.text, // Stokes and Sons
          'Age': _ageController.text,
          'Date of Birth': _dateOfBirthController.text,
          'Gender': _genderController.text
        })
        .then((value) => Navigator.of(context).pushReplacementNamed('/bottom_nav_screen')
        .catchError((error) => print("Failed to add user: $error")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submit the form to continue.',
                      style: TextStyle(
                          color: AppColors.deep_orange, fontSize: 25.sp),
                    ),
                    FittedBox(
                      child: Text(
                        'Without your consent, we will not share your information.',
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _myTextField(TextInputType.text, _nameController,
                        'Enter your name', 15.sp),
                    _myTextField(TextInputType.number, _phoneNumberController,
                        'Enter your phone number', 15.sp),
                    TextField(
                      controller: _dateOfBirthController,
                      decoration: InputDecoration(
                          hintText: 'Enter your date of birth',
                          hintStyle: TextStyle(fontSize: 15.sp),
                          suffixIcon: IconButton(
                            onPressed: () => _setTextFieldDate(context),
                            icon: (Icon(Icons.date_range_outlined)),
                          )),
                    ),
                    TextField(
                      controller: _genderController,
                      decoration: InputDecoration(
                        hintText: 'Choose your gender',
                        hintStyle: TextStyle(fontSize: 15.sp),
                        suffixIcon: DropdownButton<String>(
                          items: list.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                              onTap: () {
                                setState(() {
                                  _genderController.text = value;
                                });
                              },
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    _myTextField(TextInputType.text, _ageController,
                        'Enter your age', 15.sp),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: TextButton(
                          onPressed: _addUser,
                          child: Text(
                            'CONTINUE',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
