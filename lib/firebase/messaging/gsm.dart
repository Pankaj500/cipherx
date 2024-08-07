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

  int current = 0;

  String _orderby = 'task';

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
        .orderBy(_orderby)
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

    List<String> sortitem = ['by deadline', 'by priority'];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: heigth * 0.02,
          ),
          ElevatedButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: heigth * 0.2,
                        width: width,
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.03,
                                right: width * 0.03,
                                top: heigth * 0.04),
                            child: ListView.builder(
                                itemCount: 2,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (index == 0) {
                                        _orderby = 'deadline';
                                      } else {
                                        _orderby = 'duration';
                                      }
                                      _listenForTasks();
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          sortitem[index],
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  );
                                })),
                      );
                    });
              },
              child: Text('Sort')),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _tasks.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: width * 0.03, right: width * 0.03, top: width * 0.03),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.03,
                        right: width * 0.03,
                        top: heigth * 0.02),
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
                        Text(DateFormat('yyyy-MM-dd HH:mm')
                            .format(task['deadline'])),
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
                        Text(task['duration'].toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                                value: task['status'],
                                onChanged: (value) async {
                                  Map<String, dynamic> changecheck = {
                                    'status': value
                                  };
                                  await DatabaseMedthod()
                                      .updatetasks(task['id'], changecheck);
                                }),
                            GestureDetector(
                              onTap: () {
                                _taskController.text = task['task'];
                                _descriptionController.text =
                                    task['description'];
                                _dateTimeController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(task['deadline']);
                                _durationController.text =
                                    task['duration'].toString();

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
          ),
        ],
      ),
    );
  }

  Future edittask(String id) async {
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
                    keyboardType: TextInputType.number,
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
                            'duration': int.parse(_durationController.text),
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
