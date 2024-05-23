import 'package:cipherx/features/onboarding/onboarding.dart';
import 'package:cipherx/features/onboarding/sign_in.dart';
import 'package:flutter/material.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff7F3DFF),
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
            top: size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/flower.png',
              scale: 1.8,
            ),
            SizedBox(
              height: size.height * 0.6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Text(
                      'CIPHERX',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: size.height * 0.06,
                  backgroundColor: const Color(0xffEDE1E1BF),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      );
                    },
                    child: Center(
                      child: Icon(
                        Icons.chevron_right,
                        size: size.height * 0.13,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Text(
                'The best place for Makeup Products',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
