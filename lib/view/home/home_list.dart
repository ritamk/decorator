import 'package:decorator/controller/database.dart';
import 'package:decorator/controller/shared_pref.dart';
import 'package:decorator/model/employee_model.dart';
import 'package:decorator/model/order_model.dart';
import 'package:decorator/shared/constants.dart';
import 'package:decorator/shared/loading.dart';
import 'package:decorator/shared/snackbar.dart';
import 'package:flutter/material.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  bool _loadingUserData = true;

  @override
  void initState() {
    super.initState();
    if (UserSharedPreferences.getDetailedUseData() != null) {
      setState(() => _loadingUserData = false);
    } else {
      loadUserData(
        () {
          if (!mounted) return;
          commonSnackbar("Could not load user data", context);
        },
      ).then((value) => setState(() => _loadingUserData = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: !_loadingUserData
          ? StreamBuilder<List<OrderModel>?>(
              stream: DatabaseController(uid: UserSharedPreferences.getUid())
                  .getOrderData(),
              initialData: const [],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final OrderModel order = snapshot.data[index];

                        return ListTile(
                          title: Text(order.cltName!),
                        );
                      },
                      physics: bouncingScroll,
                    );
                  } else {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.cancel, color: buttonCol),
                          SizedBox(width: 10.0),
                          Text("No incomplete orders"),
                        ],
                      ),
                    );
                  }
                } else {
                  return const Center(child: Loading(white: false, rad: 14.0));
                }
              },
            )
          : const Center(child: Loading(white: false, rad: 14.0)),
    );
  }

  Future<void> loadUserData(VoidCallback snackbar) async {
    try {
      final EmployeeModel? employeeModel =
          await DatabaseController(uid: UserSharedPreferences.getUid())
              .getEmployeeData();

      if (employeeModel != null) {
        UserSharedPreferences.setDetailedUserData(employeeModel);
      }
    } catch (e) {
      try {
        final EmployeeModel? employeeModel =
            await DatabaseController(uid: UserSharedPreferences.getUid())
                .getEmployeeData();

        if (employeeModel != null) {
          UserSharedPreferences.setDetailedUserData(employeeModel);
        }
      } catch (e) {
        snackbar.call();
      }
    }
  }
}
