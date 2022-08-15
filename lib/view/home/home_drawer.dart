import 'package:decorator/controller/auth.dart';
import 'package:decorator/controller/shared_pref.dart';
import 'package:decorator/model/employee_model.dart';
import 'package:decorator/shared/constants.dart';
import 'package:decorator/shared/loading.dart';
import 'package:decorator/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool _signingOut = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: buttonCol,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  UserSharedPreferences.getDetailedUseData()!.name!,
                  style: const TextStyle(color: buttonTextCol),
                ),
                Text(
                  UserSharedPreferences.getDetailedUseData()!.phone!,
                  style: const TextStyle(color: buttonTextCol),
                ),
                Text(
                  UserSharedPreferences.getDetailedUseData()!.email!,
                  style: const TextStyle(color: buttonTextCol),
                ),
              ],
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              textColor: buttonTextCol,
              iconColor: buttonTextCol,
              trailing: const Icon(Icons.logout),
              title: !_signingOut
                  ? const Text("\tSign out")
                  : const Loading(white: true),
              onTap: () => signOutLogic(() {
                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (context) => const Wrapper(),
                    ),
                    (route) => false);
              }),
            ),
          )),
        ],
      ),
    );
  }

  Future<void> signOutLogic(VoidCallback route) async {
    setState(() => _signingOut = true);
    await UserSharedPreferences.setLoggedIn(false);
    await UserSharedPreferences.setUid("");
    await UserSharedPreferences.setDetailedUserData(EmployeeModel(name: null));
    await AuthenticationController().signOut();
    route.call();
  }
}
