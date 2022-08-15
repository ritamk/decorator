import 'package:decorator/shared/constants.dart';
import 'package:decorator/view/home/add_order_page.dart';
import 'package:decorator/view/home/home_drawer.dart';
import 'package:decorator/view/home/home_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const HomeList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Request",
        backgroundColor: buttonCol,
        foregroundColor: buttonTextCol,
        onPressed: () {
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const AddOrderPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
