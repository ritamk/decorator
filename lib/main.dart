import 'package:decorator/controller/shared_pref.dart';
import 'package:decorator/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decorator App',
      theme: mainTheme(),
      color: CupertinoColors.systemRed,
      home: const Wrapper(),
    );
  }
}

ThemeData mainTheme() {
  return ThemeData(
    fontFamily: "Montserrat",
    dividerColor: const Color.fromARGB(0, 0, 0, 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(76, 255, 255, 255),
      elevation: 0.0,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        color: CupertinoColors.systemRed,
        fontWeight: FontWeight.bold,
        fontFamily: "Montserrat",
      ),
      backgroundColor: Color.fromARGB(76, 255, 255, 255),
      foregroundColor: CupertinoColors.systemRed,
    ),
    primarySwatch: Colors.red,
  );
}

// CupertinoThemeData mainTheme() {
//   return const CupertinoThemeData(
//     primaryColor: CupertinoColors.systemRed,
//     primaryContrastingColor: CupertinoColors.white,
//     textTheme: CupertinoTextThemeData(
//       primaryColor: CupertinoColors.white,
//       textStyle: TextStyle(fontFamily: "Montserrat"),
//     ),
//     barBackgroundColor: CupertinoColors.white,
//     scaffoldBackgroundColor: CupertinoColors.systemRed,
//   );
// }
