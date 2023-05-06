import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_app/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obsecureText = true;

  _signUp() async {
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
          Navigator.of(context).pushNamed('/user_form_screen');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: Column(
        children: [
          SizedBox(
            height: 150.h,
          ),
          Container(
            padding: EdgeInsets.only(left: 20.w),
            width: ScreenUtil().screenWidth,
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Expanded(
            child: Container(
              width: ScreenUtil().screenWidth,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.w),
                      topLeft: Radius.circular(20.w))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      child: Text(
                        'Welcome Buddy!',
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: AppColors.deep_orange,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      child: Text(
                        'Glad to see you my buddy.',
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 48.h,
                          width: 41.h,
                          decoration: BoxDecoration(
                              color: AppColors.deep_orange,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Center(
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              size: 25.w,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) => _signUp(),
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: 'anikbubtcse@gmail.com',
                              hintStyle: TextStyle(
                                  fontSize: 12.sp, color: Color(0xFF414041)),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.deep_orange)),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 48.h,
                          width: 41.h,
                          decoration: BoxDecoration(
                              color: AppColors.deep_orange,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Center(
                            child: Icon(
                              Icons.password,
                              color: Colors.white,
                              size: 25.w,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _passwordController,
                          onSubmitted: (_) => _signUp(),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _obsecureText,
                          decoration: InputDecoration(
                              hintText: 'password must be in 6 characters',
                              hintStyle: TextStyle(
                                  fontSize: 12.sp, color: Color(0xFF414041)),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.deep_orange),
                              suffixIcon: _obsecureText == false
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obsecureText = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        size: 20.w,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obsecureText = false;
                                        });
                                      },
                                      icon: Icon(Icons.visibility_off))),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 40.sp,
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      decoration: BoxDecoration(
                          color: AppColors.deep_orange,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: TextButton(
                          onPressed: _signUp,
                          child: Text(
                            'CONTINUE',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          )),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Text('Do you have an account?'),
                        SizedBox(
                          width: 5.w,
                        ),
                        GestureDetector(
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                color: AppColors.deep_orange, fontSize: 15.sp),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/login_screen');
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
