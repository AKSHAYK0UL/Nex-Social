import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:provider/provider.dart';

class RequestForAccess extends StatefulWidget {
  static const routeName = 'RequestForAccess';
  const RequestForAccess({Key? key}) : super(key: key);

  @override
  State<RequestForAccess> createState() => _RequestForAccessState();
}

class _RequestForAccessState extends State<RequestForAccess> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final communityName = ModalRoute.of(context)!.settings.arguments as String;
    final communityList =
        Provider.of<CommunityFunctionClass>(context, listen: true)
            .getCommunityList;

    final currentCommunity = communityList.firstWhere(
      (comm) => comm.communityName == communityName,
    );

    int index = currentCommunity.requestList
        .indexWhere((name) => name == user.displayName);

    return Scaffold(
      appBar: AppBar(
        title: Text(communityName),
        elevation: 0,
      ),
      body: Center(
        child: index == -1
            ? ElevatedButton(
                onPressed: () {
                  Provider.of<CommunityFunctionClass>(context, listen: false)
                      .sendRequest(communityName)
                      .then((_) {});
                },
                child: const Text('Send Request'),
              )
            : const Text('Requested'),
      ),
    );
  }
}
