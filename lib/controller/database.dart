import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorator/model/employee_model.dart';
import 'package:decorator/shared/constants.dart';

class DatabaseController {
  final String? uid;

  DatabaseController({this.uid});

  final CollectionReference _employeeCollection =
      FirebaseFirestore.instance.collection("Employee");

  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection("Order");

  final CollectionReference _completedCollection =
      FirebaseFirestore.instance.collection("Completed");

  final CollectionReference _adminCollection =
      FirebaseFirestore.instance.collection("Admin");

  Future<void> setEmployeeData(EmployeeModel employee) async {
    try {
      await _employeeCollection.doc(uid).set({
        "uid": employee.uid,
        "name": employee.name,
        "email": employee.email,
        "phone": employee.phone,
        "orders": [],
      });
    } catch (e) {
      print("setEmployeeData: ${e.toString()}");
      throw STH_WENT_WRONG;
    }
  }
}
