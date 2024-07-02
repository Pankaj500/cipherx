import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  DateTime? _selectedDateTime;

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

  Future<void> _saveTask() async {
    String id = randomAlphaNumeric(10);

    if (_taskController.text.isNotEmpty && _selectedDateTime != null) {
      await FirebaseFirestore.instance.collection('tasks').add({
        'task': _taskController.text,
        'deadline': _selectedDateTime,
        'description': _descriptionController.text,
        'duration': _durationController.text,
        'status': false,
        'id': id,
      });
      Navigator.pop(context);
    }
  }

  String? _selecteditem;
  List<String> prioritylist = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    var heigth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dateTimeController,
              decoration: InputDecoration(
                labelText: 'Deadline',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDateTime,
                ),
              ),
              readOnly: true,
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Priortiy',
                hintText: 'enter priorty high or low',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
