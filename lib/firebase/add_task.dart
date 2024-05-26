import 'package:cipherx/firebase/firestore.dart';
import 'package:cipherx/firebase/notifications/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController _dateTimeController = TextEditingController();

  NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('persons')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        DateTime scheduledTime = (doc['deadline'] as Timestamp).toDate();
        _notificationService.scheduleNotification(scheduledTime);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pickDateTime() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          DateTime finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime) as String;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Add Task '),
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
              controller: _dateTimeController,
              decoration: InputDecoration(
                  hintText: 'Deadline',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _pickDateTime();
                    },
                    child: const Icon(Icons.calendar_today),
                  )),
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
                    'deadline': _dateTimeController.text,
                    'taskduration': durationcontroller.text,
                    'status': false,
                    'id': id,
                  };
                  await DatabaseMedthod().addtask(taskinfo, id).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('task added successfully')));
                  });
                },
                child: const Text('submit')),
          ],
        ),
      ),
    );
  }
}
