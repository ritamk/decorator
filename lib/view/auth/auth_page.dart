import 'package:decorator/shared/constants.dart';
import 'package:decorator/view/auth/sign_in.dart';
import 'package:decorator/view/auth/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "DECORATOR'S",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (builder) => const SignUpPage())),
                    style: authSignInBtnStyle(),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (builder) => const SignInPage())),
                    style: authSignInBtnStyle(),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Sign-in",
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
