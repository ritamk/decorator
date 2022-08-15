import 'package:decorator/controller/auth.dart';
import 'package:decorator/controller/shared_pref.dart';
import 'package:decorator/shared/constants.dart';
import 'package:decorator/shared/loading.dart';
import 'package:decorator/shared/snackbar.dart';
import 'package:decorator/view/auth/auth_page.dart';
import 'package:decorator/view/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  bool timeOut = false;
  late String? uid;
  late bool loggedIn;
  @override
  void initState() {
    super.initState();
    uid = UserSharedPreferences.getUid();
    loggedIn = UserSharedPreferences.getLoggedIn();
    Future.delayed(const Duration(seconds: 2))
        .then((value) => setState(() => timeOut = true));
  }

  @override
  Widget build(BuildContext context) {
    if (timeOut) {
      if (uid != null) {
        if (loggedIn) {
          return const HomePage();
        } else {
          return const AuthPage();
        }
      } else {
        return FutureBuilder<String>(
          future: AuthenticationController().currentUser(),
          initialData: "",
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "") {
              if (snapshot.data != null) {
                setUser(snapshot.data, () {
                  if (!mounted) return;
                  commonSnackbar(STH_WENT_WRONG, context);
                });
                if (loggedIn) {
                  return const HomePage();
                } else {
                  return const AuthPage();
                }
              } else {
                return const AuthPage();
              }
            } else {
              return const WrapperBody();
            }
          },
        );
      }
    } else {
      return const WrapperBody();
    }
  }

  Future setUser(String uid, VoidCallback snackbar) async {
    await UserSharedPreferences.setUid(uid)
        .then((value) => value ? null : snackbar.call());
  }
}

class WrapperBody extends StatelessWidget {
  const WrapperBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(child: decoratorText),
          SizedBox(height: 40.0),
          Loading(white: false, rad: 14.0),
        ],
      ),
    );
  }
}
