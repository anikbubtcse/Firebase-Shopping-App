import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/appcolors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obsecureText = true;

  _signIn() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var userCredential = credential.user;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', _passwordController.text);

        if (userCredential!.uid.isNotEmpty) {
          Navigator.of(context).pushNamed('/bottom_nav_screen');
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
  }

  _autoSignIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    print(email);
    print(password);

    if (email!.isNotEmpty && password!.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        var userCredential = credential.user;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);

        if (userCredential!.uid.isNotEmpty) {
          Navigator.of(context).pushNamed('/bottom_nav_screen');
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
    }
  }

  @override
  void initState() {
    _autoSignIn();
    super.initState();
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
              'Sign In',
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
                        'Welcome Back',
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
                        'Glad to see you back my buddy.',
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
                          onSubmitted: (_) => _signIn(),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          onSubmitted: (_) => _signIn(),
                          controller: _passwordController,
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
                          onPressed: _signIn,
                          child: Text(
                            'SIGN IN',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          )),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        const Text('Don\'t have an account?'),
                        SizedBox(
                          width: 5.w,
                        ),
                        GestureDetector(
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                color: AppColors.deep_orange, fontSize: 15.sp),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/registration_screen');
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
