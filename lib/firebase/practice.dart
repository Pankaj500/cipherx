import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  bool change = false;
  List<String> list = ['Pankaj', 'Aman'];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      current = index;
                    });
                  },
                  child: Center(
                    child: Text(
                      list[index],
                      style: TextStyle(
                          fontSize: 20,
                          color: current == index ? Colors.red : Colors.black),
                    ),
                  ),
                );
              })),
    );
  }
}
