import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Screens/CommunityScreens/OpenCommunityScreens.dart';
import 'package:provider/provider.dart';

class DrawerFORRecentANDJoined extends StatefulWidget {
  const DrawerFORRecentANDJoined({super.key});

  @override
  State<DrawerFORRecentANDJoined> createState() =>
      _DrawerFORRecentANDJoinedState();
}

class _DrawerFORRecentANDJoinedState extends State<DrawerFORRecentANDJoined> {
  Widget buildRecentViewed(BuildContext context) {
    String userID = FirebaseAuth.instance.currentUser!.uid;

    final dbquery =
        FirebaseDatabase.instance.ref().child('recentViewed').child(userID);

    final recentViewedcommunitydata =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .getRecentViewedCommunity();
    final recent = Provider.of<CommunityFunctionClass>(context, listen: false)
        .recentViewedList;
    return StreamBuilder(
      stream: recentViewedcommunitydata.asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Expanded(
            child: FirebaseAnimatedList(
              query: dbquery,
              itemBuilder: (context, snapshot, animation, index) {
                Provider.of<CommunityFunctionClass>(context)
                    .deleteRecentlyFromEveryUser(
                        snapshot.child('Community name').value.toString());
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          OpenCommunityScreens.routeName,
                          arguments: {
                            'NodeIdForPOST': (
                              snapshot
                                  .child('Community name')
                                  .value
                                  .toString()
                                  .trim()
                                  .toLowerCase(),
                            ),
                            'Community name': snapshot
                                .child('Community name')
                                .value
                                .toString(),
                            'admin name':
                                snapshot.child('admin name').value.toString(),
                            'admin uid':
                                snapshot.child('admin uid').value.toString(),
                            'commmunity desp': snapshot
                                .child('commmunity desp')
                                .value
                                .toString(),
                            'Register Date': snapshot
                                .child('Register Date')
                                .value
                                .toString(),
                            'Community Node Id': snapshot
                                .child('Community Node Id')
                                .value
                                .toString(),
                          },
                        );
                      },
                      title: Text(
                        snapshot.child('Community name').value.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Provider.of<CommunityFunctionClass>(context,
                                    listen: false)
                                .removeRecentViewed(snapshot
                                    .child('Community name')
                                    .value
                                    .toString());
                          },
                          icon: const Icon(Icons.cancel)),
                    ),
                    const Divider(
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.blue,
                    )
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }

  bool expand = false;
  Widget buildDropDown(BuildContext context, String text) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                expand = !expand;
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade400),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(
                      text,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    // width: 90,
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                  Icon(
                    expand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          if (expand)
            Container(
              child: buildRecentViewed(context),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            title: const Text('Activities'),
            automaticallyImplyLeading: false,
          ),

          // buildRecentViewed(context),
          buildDropDown(context, 'Recently viewed'),
        ],
      ),
    );
  }
}
