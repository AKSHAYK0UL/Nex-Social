import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';

class CommunityCreaterInfo extends StatelessWidget {
  static const routeName = 'CommunityCreaterInfo';
  CommunityCreaterInfo({super.key});
  Widget communityInfo(String text, String info) {
    return Row(
      children: [
        Chip(
          label: Text(text),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(info),
      ],
    );
  }

  Future<void> deleteCommunityDetail(
      BuildContext context, String communityName, String nodeID) async {
    showDialog(
      context: navigatorkey.currentContext!,
      builder: (contaxt) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await Provider.of<CommunityFunctionClass>(context, listen: false)
          .deleteCommunity(communityName, nodeID);

      navigatorkey.currentState!.pop();
      navigatorkey.currentState!.pop();
      navigatorkey.currentState!.pop();
      navigatorkey.currentState!.pop();
    } on FirebaseAuthException catch (_) {
      navigatorkey.currentState!.pop();
      Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
          .showError('Error', 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final CommunityData = ModalRoute.of(context)!.settings.arguments as Map;
    final communityName = CommunityData['Community name'];
    final adminName = CommunityData['admin name'];
    final commmunityDesp = CommunityData['commmunity desp'];
    final RegisterDate = CommunityData['Register Date'];
    final adminUID = CommunityData['admin uid'];
    final nodeID = CommunityData['node ID'];
    final firebaseAUTH = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Community Info'),
        actions: [
          firebaseAUTH!.uid == adminUID
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.black),
                          ),
                          content: const Text(
                            'Are you sure you want to delete this community',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await deleteCommunityDetail(
                                    context, communityName, nodeID);
                              },
                              child: Text('Yes'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                )
              : Text(''),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Lottie.asset(
              'assets/info.json',
            ),
          ),
          Column(
            children: [
              communityInfo('Adim Name', adminName),
              communityInfo(
                'Created On',
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(RegisterDate),
                ),
              ),
              communityInfo('Description', commmunityDesp),
              communityInfo('Other Communities', "From same user")
            ],
          ),
        ],
      ),
    );
  }
}
