import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Screens/CommunityScreens/OpenCommunityScreens.dart';
import 'package:provider/provider.dart';

class YourCommunities extends StatelessWidget {
  static const routeName = 'YourCommunities';

  const YourCommunities({super.key});

  @override
  Widget build(BuildContext context) {
    String userid = FirebaseAuth.instance.currentUser!.uid;

    final _query =
        FirebaseDatabase.instance.ref('followCommunityListDB').child(userid);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Joined Communities'),
      ),
      body: FutureBuilder(
        future: fetchData(_query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return FirebaseAnimatedList(
              query: _query,
              itemBuilder: (context, snapshot, animation, index) {
                Provider.of<CommunityFunctionClass>(context)
                    .deleteJoinedFromEveryUser(
                        snapshot.child('Community name').value.toString());
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      OpenCommunityScreens.routeName,
                      arguments: {
                        'NodeIdForPOST': (
                          snapshot
                              .child('Community Node Id')
                              .value
                              .toString()
                              .trim()
                              .toLowerCase(),
                        ),
                        'Community name':
                            snapshot.child('Community name').value.toString(),
                        'admin name':
                            snapshot.child('Admin name').value.toString(),
                        'admin uid':
                            snapshot.child('Admin UID').value.toString(),
                        'commmunity desp':
                            snapshot.child('Community desp').value.toString(),
                        'Register Date': snapshot
                            .child('Community Follow Date')
                            .value
                            .toString(),
                        'Community Node Id': snapshot
                            .child('Community Node Id')
                            .value
                            .toString(),
                      },
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Center(
                          child: Text(snapshot
                              .child('Community name')
                              .value
                              .toString()[0])),
                    ),
                    title:
                        Text(snapshot.child('Community name').value.toString()),
                    subtitle:
                        Text(snapshot.child('Community desp').value.toString()),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to fetch data from Firebase
  Future<void> fetchData(DatabaseReference query) async {
    await query.once();
  }
}
