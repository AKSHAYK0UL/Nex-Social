import 'package:flutter/material.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:provider/provider.dart';

class UserAccessListAndrequestList extends StatefulWidget {
  static const routeName = 'UserAccessListAndrequestList';
  UserAccessListAndrequestList({super.key});

  @override
  State<UserAccessListAndrequestList> createState() =>
      _UserAccessListAndrequestListState();
}

class _UserAccessListAndrequestListState
    extends State<UserAccessListAndrequestList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final communityName = ModalRoute.of(context)!.settings.arguments as String;
    final communityList =
        Provider.of<CommunityFunctionClass>(context, listen: true)
            .getCommunityList;

    final currentCommunity = communityList.firstWhere(
      (comm) => comm.communityName == communityName,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control access'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _currentIndex == 0
            ? currentCommunity.accessList.length
            : currentCommunity.requestList.length,
        itemBuilder: (context, index) {
          final userName = _currentIndex == 0
              ? currentCommunity.accessList[index]
              : currentCommunity.requestList[index];
          return Column(
            children: [
              ListTile(
                minVerticalPadding: 23.5,
                tileColor: Colors.grey.shade400,
                title: Text(userName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Provider.of<CommunityFunctionClass>(context,
                                listen: false)
                            .acceptRequest(communityName, userName);
                      },
                      icon: _currentIndex == 1
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Text(''),
                    ),
                    IconButton(
                      onPressed: () {
                        print('HLLLL');
                        _currentIndex == 0
                            ? Provider.of<CommunityFunctionClass>(
                                context,
                                listen: false,
                              ).removeAccess(communityName, userName)
                            : Provider.of<CommunityFunctionClass>(context,
                                    listen: false)
                                .rejectRequest(communityName, userName);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Request',
            ),
          ]),
    );
  }
}
