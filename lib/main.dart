import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_shopping_app/screens/bottom_nav_controller_screen.dart';
import 'package:firebase_shopping_app/screens/login_screen.dart';
import 'package:firebase_shopping_app/screens/registration_screen.dart';
import 'package:firebase_shopping_app/screens/search_screen.dart';
import 'package:firebase_shopping_app/screens/user_forn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'provider/authentication_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthenticationProvider(),)
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (BuildContext context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Firebase Shopping App',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange, fontFamily: 'Raleway'),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/registration_screen': (context) => RegistrationScreen(),
              '/login_screen': (context) => LoginScreen(),
              '/bottom_nav_screen': (context) => BottomNavController(),
              '/user_form_screen': (context) => UserFormScreen(),
              'Search_Screen': (context) => SearchScreen(),
            },
          );
        });
  }
}
