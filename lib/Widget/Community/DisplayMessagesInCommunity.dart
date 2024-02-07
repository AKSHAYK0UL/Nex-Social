import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Model/CommunityPostModel.dart';
import 'package:nex_social/Screens/CommunityScreens/CommentScreen.dart';
import 'package:nex_social/Screens/FullScreenImage.dart';
import 'package:nex_social/main.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisplayMessagesInCommunity extends StatefulWidget {
  final String nodeID;
  final String name;
  final String date;
  final String message;
  final String uid;
  final String communityNodeId;
  final String deletePostTime;
  final String mediaUrl;
  final List<dynamic> likescount;
  final List<dynamic> comments;

  DisplayMessagesInCommunity({
    required this.communityNodeId,
    required this.nodeID,
    required this.name,
    required this.date,
    required this.uid,
    required this.message,
    required this.deletePostTime,
    required this.mediaUrl,
    required this.likescount,
    required this.comments,
  });

  @override
  State<DisplayMessagesInCommunity> createState() =>
      _DisplayMessagesInCommunityState();
}

class _DisplayMessagesInCommunityState
    extends State<DisplayMessagesInCommunity> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final currentUsername = FirebaseAuth.instance.currentUser!.displayName;
  bool _sameDateTime = false;
  bool _notSameDateTime = false;

  void checkTime() {
    final currentDate = DateFormat('dd MMM yy').format(DateTime.now());
    final postDate =
        DateFormat('dd MMM yy').format(DateTime.parse(widget.date));

    bool _timeValue = Provider.of<CommunityPostFunction>(context, listen: false)
        .checkTime(DateFormat('dd MMM yy').format(DateTime.parse(widget.date)));
    if (_timeValue) {
      if (currentDate == postDate) {
        setState(() {
          _sameDateTime = true;
        });
      } else {
        setState(() {
          _notSameDateTime = true;
        });
      }
    }
  }

  Future<void> deletePost() async {
    try {
      await Provider.of<CommunityPostFunction>(context, listen: false)
          .deletePost(widget.communityNodeId, widget.nodeID);
      setState(() {});
    } on FirebaseException catch (error) {
      Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
          .showError('Delete Error', error.code);
    }
  }

  var controller;
  void player() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        widget.message,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: true,
        ),
      ),
    )..initialise();
  }

  bool isLiked = false;
  @override
  void initState() {
    int deletePostDate = int.parse(
        DateFormat('ddMMyyyy').format(DateTime.parse(widget.deletePostTime)));
    int currentdate = int.parse(DateFormat('ddMMyyyy')
        .format(DateTime.parse(DateTime.now().toString())));

    if (widget.message
            .toLowerCase()
            .contains('This post was deleted\u200B'.toLowerCase()) &&
        deletePostDate < currentdate) {
      Provider.of<CommunityPostFunction>(context, listen: false)
          .deletePost(widget.communityNodeId, widget.nodeID);
    }

    checkTime();

    super.initState();
  }

  bool copyOption = false;

  TextStyle message = const TextStyle(
    color: Colors.black,
    fontSize: 17.5,
    fontWeight: FontWeight.normal,
  );
  TextStyle deleteMessage = const TextStyle(
    color: Colors.red,
    fontSize: 17.5,
    fontWeight: FontWeight.normal,
  );

