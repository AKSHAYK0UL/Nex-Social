import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Screens/CommunityScreens/DrawerFORRecentANDJoined.dart';
import 'package:nex_social/Screens/CommunityScreens/OpenCommunityScreens.dart';
import 'package:nex_social/Screens/RequestForAccess.dart';
import 'package:nex_social/Widget/drawerForUserInfo.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';

List<dynamic> accessListOfUsers = [];
List<dynamic> requestListOfUsers = [];

class AllCommunityListScreen extends StatefulWidget {
  static const routeName = 'AllCommunityListScreen';
  const AllCommunityListScreen({super.key});

  @override
  State<AllCommunityListScreen> createState() => _AllCommunityListScreenState();
}

class _AllCommunityListScreenState extends State<AllCommunityListScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  bool _istrue = true;
  @override
  void didChangeDependencies() {
    if (_istrue) {
      Provider.of<CommunityFunctionClass>(context, listen: true)
          .getAllCommunityList();
      Provider.of<CommunityFunctionClass>(context, listen: false)
          .getSearchHistory();
    }
    _istrue = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final communityList =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .getCommunityList;

    return communityList.isEmpty
        ? SizedBox(
            height: double.infinity,
            child: Lottie.asset('assets/loading.json', fit: BoxFit.fill),
          )
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              title: const Text('Communities'),
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CommunitySearch(),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(drawerForUserInfo.routeName);
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 28,
                  ),
                ),
              ],
            ),
            drawer: const DrawerFORRecentANDJoined(),
            body: Container(
              height: 500,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                //query: ref,
                itemCount: communityList.length,
                itemBuilder: (context, index) {
                  final communityListdata = communityList[index];
                  print('ACCESSLIST : ${communityListdata.accessList}');

                  return GestureDetector(
                    onTap: () {
                      final youHaveAccessIndex =
                          communityListdata.accessList.indexWhere(
                        (username) => username == user!.displayName!,
                      );

                      if (youHaveAccessIndex != -1 ||
                          (communityListdata.adminName == user!.displayName! ||
                              communityListdata.communityType == 'Public')) {
                        Provider.of<CommunityFunctionClass>(context,
                                listen: false)
                            .storeRecentViewedCommunity(
                          CommunityModel(
                            adminName: communityListdata.adminName,
                            adminUID: communityListdata.adminUID,
                            communityName: communityListdata.communityName,
                            communtiyDesp: communityListdata.communtiyDesp,
                            community_created_data:
                                communityListdata.community_created_data,
                            nodeId: communityListdata.nodeId,
                            accessList: communityListdata.accessList,
                            requestList: communityListdata.requestList,
                            communityType: communityListdata.communityType,
                          ),
                        );

                        Navigator.of(context).pushNamed(
                          OpenCommunityScreens.routeName,
                          arguments: {
                            'NodeIdForPOST': (
                              communityListdata.communityName
                                  .toString()
                                  .trim()
                                  .toLowerCase(),
                            ),
                            'Community name':
                                communityListdata.communityName.toString(),
                            'admin name': communityListdata.adminName,
                            'admin uid': communityListdata.adminUID,
                            'commmunity desp': communityListdata.communtiyDesp,
                            'Register Date': communityListdata
                                .community_created_data
                                .toString(),
                            'Community Node Id':
                                communityListdata.nodeId.toString(),
                            'accesslist': communityListdata.accessList,
                            'requestlist': communityListdata.requestList,
                            'communityType': communityListdata.communityType,
                          },
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                            RequestForAccess.routeName,
                            arguments: communityListdata.communityName);
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Center(
                            child: Text(
                                communityListdata.communityName.toString()[0])),
                      ),
                      title: Text(communityListdata.communityName.toString()),
                      subtitle:
                          Text(communityListdata.communtiyDesp.toString()),
                    ),
                  );
                },
              ),
            ),
          );
  }
}

