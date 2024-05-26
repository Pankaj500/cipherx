import 'package:cipherx/firebase/messaging/gsm.dart';
import 'package:cipherx/main.dart';
import 'package:flutter/material.dart';

class HomeTasks extends StatefulWidget {
  const HomeTasks({super.key});

  @override
  State<HomeTasks> createState() => _HomeTasksState();
}

class _HomeTasksState extends State<HomeTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: TaskNotifier()), // Display the tasks
          AddTaskButton(), // Button to add a new task
        ],
      ),
    );
  }
}
