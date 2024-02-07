// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:nex_social/main.dart';

class CommunityModel {
  final String adminName;
  final String communityName;
  final String communtiyDesp;
  final DateTime community_created_data;
  final String nodeId;
  final bool follow;
  final String adminUID;
  final List<dynamic> accessList;
  final List<dynamic> requestList;
  final String communityType;
  CommunityModel({
    required this.adminName,
    required this.communityName,
    required this.communtiyDesp,
    required this.community_created_data,
    required this.nodeId,
    this.follow = false,
    required this.adminUID,
    required this.accessList,
    required this.requestList,
    required this.communityType,
  });
}

class CommunityFunctionClass with ChangeNotifier {
  final databaseRef = FirebaseDatabase.instance.ref();
  String userID = FirebaseAuth.instance.currentUser!.uid;

  bool follow = false;
  List<CommunityModel> _communityDataList = [];
  List<CommunityModel> get getCommunityList {
    return [..._communityDataList];
  }

  List<CommunityModel> _followedCommunityList = [];

  bool checkIfCommunityNameIsAvaiable(String communityname) {
    final isAvaiable = _communityDataList.where((community) =>
        community.communityName.toLowerCase() == communityname.toLowerCase());
    return isAvaiable.isEmpty ? true : false;
  }

  Future<void> allCommunityNodeList(String adminname, String communityname,
      String communitydesp, String userUID, String type) async {
    try {
      String userName = FirebaseAuth.instance.currentUser!.displayName!;
      final communityNodeList = databaseRef.child('CommunityList').push();
      final nodeKey = communityNodeList.key;
      communityNodeList.set(
        {
          'Admin name': adminname,
          'Community name': communityname,
          'Community desp': communitydesp,
          'Community Register Date': DateTime.now().toString(),
          'Community Node Id': nodeKey,
          'Admin UID': userUID,
          'accesslist': [],
          'requestlist': [],
          'communityType': type,
        },
      );
      _communityDataList.add(
        CommunityModel(
          adminUID: userUID,
          adminName: adminname,
          communityName: communityname,
          communtiyDesp: communitydesp,
          community_created_data: DateTime.now(),
          nodeId: nodeKey!,
          follow: false,
          accessList: [userID],
          requestList: [],
          communityType: type,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> setFollow(String community, String userUid, bool follow) async {
    try {
      databaseRef.child('Follow/$community/$userUid').set({
        'bool': follow,
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getFollow(String community, String userUid) async {
    try {
      databaseRef.child('Follow/$community/$userUid').onValue.listen((event) {
        if (event.snapshot.value != null) {
          final followStatus = event.snapshot.value as Map<dynamic, dynamic>;

          follow = followStatus['bool'] == null
              ? false
              : followStatus['bool'] == false
                  ? false
                  : true;
        } else {
          follow = false;
        }

        notifyListeners();
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getAllCommunityList() async {
    try {
      databaseRef.child('CommunityList').onValue.listen(
        (event) {
          final communityListData =
              event.snapshot.value as Map<dynamic, dynamic>;
          if (event.snapshot.exists) {
            List<CommunityModel> loadedList = [];
            communityListData.forEach(
              (key, communityData) {
                loadedList.add(
                  CommunityModel(
                    adminName: communityData['Admin name'],
                    adminUID: communityData['Admin UID'],
                    communityName: communityData['Community name'],
                    communtiyDesp: communityData['Community desp'],
                    community_created_data: DateTime.parse(
                        communityData['Community Register Date']),
                    nodeId: key,
                    accessList: communityData['accesslist'] ?? [],
                    requestList: communityData['requestlist'] ?? [],
                    communityType: communityData['communityType'],
                  ),
                );
              },
            );
            _communityDataList = loadedList;
          }
          notifyListeners();
        },
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteCommunity(String communityName, String nodeID) async {
    try {
      await databaseRef.child('CommunityList').child(nodeID).remove();
      await databaseRef.child('CommunityPostData').child(nodeID).remove();
      await databaseRef.child('Follow').child(communityName).remove();

      await removeRecentViewed(communityName);

      await databaseRef
          .child('followCommunityListDB')
          .child(communityName)
          .remove();
      await databaseRef
          .child('followCommunityListDB')
          .child(communityName)
          .remove();
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  void showSnackBar(String textString) {
    ScaffoldMessenger.of(navigatorkey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          textString,
          style: Theme.of(navigatorkey.currentContext!).textTheme.titleSmall,
        ),
        duration: const Duration(seconds: 3),
        elevation: 0,
        padding: const EdgeInsets.all(17),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> storeDeviceToken(var token) async {
    final getnode = databaseRef.child('Devicetokens').push();
    final nodekey = getnode.key;
    try {
      await getnode.set({'token': token});
    } catch (e) {
      rethrow;
    }
  }

// when user follow a community it gets add to the follow community list

  Future<void> addToFollowCommunityList(
      CommunityModel followCommunity, String userID) async {
    final followCommunityListDB = databaseRef
        .child('followCommunityListDB')
        .child(userID)
        .child(followCommunity.communityName);

    try {
      await followCommunityListDB.set({
        'Admin name': followCommunity.adminName,
        'Community name': followCommunity.communityName,
        'Community desp': followCommunity.communtiyDesp,
        'Community Follow Date': DateTime.now().toString(),
        'Community Node Id': followCommunity.nodeId,
        'Admin UID': followCommunity.adminUID,
        'accesslist': followCommunity.accessList,
        'requestlist': followCommunity.requestList,
        'communityType': followCommunity.communityType,
      });
      _followedCommunityList.add(
        CommunityModel(
          adminName: followCommunity.adminName,
          adminUID: followCommunity.adminUID,
          communityName: followCommunity.communityName,
          communtiyDesp: followCommunity.communtiyDesp,
          community_created_data: followCommunity.community_created_data,
          nodeId: followCommunity.nodeId,
          accessList: followCommunity.accessList,
          requestList: followCommunity.requestList,
          communityType: followCommunity.communityType,
        ),
      );
    } catch (_) {
      rethrow;
    }
  }

  // fetching data using Firebase animated list

// when user unfollow a community it gets removed from the follow community list

  Future<void> removeFromFollowCommunityList(
      String _communityName, String userID) async {
    try {
      int index = _followedCommunityList
          .indexWhere((element) => element.communityName == _communityName);
      String cName = _followedCommunityList[index].communityName;

      _followedCommunityList.removeAt(index);
      await databaseRef
          .child('followCommunityListDB')
          .child(userID)
          .child(_communityName)
          .remove();
    } catch (_) {
      rethrow;
    }
  }

  List<CommunityModel> get getfollowedCommunityList {
    print(_followedCommunityList);
    return [..._followedCommunityList];
  }

  //Delete Joined Community from every user when that community is deleted by the admin
  Future<void> deleteJoinedFromEveryUser(String communityname) async {
    try {
      int x = getCommunityList.indexWhere((community) {
        return community.communityName == communityname;
      });

      print('VALUE X $x');
      if (x < 0) {
        await databaseRef
            .child('followCommunityListDB')
            .child(userID)
            .child(communityname)
            .remove();
      }
    } on FirebaseDatabase catch (e) {
      print(e.toString());
      rethrow;
    }
  }

//Store the searchResult in the Database
  Future<void> storeSearchHistory(CommunityModel community) async {
    try {
      databaseRef
          .child('searchHistory')
          .child(userID)
          .child(community.communityName)
          .set({
        'NodeIdForPOST': community.communityName.toLowerCase(),
        'Community name': community.communityName,
        'admin name': community.adminName,
        'admin uid': community.adminUID,
        'commmunity desp': community.communtiyDesp,
        'Register Date': community.community_created_data.toString(),
        'Community Node Id': community.nodeId,
        'accesslist': community.accessList,
        'requestlist': community.requestList,
        'communityType': community.communityType,
      });
      getSearchHistory();
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  List<CommunityModel> _searchHistoryList = [];
//Fetch the searchResult from the Database

  Future<void> getSearchHistory() async {
    print('GET HISTORY METHOD');
    try {
      databaseRef.child('searchHistory').child(userID).onValue.listen(
        (event) {
          if (event.snapshot.exists) {
            final searchHistoryList =
                event.snapshot.value as Map<dynamic, dynamic>;
            // print(searchHistoryList.toString());
            List<CommunityModel> searchList = [];
            searchHistoryList.forEach(
              (key, value) {
                searchList.add(
                  CommunityModel(
                    adminName: value['admin name'].toString(),
                    adminUID: value['admin uid'].toString(),
                    communityName: value['Community name'].toString(),
                    communtiyDesp: value['commmunity desp'].toString(),
                    community_created_data:
                        DateTime.parse(value['Register Date']),
                    nodeId: value['Community Node Id'].toString(),
                    accessList: value['accesslist'] ?? [],
                    requestList: value['requestlist'] ?? [],
                    communityType: value['communityType'],
                  ),
                );
              },
            );
            _searchHistoryList = searchList;
            notifyListeners();
          }
        },
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  List<CommunityModel> get searchHistory {
    return [..._searchHistoryList];
  }

  Future<void> removeHistory(String communityName) async {
    try {
      databaseRef
          .child('searchHistory')
          .child(userID)
          .child(communityName)
          .remove()
          .then(
        (_) {
          int index = _searchHistoryList
              .indexWhere((element) => element.communityName == communityName);
          _searchHistoryList.removeAt(index);
        },
      );
      getSearchHistory();
      notifyListeners();
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

// store recent view community
  Future<void> storeRecentViewedCommunity(CommunityModel community) async {
    databaseRef
        .child('recentViewed')
        .child(userID)
        .child(community.communityName)
        .set(
      {
        'NodeIdForPOST': community.communityName.toLowerCase(),
        'Community name': community.communityName,
        'admin name': community.adminName,
        'admin uid': community.adminUID,
        'commmunity desp': community.communtiyDesp,
        'Register Date': community.community_created_data.toString(),
        'Community Node Id': community.nodeId,
        'accesslist': community.accessList,
        'requestlist': community.requestList,
        'communityType': community.communityType,
      },
    );
  }

  // recent community list
  List<CommunityModel> recentViewedCommunityList = [];

// fetch recent community
  Future<void> getRecentViewedCommunity() async {
    try {
      databaseRef.child('recentViewed').child(userID).onValue.listen(
        (event) {
          if (event.snapshot.exists) {
            List<CommunityModel> recentlist = [];
            final recentViewedCommunity =
                event.snapshot.value as Map<dynamic, dynamic>;
            recentViewedCommunity.forEach(
              (key, value) {
                recentlist.add(
                  CommunityModel(
                    adminName: value['admin name'].toString(),
                    adminUID: value['admin uid'].toString(),
                    communityName: value['Community name'].toString(),
                    communtiyDesp: value['commmunity desp'].toString(),
                    community_created_data:
                        DateTime.parse(value['Register Date']),
                    nodeId: value['Community Node Id'].toString(),
                    accessList: value['accesslist'],
                    requestList: value['requestlist'],
                    communityType: value['communityType'],
                  ),
                );
              },
            );
            recentViewedCommunityList = recentlist;
            notifyListeners();
          }
        },
      );
    } on FirebaseException catch (_) {}
  }

// remove recent view community
  Future<void> removeRecentViewed(String communityName) async {
    try {
      databaseRef
          .child('recentViewed')
          .child(userID)
          .child(communityName)
          .remove()
          .then(
        (_) {
          int index = recentViewedCommunityList
              .indexWhere((element) => element.communityName == communityName);
          recentViewedCommunityList.removeAt(index);
        },
      );
      getRecentViewedCommunity();
      notifyListeners();
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

//Remove recently viewed from all users
  Future<void> deleteRecentlyFromEveryUser(String communityname) async {
    try {
      int x = getCommunityList.indexWhere((community) {
        return community.communityName == communityname;
      });

      print('VALUE X $x');
      if (x < 0) {
        await databaseRef
            .child('recentViewed')
            .child(userID)
            .child(communityname)
            .remove();
      }
    } on FirebaseDatabase catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // recent viewed community list
  List<CommunityModel> get recentViewedList {
    return [...recentViewedCommunityList];
  }

//send Request to access community
  Future<void> sendRequest(String communityName) async {
    final userName = FirebaseAuth.instance.currentUser!.displayName!;
    try {
      final communityToSendRequest = _communityDataList
          .firstWhere((comm) => comm.communityName == communityName);

      final communityNodeId = communityToSendRequest.nodeId;
      final List<dynamic> requestList =
          communityToSendRequest.requestList.toList();
      requestList.add(userName);

      databaseRef.child('CommunityList').child(communityNodeId).update(
        {
          'Admin name': communityToSendRequest.adminName,
          'Community name': communityToSendRequest.communityName,
          'Community desp': communityToSendRequest.communtiyDesp,
          'Community Register Date':
              communityToSendRequest.community_created_data.toString(),
          'Community Node Id': communityToSendRequest.nodeId,
          'Admin UID': communityToSendRequest.adminUID,
          'accesslist': communityToSendRequest.accessList,
          'requestlist': requestList,
          'communityType': communityToSendRequest.communityType,
        },
      );
      _communityDataList.add(
        CommunityModel(
          adminUID: communityToSendRequest.adminUID,
          adminName: communityToSendRequest.adminName,
          communityName: communityToSendRequest.communityName,
          communtiyDesp: communityToSendRequest.communtiyDesp,
          community_created_data: communityToSendRequest.community_created_data,
          nodeId: communityToSendRequest.nodeId,
          follow: communityToSendRequest.follow,
          accessList: communityToSendRequest.accessList,
          requestList: requestList,
          communityType: communityToSendRequest.communityType,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

// Accept request
  Future<void> acceptRequest(String communityName, String userName) async {
    try {
      final communityToSendRequest = _communityDataList
          .firstWhere((comm) => comm.communityName == communityName);

      final communityNodeId = communityToSendRequest.nodeId;

      final reqList = communityToSendRequest.requestList.toList();
      reqList.removeWhere((element) => element == userName);

      print("requestList $reqList");

      final List<dynamic> accessList =
          communityToSendRequest.accessList.toList();
      accessList.add(userName);

      databaseRef.child('CommunityList').child(communityNodeId).update(
        {
          'Admin name': communityToSendRequest.adminName,
          'Community name': communityToSendRequest.communityName,
          'Community desp': communityToSendRequest.communtiyDesp,
          'Community Register Date':
              communityToSendRequest.community_created_data.toString(),
          'Community Node Id': communityToSendRequest.nodeId,
          'Admin UID': communityToSendRequest.adminUID,
          'accesslist': accessList,
          'requestlist': reqList ?? [],
          'communityType': communityToSendRequest.communityType,
        },
      );
      _communityDataList.add(
        CommunityModel(
          adminUID: communityToSendRequest.adminUID,
          adminName: communityToSendRequest.adminName,
          communityName: communityToSendRequest.communityName,
          communtiyDesp: communityToSendRequest.communtiyDesp,
          community_created_data: communityToSendRequest.community_created_data,
          nodeId: communityToSendRequest.nodeId,
          follow: communityToSendRequest.follow,
          accessList: accessList,
          requestList: reqList ?? [],
          communityType: communityToSendRequest.communityType,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  //Reject request
  Future<void> rejectRequest(String communityName, String userName) async {
    try {
      final communityToSendRequest = _communityDataList
          .firstWhere((comm) => comm.communityName == communityName);

      final communityNodeId = communityToSendRequest.nodeId;

      final reqList = communityToSendRequest.requestList.toList();
      reqList.removeWhere((element) => element == userName);

      databaseRef.child('CommunityList').child(communityNodeId).update(
        {
          'Admin name': communityToSendRequest.adminName,
          'Community name': communityToSendRequest.communityName,
          'Community desp': communityToSendRequest.communtiyDesp,
          'Community Register Date':
              communityToSendRequest.community_created_data.toString(),
          'Community Node Id': communityToSendRequest.nodeId,
          'Admin UID': communityToSendRequest.adminUID,
          'accesslist': communityToSendRequest.accessList,
          'requestlist': reqList ?? [],
          'communityType': communityToSendRequest.communityType,
        },
      );
      _communityDataList.add(
        CommunityModel(
          adminUID: communityToSendRequest.adminUID,
          adminName: communityToSendRequest.adminName,
          communityName: communityToSendRequest.communityName,
          communtiyDesp: communityToSendRequest.communtiyDesp,
          community_created_data: communityToSendRequest.community_created_data,
          nodeId: communityToSendRequest.nodeId,
          follow: communityToSendRequest.follow,
          accessList: communityToSendRequest.accessList,
          requestList: reqList ?? [],
          communityType: communityToSendRequest.communityType,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  // Remove acceess
  Future<void> removeAccess(String communityName, String userName) async {
    try {
      final communityToSendRequest = _communityDataList
          .firstWhere((comm) => comm.communityName == communityName);

      final communityNodeId = communityToSendRequest.nodeId;

      final accList = communityToSendRequest.accessList.toList();
      accList.removeWhere((element) => element == userName);

      databaseRef.child('CommunityList').child(communityNodeId).update(
        {
          'Admin name': communityToSendRequest.adminName,
          'Community name': communityToSendRequest.communityName,
          'Community desp': communityToSendRequest.communtiyDesp,
          'Community Register Date':
              communityToSendRequest.community_created_data.toString(),
          'Community Node Id': communityToSendRequest.nodeId,
          'Admin UID': communityToSendRequest.adminUID,
          'accesslist': accList ?? [],
          'requestlist': communityToSendRequest.requestList,
          'communityType': communityToSendRequest.communityType,
        },
      );
      _communityDataList.add(
        CommunityModel(
          adminUID: communityToSendRequest.adminUID,
          adminName: communityToSendRequest.adminName,
          communityName: communityToSendRequest.communityName,
          communtiyDesp: communityToSendRequest.communtiyDesp,
          community_created_data: communityToSendRequest.community_created_data,
          nodeId: communityToSendRequest.nodeId,
          follow: communityToSendRequest.follow,
          accessList: accList ?? [],
          requestList: communityToSendRequest.requestList,
          communityType: communityToSendRequest.communityType,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}
