import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../const/appcolors.dart';
import '../provider/login_provider.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: true);

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
                          controller: emailController,
                          onSubmitted: (_) => provider.signIn(
                              emailController, passwordController, context),
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
                          controller: passwordController,
                          obscureText: provider.obsecureText,
                          onSubmitted: (_) => provider.signIn(
                              emailController, passwordController, context),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: 'password must be in 6 characters',
                              hintStyle: TextStyle(
                                  fontSize: 12.sp, color: Color(0xFF414041)),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.deep_orange),
                              suffixIcon: provider.obsecureText == true
                                  ? IconButton(
                                      onPressed: () {
                                        provider.toggleobsecureText();
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        size: 20.w,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        provider.toggleobsecureText();
                                      },
                                      icon: const Icon(Icons.remove_red_eye))

                          ),
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
                          onPressed: () {
                            provider.signIn(
                                emailController, passwordController, context);
                          },
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
