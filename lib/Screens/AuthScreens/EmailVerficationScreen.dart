import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Screens/CommunityScreens/AllCommunityListScreen.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class EmailVerficationScreen extends StatefulWidget {
  final User? snapshotDATA;
  EmailVerficationScreen(this.snapshotDATA);

  @override
  State<EmailVerficationScreen> createState() => _EmailVerficationScreenState();
}

class _EmailVerficationScreenState extends State<EmailVerficationScreen> {
  bool _isUserVerified = false;
  Timer? timer;
  Timer? countDownTimer;
  int totalTime = 100;
  void startTimer() {
    countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (totalTime == 0 && !_isUserVerified) {
          countDownTimer!.cancel();
          Future.delayed(
            Duration.zero,
            () {
              ();
            },
          ).then((value) => widget.snapshotDATA!.delete()).then((value) {
            Provider.of<AuthFunction>(context, listen: false).showError(
                'Verfication Error', 'Email verfication is not done in time');
          });
        } else {
          setState(() {
            totalTime--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _isUserVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    startTimer();
    if (!_isUserVerified) {
      Provider.of<AuthFunction>(context, listen: false)
          .verifyUserBYEmailVerification()
          .catchError(
        (error) {
          Provider.of<AuthFunction>(context, listen: false)
              .showError('EmailVerification Error', 'Something went wrong');
        },
      );
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        Provider.of<AuthFunction>(context, listen: false)
            .checkEmailverificationStatus()
            .then((value) {
          setState(() {
            _isUserVerified = value;
          });
        });
      });

      if (_isUserVerified) {
        timer!.cancel();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isUserVerified
        ? const AllCommunityListScreen()
        : Scaffold(
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  width: double.infinity,
                  child: LottieBuilder.asset(
                    'assets/emailverify.json',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Check your Email to verify it\'s you.\nRemaining time ${totalTime.toString()} sec.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: double.infinity,
                  // height: 45,
                  height: MediaQuery.of(context).size.height * 0.063,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      timer!.cancel();
                      widget.snapshotDATA!.delete();
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel verification'),
                  ),
                ),
              ],
            ),
          );
  }
}
