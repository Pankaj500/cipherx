import 'package:cipherx/features/onboarding/auth.dart';
import 'package:cipherx/features/onboarding/sign_in.dart';
import 'package:cipherx/repositories/product._repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../firebase/homepage.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({super.key});
  final Auth _auth = Auth();
  bool value = false;
  final GetProductList _getProductList = GetProductList();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => MyCheckboxModel(),
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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.15,
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
                        controller: namecontroller,
                        decoration: InputDecoration(
                          hintText: 'Name',
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
                          suffixIcon: const Icon(Icons.remove_red_eye),
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
                  Row(
                    children: [
                      Consumer<MyCheckboxModel>(
                        builder: (context, MyCheckboxModel, child) {
                          return Checkbox(
                            value: MyCheckboxModel.isChecked,
                            onChanged: (newValue) {
                              MyCheckboxModel.toggleChecked();
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color:
                                    Colors.blue, // Change this color as needed
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: size.width * 0.72,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'By signing up, you agree to the ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Terms of',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff7F3DFF),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Service and Privacy Policy',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff7F3DFF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _auth.createUserWithEmainAndPassword(
                          emailcontroller.text.toString(),
                          passwordcontroller.text.toString(),
                          context);
                    },
                    child: Container(
                      height: size.height * 0.07,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: const Color(0xff7F3DFF),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Text(
                          'Sign Up',
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
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
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
                                      builder: (context) => SignInPage()));
                            },
                            child: const Text(
                              ' Login',
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
      ),
    );
  }
}

class MyCheckboxModel extends ChangeNotifier {
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void toggleChecked() {
    _isChecked = !_isChecked;
    notifyListeners();
  }
}