//Icon Botton

  // Widget buildLikeButton(IconData icon) {
  //   final onTapLikeButtoon =
  //       Provider.of<CommunityPostFunction>(context, listen: false).tapOnLike(
  //     widget.nodeID,
  //     widget.communityNodeId,
  //   );

  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       IconButton(
  //         onPressed: () {
  //           onTapLikeButtoon;
  //         },
  //         icon: Icon(icon),
  //       ),
  //       Text('${widget.likescount.length}'),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final likebutton =
    //     Provider.of<CommunityPostFunction>(context, listen: false).tapOnLike(
    //   widget.nodeID,
    //   widget.communityNodeId,
    // );
    final userId = FirebaseAuth.instance.currentUser!.uid;

    bool likes = widget.likescount.contains(userId);
    print(likes);
    if (likes) {
      setState(() {
        isLiked = true;
      });
    } else {
      setState(() {
        isLiked = false;
      });
    }
    print(widget.likescount.length);
    final _mediaQ = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: _sameDateTime,
          child: Chip(
            backgroundColor: Colors.blue.shade400,
            label: Text(
              'Today',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        Visibility(
          visible: _notSameDateTime,
          child: Chip(
            backgroundColor: Colors.blue.shade400,
            label: Text(
              DateFormat('dd MMM yy').format(
                DateTime.parse(widget.date),
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // margin: currentUserUid == widget.uid
          //     ? const EdgeInsets.only(left: 100, bottom: 10)
          //     : const EdgeInsets.only(right: 100, bottom: 10),
          // padding: currentUserUid == widget.uid
          //     ? const EdgeInsets.only(right: 8.0)
          //     : const EdgeInsets.only(left: 8.0),
          child: Dismissible(
            key: ValueKey(widget.nodeID),
            direction: currentUserUid == widget.uid &&
                    !(widget.message
                        .toLowerCase()
                        .contains('This post was deleted\u200B'.toLowerCase()))
                ? DismissDirection.endToStart
                : DismissDirection.none,
            onDismissed: currentUserUid == widget.uid
                ? (direction) async {
                    // await Provider.of<CommunityPostFunction>(context,
                    //         listen: false)
                    //     .deletePost(widget.communityNodeId, widget.nodeID);
                  }
                : null,
            confirmDismiss: currentUserUid == widget.uid
                ? (direction) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          title: Text(
                            "Are You Sure?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          content: const Text(
                            "Are you sure you want to delete this Post?",
                            style: TextStyle(
                              fontSize: 17.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                "No",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(false);

                                await Provider.of<CommunityPostFunction>(
                                        context,
                                        listen: false)
                                    .messageDeletePost(
                                        widget.communityNodeId, widget.nodeID);
                              },
                              child: Text(
                                "Yes",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.3),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    copyOption = false;
                  },
                );
              },
              onLongPress: widget.message.isEmpty ||
                      widget.message.contains('This post was deleted\u200B')
                  ? null
                  : () {
                      setState(
                        () {
                          copyOption = true;
                        },
                      );
                    },
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: currentUserUid == widget.uid
                        ? const Radius.circular(14)
                        : const Radius.circular(0),
                    bottomLeft: const Radius.circular(14),
                    bottomRight: const Radius.circular(14),
                    topRight: currentUserUid == widget.uid
                        ? const Radius.circular(0)
                        : const Radius.circular(14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentUserUid == widget.uid
                                  ? 'You'
                                  : widget.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            copyOption
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        copyOption = false;
                                      });
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: widget.message,
                                        ),
                                      );
                                      Provider.of<CommunityFunctionClass>(
                                              navigatorkey.currentContext!,
                                              listen: false)
                                          .showSnackBar('Copied to Clipboard');
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                  )
                                : widget.message.toLowerCase().contains(
                                        'This post was deleted\u200B'
                                            .toLowerCase())
                                    ? Row(
                                        children: [
                                          Text(
                                            DateFormat('hh:mm a').format(
                                              DateTime.parse(widget.date),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            '|',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a').format(
                                              DateTime.parse(
                                                  widget.deletePostTime),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    : Text(
                                        DateFormat('hh:mm a').format(
                                          DateTime.parse(widget.date),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                          ],
                        ),
                      ),
                      // const Divider(
                      //   indent: 12,
                      //   endIndent: 13,
                      //   thickness: 2,
                      //   color: Colors.black54,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                        //rounded edges
                        child: widget.mediaUrl.contains('.png') ||
                                widget.mediaUrl.contains('.jpg') ||
                                widget.mediaUrl.contains('.jpeg')
                            ? Column(
                                children: [
                                  if (widget.message.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 10),
                                      child: Text(
                                        widget.message,
                                        style: message,
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: widget.mediaUrl.contains('.png') ||
                                            widget.mediaUrl.contains('.jpg') ||
                                            widget.mediaUrl.contains('.jpeg')
                                        ? () {
                                            Navigator.of(context).pushNamed(
                                              FullScreenImage.routeName,
                                              arguments: {
                                                'ImageUrl': widget.mediaUrl,
                                                'Tag': widget.date
                                              },
                                            );
                                          }
                                        : null,
                                    child: Hero(
                                      tag: widget.date,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.mediaUrl,
                                        placeholder: (context, url) {
                                          return Image.network(
                                            widget.mediaUrl,
                                            width: double.infinity,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Stack(
                                                  children: [
                                                    Image.asset(
                                                      'assets/newimageloading.png',
                                                    ),
                                                    Positioned(
                                                      top: _mediaQ.height * 0,
                                                      bottom:
                                                          _mediaQ.height * 0,
                                                      left: _mediaQ.width * 0,
                                                      right: _mediaQ.width * 0,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  (loadingProgress
                                                                          .expectedTotalBytes ??
                                                                      1)
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Colors.black54,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<CommunityPostFunction>(
                                                  context,
                                                  listen: false)
                                              .tapOnLike(
                                            widget.nodeID,
                                            widget.communityNodeId,
                                          );
                                        },
                                        child: Chip(
                                          padding: const EdgeInsets.only(
                                            right: 13,
                                            left: 10,
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          label: Row(
                                            children: [
                                              Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${widget.likescount.length}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            CommentScreen.routeName,
                                            arguments: {
                                              'userName': widget.name,
                                              'mediaurl': widget.mediaUrl,
                                              'likes': widget.likescount,
                                              'isLiked': isLiked,
                                              'comments': widget.comments,
                                              'postTime': widget.date,
                                              'nodeID': widget.nodeID,
                                              'communityNodeId':
                                                  widget.communityNodeId
                                            },
                                          );
                                        },
                                        child: Chip(
                                          padding: const EdgeInsets.only(
                                            right: 13,
                                            left: 10,
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          label: Row(
                                            children: [
                                              const Icon(
                                                Icons.comment,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${widget.comments.length}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () async {},
                                            icon: const Icon(
                                              Icons.share,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.message,
                                      style:
                                          widget.message.toLowerCase().contains(
                                                    'This post was deleted\u200B'
                                                        .toLowerCase(),
                                                  )
                                              ? deleteMessage
                                              : message,
                                    ),
                                    if (widget.message !=
                                        'This post was deleted\u200B')
                                      const Divider(
                                        thickness: 2,
                                        color: Colors.black54,
                                      ),
                                    if (widget.message !=
                                        'This post was deleted\u200B')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Provider.of<CommunityPostFunction>(
                                                      context,
                                                      listen: false)
                                                  .tapOnLike(
                                                widget.nodeID,
                                                widget.communityNodeId,
                                              );
                                            },
                                            child: Chip(
                                              padding: const EdgeInsets.only(
                                                right: 13,
                                                left: 10,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              label: Row(
                                                children: [
                                                  Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${widget.likescount.length}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                CommentScreen.routeName,
                                                arguments: {
                                                  'userName': widget.name,
                                                  'mediaurl': widget.mediaUrl,
                                                  'likes': widget.likescount,
                                                  'isLiked': isLiked,
                                                  'comments': widget.comments,
                                                  'postTime': widget.date,
                                                  'nodeID': widget.nodeID,
                                                  'communityNodeId':
                                                      widget.communityNodeId
                                                },
                                              );
                                            },
                                            child: Chip(
                                              padding: const EdgeInsets.only(
                                                right: 13,
                                                left: 10,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              label: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.comment,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${widget.comments.length}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () async {},
                                                icon: const Icon(
                                                  Icons.share,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*

Image.network(
                                        widget.message,
                                        width: double.infinity,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Stack(
                                              children: [
                                            
                                                Image.asset(
                                                  'assets/newimageloading.png',
                                                ),
                                                Positioned(
                                                  top: _mediaQ.height * 0,
                                                  bottom: _mediaQ.height * 0,
                                                  left: _mediaQ.width * 0,
                                                  right: _mediaQ.width * 0,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              (loadingProgress
                                                                      .expectedTotalBytes ??
                                                                  1)
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),



 */
