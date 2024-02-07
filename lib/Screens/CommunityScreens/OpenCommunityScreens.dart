import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Model/CommunityPostModel.dart';
import 'package:nex_social/Model/FilePickAndUploadFunction.dart';
import 'package:nex_social/Screens/CommunityScreens/CommunityCreaterInfo.dart';
import 'package:nex_social/Screens/ImagePreviewAndUpload.dart';
import 'package:nex_social/Widget/Community/DisplayMessagesInCommunity.dart';
import 'package:nex_social/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class OpenCommunityScreens extends StatefulWidget {
  static const routeName = 'OpenCommunityScreens';
  OpenCommunityScreens({super.key});

  @override
  State<OpenCommunityScreens> createState() => _OpenCommunityScreensState();
}

class _OpenCommunityScreensState extends State<OpenCommunityScreens> {
  final _postController = TextEditingController();
  bool _istrue = true;
  bool _isloading = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_istrue) {
      setState(() {
        _isloading = true;
      });
      final CommunityData = ModalRoute.of(context)!.settings.arguments as Map;
      final CommunityNodeId = CommunityData['Community Node Id'];
      final communityName = CommunityData['Community name'];
      Provider.of<CommunityFunctionClass>(context, listen: true)
          .getFollow(communityName, user.uid);
      Provider.of<CommunityPostFunction>(context, listen: true)
          .getdata(CommunityNodeId!)
          .then((value) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isloading = false;
          });
        });
      });
      super.didChangeDependencies();
    }

    _istrue = false;
  }

  bool follows = false;
  void onFollow() {
    setState(() {
      follows = !follows;
    });
  }

  final user = FirebaseAuth.instance.currentUser!;

  String filePath = '';

  void getPermissionAndPickFile(String CommunityNodeId) async {
    var provider =
        Provider.of<FilePickAndUploadFunction>(context, listen: false);
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    if (deviceInfo.version.sdkInt >= 30) {
      await provider.getStoragePermission();
    }

    PermissionStatus status30 = await Permission.manageExternalStorage.status;
    if ((deviceInfo.version.sdkInt >= 30 && status30.isGranted) ||
        deviceInfo.version.sdkInt <= 29) {
      var value = await provider.pickFile();

      filePath = value.$1;

      if (filePath.isNotEmpty) {
        Navigator.of(navigatorkey.currentContext!).pushNamed(
          ImagePreviewAndUpload.routeName,
          arguments: {
            'Filepath': filePath,
            'FileName': value.$2,
            'CommunityNodeId': CommunityNodeId.toString(),
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postList =
        Provider.of<CommunityPostFunction>(context, listen: false).getAllPost;
    String _time = '';

    final _mediaQ = MediaQuery.of(context).size;
    final CommunityData = ModalRoute.of(context)!.settings.arguments as Map;
    final communityName = CommunityData['Community name'];
    final adminName = CommunityData['admin name'];
    final NodeIdForPOST = CommunityData['NodeIdForPOST'];
    final commmunityDesp = CommunityData['commmunity desp'];
    final RegisterDate = CommunityData['Register Date'];
    final CommunityNodeId = CommunityData['Community Node Id'];
    final adminUID = CommunityData['admin uid'];
    final requestlist = CommunityData['requestlist'];
    final accesslist = CommunityData['accesslist'];
    final cummunityType = CommunityData['communityType'];

    final ref = FirebaseDatabase.instance
        .ref()
        .child('CommunityPostData')
        .child(CommunityNodeId);
    final bool followStatus =
        Provider.of<CommunityFunctionClass>(context, listen: false).follow;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(communityName),
          actions: [
            TextButton(
              onPressed: () async {
                onFollow();
                await Provider.of<CommunityFunctionClass>(context,
                        listen: false)
                    .setFollow(communityName, user.uid, follows);
                CommunityModel foll = CommunityModel(
                  adminName: adminName,
                  adminUID: adminUID,
                  communityName: communityName,
                  communtiyDesp: commmunityDesp,
                  community_created_data: DateTime.parse(RegisterDate),
                  nodeId: CommunityNodeId,
                  accessList: accesslist,
                  requestList: requestlist,
                  communityType: cummunityType,
                );
                if (follows) {
                  await Provider.of<CommunityFunctionClass>(
                          navigatorkey.currentContext!,
                          listen: false)
                      .addToFollowCommunityList(foll, user.uid);
                } else {
                  await Provider.of<CommunityFunctionClass>(
                          navigatorkey.currentContext!,
                          listen: false)
                      .removeFromFollowCommunityList(
                          foll.communityName, user.uid);
                }
                Provider.of<CommunityFunctionClass>(
                        navigatorkey.currentContext!,
                        listen: false)
                    .getfollowedCommunityList;
              },
              child: Chip(
                backgroundColor: Colors.white,
                label: postList.isEmpty && _isloading
                    ? const Center(
                        heightFactor: 0.8,
                        widthFactor: 0.8,
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        followStatus ? 'Joined' : 'Join',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            ),
            IconButton(
              onPressed: () {
                print(adminUID);
                Navigator.of(context).pushNamed(
                  CommunityCreaterInfo.routeName,
                  arguments: {
                    'Community name': communityName,
                    'admin name': adminName,
                    'commmunity desp': commmunityDesp,
                    'Register Date': RegisterDate,
                    'admin uid': adminUID,
                    'node ID': CommunityNodeId,
                  },
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: postList.isEmpty && _isloading
                  ? SizedBox(
                      height: double.infinity,
                      child: Lottie.asset(
                        'assets/loadingchat.json',
                        fit: BoxFit.fill,
                      ),
                    )
                  : postList.isEmpty
                      ? SizedBox(
                          height: double.infinity,
                          child: Lottie.asset(
                            'assets/nochat.json',
                            fit: BoxFit.fill,
                          ),
                        )
                      : SingleChildScrollView(
                          reverse: true,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              //reverse: true,
                              // sort: (DataSnapshot a, DataSnapshot b) =>
                              //     b.key!.compareTo(a.key!),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              //query: ref,5
                              itemCount: postList.length,
                              itemBuilder: (context, index) {
                                final postInfo = postList[index];

                                String? decryptedMessage =
                                    Provider.of<CommunityPostFunction>(context,
                                            listen: false)
                                        .decryption(
                                  postInfo.postMessage!.toLowerCase(),
                                );
                                return DisplayMessagesInCommunity(
                                  name: postInfo.senderName,
                                  date: postInfo.postTime.toString(),
                                  uid: postInfo.senderUID,
                                  message: postInfo.postMessage ==
                                          'This post was deleted\u200B'
                                      ? 'This post was deleted\u200B'
                                      : decryptedMessage,
                                  nodeID: postInfo.nodeId,
                                  communityNodeId: CommunityNodeId,
                                  deletePostTime:
                                      postInfo.deletePostTime.toString(),
                                  mediaUrl: postInfo.mediaUrl!,
                                  likescount: postInfo.likes,
                                  comments: postInfo.comments,
                                );
                              }
                              // },
                              ),
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: followStatus
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    getPermissionAndPickFile(CommunityNodeId);
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.paperclip,
                                    size: 22,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                hintText: 'Post',
                                hintStyle:
                                    const TextStyle(color: Colors.black54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.blue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.black),
                                ),
                              ),
                              controller: _postController,
                              textInputAction: TextInputAction.newline,
                              minLines: 1,
                              maxLines: 4,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CircleAvatar(
                          foregroundColor: Colors.blue,
                          //radius: 28,
                          radius: _mediaQ.height * 0.036,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser!;
                              if (_postController.text.isNotEmpty) {
                                String message = _postController.text;
                                _postController.clear();
                                String encryptedMessage =
                                    Provider.of<CommunityPostFunction>(context,
                                            listen: false)
                                        .encryption(message);
                                await Provider.of<CommunityPostFunction>(
                                        context,
                                        listen: false)
                                    .onAddPost(
                                  user.displayName!,
                                  user.email!,
                                  user.uid,
                                  encryptedMessage,
                                  CommunityNodeId,
                                  '',
                                );
                              }
                              //Don't know what does this do 🤔🤔
                              await Provider.of<CommunityPostFunction>(
                                      navigatorkey.currentContext!,
                                      listen: false)
                                  .getdata(CommunityNodeId);
                            },
                            icon: const Icon(
                              Icons.send,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: Colors.black12,
                      child: Text(
                        'Join the community to post.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        Provider.of<CommunityPostFunction>(context, listen: false).clearall();

        Provider.of<CommunityPostFunction>(context, listen: false)
            .cleanTimevalue();
        return true;
      },
    );
  }
}
