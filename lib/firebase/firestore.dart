import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMedthod {
  Future addtask(Map<String, dynamic> taskinfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("persons")
        .doc(id)
        .set(taskinfo);
  }

  Future<Stream<QuerySnapshot>> getalltask() async {
    return await FirebaseFirestore.instance.collection("persons").snapshots();
  }

  Future updatetasks(String id, Map<String, dynamic> taskinfo) async {
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(id)
        .update(taskinfo);
  }

  Future deletetasks(String id) async {
    await FirebaseFirestore.instance.collection("tasks").doc(id).delete();
  }
}
