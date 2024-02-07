import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Screens/AuthScreens/EmailVerficationScreen.dart';
import 'package:nex_social/Widget/AuthWidgets/Switch_bt_SignIn_SignUp.dart';

class ShowScreenOnUserData extends StatelessWidget {
  static const routeName = 'ShowScreenOnUserData';

  const ShowScreenOnUserData({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return EmailVerficationScreen(snapshot.data!);
        }
        return const Switch_bt_SignIn_SignUp();
      },
    );
  }
}
