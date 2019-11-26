import 'package:bankapp/home_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';






void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginScreen(),
        theme: new ThemeData(primarySwatch: Colors.blue));
  }
}


