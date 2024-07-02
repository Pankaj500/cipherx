import 'package:cipherx/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskNotifier extends StatefulWidget {
  @override
  _TaskNotifierState createState() => _TaskNotifierState();
}

class _TaskNotifierState extends State<TaskNotifier> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> _tasks = [];
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenForTasks();
  }

  void _initializeNotifications() {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); //ic_notification
    final InitializationSettings initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _listenForTasks() {
    FirebaseFirestore.instance
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> tasks = [];
      for (var doc in snapshot.docs) {
        DateTime deadline = (doc['deadline'] as Timestamp).toDate();
        tasks.add({
          'id': doc.id,
          'task': doc['task'],
          'deadline': deadline,
          'description': doc['description'],
          'duration': doc['duration'],
          'status': doc['status'],
        });
        print(tasks);
        _scheduleNotification(doc.id, doc['task'], deadline);
      }
      setState(() {
        _tasks = tasks;
      });

      _cancelNotificationsForDeletedTasks(snapshot);
    });
  }

  Future<void> _cancelNotificationsForDeletedTasks(
      QuerySnapshot snapshot) async {
    final currentTaskIds = snapshot.docs.map((doc) => doc.id).toSet();
    final previousTaskIds = _tasks.map((task) => task['id']).toSet();

    final deletedTaskIds = previousTaskIds.difference(currentTaskIds);

    for (final taskId in deletedTaskIds) {
      await flutterLocalNotificationsPlugin.cancel(taskId.hashCode);
    }
  }

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
        setState(() {
          _selectedDateTime = finalDateTime;
          _dateTimeController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
        });
      }
    }
  }

  Future<void> _scheduleNotification(
      String taskId, String task, DateTime deadline) async {
    var scheduledNotificationDateTime = tz.TZDateTime.from(
        deadline.subtract(const Duration(minutes: 10)), tz.local);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'task_deadline_channel_id',
      'Task Deadlines',
      channelDescription: 'Notification channel for task deadlines',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskId.hashCode,
      'Task Deadline Reminder',
      'Your task "$task" is due in 10 minutes!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  TextEditingController _taskController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var heigth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return
            // ListTile(
            //   title: Text(task['task']),
            //   subtitle:
            //       Text(DateFormat('yyyy-MM-dd HH:mm').format(task['deadline'])),
            // );
            Padding(
          padding: EdgeInsets.only(
              left: width * 0.03, right: width * 0.03, top: width * 0.03),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(task['task']),
                  SizedBox(
                    height: heigth * 0.003,
                  ),
                  const Text(
                    'Deadline',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(DateFormat('yyyy-MM-dd HH:mm').format(task['deadline'])),
                  SizedBox(
                    height: heigth * 0.003,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(task['description']),
                  SizedBox(
                    height: heigth * 0.003,
                  ),
                  const Text(
                    'priority',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(task['duration']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                          value: task['status'],
                          onChanged: (value) async {
                            print(_tasks);
                            Map<String, dynamic> changecheck = {
                              'status': !task['status'],
                            };
                            await DatabaseMedthod()
                                .updatetasks(task['id'], changecheck);
                          }),
                      GestureDetector(
                        onTap: () {
                          _taskController.text = task['task'];
                          _descriptionController.text = task['description'];
                          _dateTimeController.text =
                              task['deadline'].toString();
                          _durationController.text = task['duration'];

                          edittask(task['id']);
                        },
                        child: const Icon(Icons.edit),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await DatabaseMedthod().deletetasks(task['id']);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future edittask(id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                children: [
                  const Text(
                    'editdetails',
                    style: TextStyle(fontSize: 18),
                  ),
                  TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add title',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
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
                    controller: _durationController,
                    decoration: const InputDecoration(
                      hintText: 'Task Duration',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updatetask = {
                            'task': _taskController.text,
                            'description': _descriptionController.text,
                            'deadline': _selectedDateTime,
                            'duration': _durationController.text,
                            'id': id,
                          };

                          await DatabaseMedthod()
                              .updatetasks(id, updatetask)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('update'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
