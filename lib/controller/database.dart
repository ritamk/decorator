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

  Future<void> setOrderData(OrderModel order) async {
    try {
      final DocumentReference docRef = await _orderCollection.add({
        "uid": uid,
        "empName": order.empName,
        "empPhone": order.empPhone,
        "cltName": order.cltName,
        "cltPhone": order.cltPhone,
        "cltAddress": order.cltAddress,
        "amount": order.amount,
        "item": order.item,
        "orderDate": order.orderDate,
        "dueDate": order.dueDate,
        "approveDate": order.approveDate,
        "status": order.status,
      });

      await _employeeCollection.doc(uid).update({
        "orders": FieldValue.arrayUnion([docRef.id])
      });
    } catch (e) {
      print("setOrderData: ${e.toString()}");
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
                  empPhone: e["empPhone"],
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

  Future<Map<String, int>> getItemCount() async {
    try {
      Map<String, int> map = <String, int>{};
      final DocumentSnapshot docSnap =
          await _adminCollection.doc("itemCount").get();
      for (int i = 0; i < ITEMS.length; i++) {
        map[ITEMS[i]] = docSnap["${ITEMS[i]}Total"];
      }
      return map;
    } catch (e) {
      print("getItemCount: ${e.toString()}");
      throw STH_WENT_WRONG;
    }
  }

  Future<Map<String, int>> getItemRem() async {
    try {
      Map<String, int> map = <String, int>{};
      final DocumentSnapshot docSnap =
          await _adminCollection.doc("itemRem").get();
      for (int i = 0; i < ITEMS.length; i++) {
        map[ITEMS[i]] = docSnap["${ITEMS[i]}Rem"];
      }
      return map;
    } catch (e) {
      print("getItemRem: ${e.toString()}");
      throw STH_WENT_WRONG;
    }
  }

  Future<Map<String, int>> getItemRate() async {
    try {
      Map<String, int> map = <String, int>{};
      final DocumentSnapshot docSnap =
          await _adminCollection.doc("itemRate").get();
      for (int i = 0; i < ITEMS.length; i++) {
        map[ITEMS[i]] = docSnap["${ITEMS[i]}Rate"];
      }
      return map;
    } catch (e) {
      print("getItemRate: ${e.toString()}");
      throw STH_WENT_WRONG;
    }
  }
}
