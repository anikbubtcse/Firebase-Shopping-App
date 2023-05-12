import 'package:firebase_shopping_app/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/registration_provider.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context, listen: true);

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
                          onSubmitted: (_) => provider.signUp(
                              _emailController, _passwordController, context),
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
                          onSubmitted: (_) => provider.signUp(
                              _emailController, _passwordController, context),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: provider.obsecureText,
                          decoration: InputDecoration(
                              hintText: 'password must be in 6 characters',
                              hintStyle: TextStyle(
                                  fontSize: 12.sp, color: Color(0xFF414041)),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.deep_orange),
                              suffixIcon: provider.obsecureText == false
                                  ? IconButton(
                                      onPressed: () {
                                        provider.toggleobsecureText();
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        size: 20.w,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        provider.toggleobsecureText();
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
                          onPressed: ()  => provider.signUp(
                              _emailController, _passwordController, context),
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
