import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorator/model/employee_model.dart';
import 'package:decorator/model/order_model.dart';
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

  Future<EmployeeModel?> getEmployeeData() async {
    try {
      final DocumentSnapshot docSnap = await _employeeCollection.doc(uid).get();
      final dynamic data = docSnap.data();
      return EmployeeModel(
        name: data["name"],
        email: data["email"],
        phone: data["phone"],
      );
    } catch (e) {
      print("getEmployeeData: ${e.toString()}");
      throw STH_WENT_WRONG;
    }
  }

  Stream<List<OrderModel>?> getOrderData() {
    try {
      return _orderCollection
          .where("uid", isEqualTo: uid)
          .snapshots()
          .map((event) => event.docs
              .map(
                (QueryDocumentSnapshot e) => OrderModel(
                  uid: e["uid"],
                  empName: e["empName"],
                  orderDate: e["orderDate"],
                  dueDate: e["dueDate"],
                  approveDate: e["approveDate"],
                  amount: e["amount"],
                  cltName: e["cltName"],
                  cltAddress: e["cltAddress"],
                  cltPhone: e["cltPhone"],
                  item: e["item"],
                  status: e["status"],
                ),
              )
              .toList());
    } catch (e) {
      print("getOrderData: ${e.toString()}");
      throw STH_WENT_WRONG;
    }
  }
}
