import 'package:cipherx/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController deadlinecontroller = TextEditingController();
  TextEditingController durationcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Add Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                hintText: 'Add title',
              ),
            ),
            TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            TextField(
              controller: deadlinecontroller,
              decoration: InputDecoration(
                hintText: 'Deadline',
              ),
            ),
            TextField(
              controller: durationcontroller,
              decoration: InputDecoration(
                hintText: 'Task Duration',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> taskinfo = {
                    'title': titlecontroller.text,
                    'description': descriptioncontroller.text,
                    'deadline': deadlinecontroller.text,
                    'taskduration': durationcontroller.text,
                    'status': false,
                    'id': id,
                  };
                  await DatabaseMedthod().addtask(taskinfo, id);
                },
                child: Text('submit')),
          ],
        ),
      ),
    );
  }
}
