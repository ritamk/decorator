import 'package:decorator/controller/auth.dart';
import 'package:decorator/controller/shared_pref.dart';
import 'package:decorator/shared/loading.dart';
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
  late bool verified;
  String? user;
  bool timeOut = false;
  @override
  void initState() {
    super.initState();
    if (UserSharedPreferences.getUser() != null) {
      user = UserSharedPreferences.getUser();
    } else {
      user = null;
    }
    if (UserSharedPreferences.getVerifiedOrNot() != null) {
      verified = UserSharedPreferences.getVerifiedOrNot()!;
    } else {
      verified = false;
      UserSharedPreferences.setVerifiedOrNot(verified);
    }
    Future.delayed(const Duration(seconds: 2))
        .then((value) => setState(() => timeOut = true));
  }

  @override
  Widget build(BuildContext context) {
    if (timeOut) {
      if (user != null) {
        if (verified) {
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
                setUser(snapshot.data);
                if (verified) {
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

  Future setUser(String uid) async {
    await UserSharedPreferences.setUser(uid);
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
          Center(
            child: Text(
              "DECORATOR'S",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
            ),
          ),
          SizedBox(height: 40.0),
          Loading(white: false, rad: 14.0),
        ],
      ),
    );
  }
}
