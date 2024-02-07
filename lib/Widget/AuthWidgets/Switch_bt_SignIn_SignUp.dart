import 'package:flutter/material.dart';
import 'package:nex_social/Screens/AuthScreens/SignInScreen.dart';
import 'package:nex_social/Screens/AuthScreens/SignUpScreen.dart';

class Switch_bt_SignIn_SignUp extends StatefulWidget {
  const Switch_bt_SignIn_SignUp({super.key});

  @override
  State<Switch_bt_SignIn_SignUp> createState() =>
      _Switch_bt_SignIn_SignUpState();
}

class _Switch_bt_SignIn_SignUpState extends State<Switch_bt_SignIn_SignUp> {
  bool _toggleBTscreens = true;

  void toggleScreens() {
    setState(() {
      _toggleBTscreens = !_toggleBTscreens;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _toggleBTscreens
        ? SignInScreen(toggleScreens)
        : SignUpScreen(toggleScreens);
  }
}
