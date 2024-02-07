import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/main.dart';

class ResetUserPassword extends StatelessWidget {
  ResetUserPassword({super.key});
  static const routeName = 'ResetUserPassword';

  bool isVisible = false;

  Future<void> resetPassword() async {
    showDialog(
      context: navigatorkey.currentContext!,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: FirebaseAuth.instance.currentUser!.email!.trim(),
      )
          .then((value) {
        navigatorkey.currentState!.pop();
        // setState(() {
        //   isVisible = true;
        // });
      }).then((value) {
        showDialog(
          context: navigatorkey.currentContext!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                'Confirm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              content: const Text(
                  'Reset Password link has been send to your email.You have to LogIn again to see the changes'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    await FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        navigatorkey.currentState!.pop();
        showError('Invalid Email');
      }
    }
  }

  void showError(String error) {
    showDialog(
      context: navigatorkey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Error!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            error,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close  ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQ = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              SizedBox(
                height: _mediaQ.height * 0.810,
                width: double.infinity,
                child: Lottie.asset(
                  'assets/resetpassword.json',
                  fit: BoxFit.fitWidth,
                  repeat: false,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Visibility(
              //   visible: isVisible,
              //   child: const Text(
              //     'Reset Password link has been send to your email.',
              //     style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              SizedBox(
                width: double.infinity,
                // height: 45,
                height: _mediaQ.height * 0.063,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await resetPassword();
                  },
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