//Search
class CommunitySearch extends SearchDelegate<CommunityModel?> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.black),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('');
  }

  @override
  void showResults(BuildContext context) {
    final communityList =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .getCommunityList;

    var searchSuggestion = query.isEmpty
        ? 'NO SUGGESTION'
        : communityList.where(
            (community) {
              final communityname = community.communityName.toLowerCase();
              final searchName = query.toLowerCase();

              return communityname.startsWith(searchName);
            },
          ).toList();
    List<CommunityModel> sugg = searchSuggestion as List<CommunityModel>;
    int index = sugg[0]
        .accessList
        .indexWhere((accessName) => accessName == user.displayName!);
    Provider.of<CommunityFunctionClass>(navigatorkey.currentContext!,
            listen: false)
        .storeSearchHistory(
      CommunityModel(
        adminName: sugg[0].adminName,
        adminUID: sugg[0].adminUID,
        communityName: sugg[0].communityName,
        communtiyDesp: sugg[0].communtiyDesp,
        community_created_data: sugg[0].community_created_data,
        nodeId: sugg[0].nodeId,
        accessList: sugg[0].accessList,
        requestList: sugg[0].requestList,
        communityType: sugg[0].communityType,
      ),
    );
    query.isEmpty
        ? const Center(
            child: Text('NO SUGGESTION'),
          )
        : index != -1 ||
                sugg[0].adminName == user.displayName ||
                sugg[0].communityType == 'Public'
            ? Navigator.of(context).pushNamed(
                OpenCommunityScreens.routeName,
                arguments: {
                  'NodeIdForPOST': (
                    sugg[0].communityName.toString().trim().toLowerCase(),
                  ),
                  'Community name': sugg[0].communityName.toString(),
                  'admin name': sugg[0].adminName,
                  'admin uid': sugg[0].adminUID,
                  'commmunity desp': sugg[0].communtiyDesp,
                  'Register Date': sugg[0].community_created_data.toString(),
                  'Community Node Id': sugg[0].nodeId.toString(),
                  'accesslist': sugg[0].accessList,
                  'requestlist': sugg[0].requestList,
                  'communityType': sugg[0].communityType,
                },
              )
            : Navigator.of(context).pushNamed(
                RequestForAccess.routeName,
                arguments: sugg[0].communityName,
              );

    query = '';
    super.showResults(context);

    // Provider.of<CommunityFunctionClass>(navigatorkey.currentContext!,
    //         listen: false)
    //     .storeSearchHistory(
    //   CommunityModel(
    //     adminName: sugg[0].adminName,
    //     adminUID: sugg[0].adminUID,
    //     communityName: sugg[0].communityName,
    //     communtiyDesp: sugg[0].communtiyDesp,
    //     community_created_data: sugg[0].community_created_data,
    //     nodeId: sugg[0].nodeId,
    //     accessList: sugg[0].accessList,
    //     requestList: sugg[0].requestList,
    //   ),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final communityList =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .getCommunityList;
    var searchSuggestion = query.isEmpty
        ? 'NO SUGGESTION'
        : communityList.where((community) {
            final communityname = community.communityName.toLowerCase();
            final searchName = query.toLowerCase();
            return communityname.startsWith(searchName);
            // return communityname.contains(searchName);
          }).toList();
    return sugesstionSucess(context, searchSuggestion);
  }

  Widget sugesstionSucess(BuildContext context, var suggestion) {
    final searchList =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .searchHistory;
    print("ABCDERFEEFF ${searchList}");
    return suggestion == 'NO SUGGESTION' && searchList.isNotEmpty
        ? buildSearchHistory(searchList)
        : suggestion == 'NO SUGGESTION' && searchList.isEmpty
            ? Center(
                child: Text(
                  'No suggestion',
                  style: Theme.of(navigatorkey.currentContext!)
                      .textTheme
                      .titleMedium,
                ),
              )
            : ListView.builder(
                itemCount: suggestion.length,
                itemBuilder: (context, index) {
                  final sugg = suggestion[index] as CommunityModel;
                  final queryText =
                      sugg.communityName.substring(0, query.length);
                  final remainingText =
                      sugg.communityName.substring(query.length);
                  return ListTile(
                    onTap: () {
                      query = sugg.communityName;
                      showResults(context);
                    },
                    leading: CircleAvatar(
                      child: Text(queryText[0]),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: queryText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: remainingText,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }

  Widget buildSearchHistory(List<CommunityModel> history) {
    String userID = FirebaseAuth.instance.currentUser!.uid;

    final dbquery =
        FirebaseDatabase.instance.ref().child('searchHistory').child(userID);
    final sH = Provider.of<CommunityFunctionClass>(navigatorkey.currentContext!,
            listen: false)
        .getSearchHistory();
    return StreamBuilder(
      stream: sH.asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return FirebaseAnimatedList(
          query: dbquery,
          itemBuilder: (context, snapshot, animation, index) {
            return ListTile(
              onTap: () {
                query = snapshot.child('Community name').value.toString();
                showResults(context);
              },
              leading: const CircleAvatar(
                child: Icon(Icons.history),
              ),
              title: Text(
                snapshot.child('Community name').value.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Provider.of<CommunityFunctionClass>(context, listen: false)
                      .removeHistory(
                          snapshot.child('Community name').value.toString());
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
