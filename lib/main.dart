import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_shopping_app/provider/cart_provider.dart';
import 'package:firebase_shopping_app/provider/favorite_provider.dart';
import 'package:firebase_shopping_app/provider/profile_provider.dart';
import 'package:firebase_shopping_app/provider/registration_provider.dart';
import 'package:firebase_shopping_app/screens/bottom_nav_controller_screen.dart';
import 'package:firebase_shopping_app/screens/login_screen.dart';
import 'package:firebase_shopping_app/screens/registration_screen.dart';
import 'package:firebase_shopping_app/screens/search_screen.dart';
import 'package:firebase_shopping_app/screens/user_forn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'provider/login_provider.dart';

String? email;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => LoginProvider(),
    ),
    ChangeNotifierProvider(create: (_) => RegistrationProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Firebase Shopping App',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange, fontFamily: 'Raleway'),
            initialRoute:
                email == null ? '/splash_screen' : '/bottom_nav_screen',
            routes: {
              '/splash_screen': (context) => SplashScreen(),
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
