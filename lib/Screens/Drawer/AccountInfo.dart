import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/Widget/Drawer/AccountInfo.dart';
import 'package:intl/intl.dart';

class AccountInfo extends StatelessWidget {
  static const routeName = 'AccountInfo';

  AccountInfo({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Account Detail',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
              child: Lottie.asset(
                'assets/secure.json',
                repeat: false,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: Text(
                'Your Account Is Secure',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AccountInfoWidget(
              'Last updated on',
              DateFormat('dd MMM yyyy hh:mm a').format(
                DateTime.parse(
                  user.metadata.creationTime.toString(),
                ),
              ),
              Icons.alarm_on_outlined,
            ),
            AccountInfoWidget(
                'User Name', user.displayName!, Icons.person_outline),
            AccountInfoWidget('E-mail', user.email!, Icons.email_outlined),
            AccountInfoWidget(
                'Register On',
                DateFormat('dd MMM yyyy hh:mm a').format(
                  DateTime.parse(
                    user.metadata.creationTime.toString(),
                  ),
                ),
                Icons.new_label),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
