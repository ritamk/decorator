import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? uid;
  final String? empName;
  final String? cltName;
  final String? cltPhone;
  final String? cltAddress;
  final Map<String, int>? item;
  final Timestamp? dueDate;
  final Timestamp? orderDate;
  final Timestamp? approveDate;
  final String? status;
  final String? amount;

  OrderModel({
    this.uid,
    this.empName,
    this.orderDate,
    this.dueDate,
    this.approveDate,
    this.amount,
    this.cltName,
    this.cltPhone,
    this.cltAddress,
    this.item,
    this.status,
  });
}
