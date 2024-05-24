import 'package:cipherx/firebase/add_task.dart';
import 'package:cipherx/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseHomepage extends StatefulWidget {
  const FirebaseHomepage({super.key});

  @override
  State<FirebaseHomepage> createState() => _FirebaseHomepageState();
}

class _FirebaseHomepageState extends State<FirebaseHomepage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController deadlinecontroller = TextEditingController();
  TextEditingController durationcontroller = TextEditingController();
  Stream? personstream;

  getloadmethod() async {
    personstream = await DatabaseMedthod().getalltask();
    setState(() {});
  }

  Widget alltaskdetails() {
    return StreamBuilder(
        stream: personstream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ds['title'],
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Description',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ds['description'],
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Deadline',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ds['deadline'],
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Task Duration',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                ds['taskduration'],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      titlecontroller.text = ds['title'];
                                      descriptioncontroller.text =
                                          ds['description'];
                                      deadlinecontroller.text = ds['deadline'];
                                      durationcontroller.text =
                                          ds['taskduration'];

                                      edittask(ds['id']);
                                    },
                                    child: Icon(Icons.edit),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String id = ds['id'];
                                      await DatabaseMedthod().deletetasks(id);
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getloadmethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var heigth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Task_Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              alltaskdetails(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        child: const Icon(Icons.add),
      ),
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
                  Text(
                    'editdetails',
                    style: TextStyle(fontSize: 18),
                  ),
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
                        child: Text('cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updatetask = {
                            'title': titlecontroller.text,
                            'description': descriptioncontroller.text,
                            'deadline': deadlinecontroller.text,
                            'taskduration': durationcontroller.text,
                            'id': id,
                          };

                          await DatabaseMedthod()
                              .updatetasks(id, updatetask)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text('update'),
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
