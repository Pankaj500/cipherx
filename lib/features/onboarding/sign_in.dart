import 'package:cipherx/features/onboarding/auth.dart';
import 'package:cipherx/features/onboarding/onboarding.dart';
import 'package:cipherx/firebase/homepage.dart';
import 'package:cipherx/repositories/product._repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  SignInPage({super.key});
  final Auth _auth = Auth();
  bool value = false;
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  final GetProductList _getProductList = GetProductList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                top: size.width * 0.05),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.arrow_back),
                    SizedBox(
                      width: size.width * 0.3,
                    ),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.3,
                ),
                Container(
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        // suffixIcon: const Icon(Icons.remove_red_eye),
                        suffixIconColor: Colors.grey,
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () async {
                    _auth.signInWithEmailAndPassword(
                        emailcontroller.text.toString(),
                        passwordcontroller.text.toString(),
                        context);
                    // _getProductList.getproduct(ref, context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirebaseHomepage()));
                  },
                  child: Container(
                    height: size.height * 0.07,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: const Color(0xff7F3DFF),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnBoardingPage(),
                              ),
                            );
                          },
                          child: const Text(
                            ' Create',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff7F3DFF),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: size.width * 0.11,
                          color: const Color(0xff7F3DFF),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
