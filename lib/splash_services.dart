import 'dart:async';

import 'package:enter_video_storage_app/screens/home_screen.dart';
import 'package:enter_video_storage_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    if (user != null) {
      moNum = user.phoneNumber;
      Timer(
          const Duration(seconds: 1),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const HomeScreen())));
    } else {
      Timer(
          const Duration(seconds: 1),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const LoginPage())));
    }
  }
}
