import 'dart:async';

import 'package:cipherx/features/getting_started.dart';
import 'package:cipherx/features/onboarding/sign_in.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    });
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff7F3DFF),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.4,
          ),
          Image.asset('assets/flower.png'),
          Text(
            'CIPHERX',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: size.height * 0.27,
          ),
          Text(
            'By',
            style:
                TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.5)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Source ',
                style: TextStyle(
                    fontSize: 20, color: Colors.white.withOpacity(0.5)),
              ),
              const Text(
                'Community',
                style: TextStyle(fontSize: 20, color: Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
