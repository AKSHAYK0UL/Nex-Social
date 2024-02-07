import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Screens/UserAccessListAndrequestList.dart';
import 'package:provider/provider.dart';

class AccessAndRequest extends StatelessWidget {
  static const routeName = 'AccessAndRequest';
  const AccessAndRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final communitylist =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .getCommunityList;
    final currentUserCommunityList = communitylist
        .where((community) => community.adminUID == user.uid)
        .toList();
    final listWithOutPublic = currentUserCommunityList
        .where((commList) => commList.communityType != 'Public')
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Center'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: listWithOutPublic.length,
        itemBuilder: (context, index) {
          final community = listWithOutPublic[index];
          return Column(
            children: [
              ListTile(
                minVerticalPadding: 22,
                tileColor: Colors.grey.shade400,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    UserAccessListAndrequestList.routeName,
                    arguments: community.communityName,
                  );
                },
                leading: CircleAvatar(
                  radius: 22,
                  child: Text(
                    community.communityName[0],
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                ),
                title: Text(
                  community.communityName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
