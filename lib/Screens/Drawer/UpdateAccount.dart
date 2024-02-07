import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/Screens/DrawerScreen/DeleteAccount.dart';
import 'package:nex_social/Screens/DrawerScreen/UpdatePassword.dart';
import 'package:nex_social/Screens/DrawerScreen/UpdateUserName.dart';
import 'package:nex_social/Screens/DrawerScreen/resetUserPassword.dart';
import 'package:nex_social/main.dart';

class UpdateAccount extends StatelessWidget {
  static const routeName = 'UpdateAccount';
  UpdateAccount({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  Widget button(String buttonText, IconData icon, VoidCallback todo) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: InkWell(
        onTap: () {
          todo();
        },
        borderRadius: BorderRadius.circular(17),
        splashColor: Colors.red,
        child: Container(
          //height: 144,
          height:
              MediaQuery.of(navigatorkey.currentContext!).size.height * 0.200,
          //width: 170,
          width: MediaQuery.of(navigatorkey.currentContext!).size.width * 0.435,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  icon,
                  size: 100,
                  color: Colors.white,
                ),
                FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    buttonText,
                    style: Theme.of(navigatorkey.currentContext!)
                        .textTheme
                        .titleSmall,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaObject = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Account Setting',
        ),
      ),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    //width: 180,
                    width: mediaObject.width * 0.47,
                    //height: 180,
                    height: mediaObject.height * 0.24,
                    child: Lottie.asset(
                      'assets/username.json',
                      fit: BoxFit.fitWidth,
                      repeat: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            user.displayName!,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          user.email!,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    button(
                      'Update UserName',
                      Icons.person,
                      () {
                        Navigator.of(context)
                            .pushNamed(UpdateUserName.routeName);
                      },
                    ),
                    button(
                      'Update Password',
                      Icons.lock,
                      () {
                        Navigator.of(context)
                            .pushNamed(UpdatePassword.routeName);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    button(
                      'Reset Password',
                      Icons.key,
                      () {
                        Navigator.of(context)
                            .pushNamed(ResetUserPassword.routeName)
                            .then(
                              (value) {},
                            );
                      },
                    ),
                    button(
                      'Delete Account',
                      Icons.delete,
                      () {
                        Navigator.of(context)
                            .pushNamed(DeleteAccount.routeName);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
