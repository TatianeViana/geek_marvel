import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geek_marvel/login_page.dart';
import 'package:geek_marvel/splash_page.dart';
import 'package:geek_marvel/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

void main() async{
  WidgetsFlutterBinding();
  await Firebase.initializeApp();


  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geek Marvel',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromRGBO(3, 23, 74, 100)
        ),
        primaryColor: Colors.grey[900],
       // accentColor: Color(0xff586894)
      ),
      initialRoute: '/splash',
      routes: {
        '/splash':(_)=> const SplashPage(),
        '/login':(_)=> const LoginPage(),
        '/home':(_)=> const HomePage(),




      },
    );
  }
}
