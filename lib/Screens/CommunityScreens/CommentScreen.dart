import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nex_social/Model/CommunityPostModel.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = 'CommentScreen';
  CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final postList =
        Provider.of<CommunityPostFunction>(context, listen: true).getAllPost;

    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final nodeId = routeData['nodeID'];
    final communityNodeId = routeData['communityNodeId'];

    final commentsList =
        postList.firstWhere((element) => element.nodeId == nodeId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Comments'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: commentsList.comments.length,
                itemBuilder: (context, index) {
                  final _comment = commentsList.comments[index];
                  final decryptionComment =
                      Provider.of<CommunityPostFunction>(context, listen: false)
                          .decryption(_comment['comment']);
                  print('LEMGTH :${commentsList.comments.length}');
                  return Dismissible(
                    key: ValueKey(nodeId),
                    direction: user.displayName == _comment['userName']
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                    confirmDismiss: user.displayName == _comment['userName']
                        ? (direction) {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  title: Text(
                                    "Are You Sure?",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        print('HEllo');
                                        Navigator.of(context).pop(false);
                                        var commentdata = {
                                          'userName': user.displayName,
                                          'comment': decryptionComment,
                                          'date': _comment['date'],
                                        };
                                        await Provider.of<
                                                    CommunityPostFunction>(
                                                context,
                                                listen: false)
                                            .deleteCommentByContent(
                                                communityNodeId,
                                                nodeId,
                                                commentdata);
                                      },
                                      child: Text(
                                        "Yes",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      alignment: Alignment.centerRight,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _comment['userName'],
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('dd-MM-yy - hh:mm a').format(
                                DateTime.parse(
                                  _comment['date'],
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: Text(
                            decryptionComment,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          hintText: 'Comment',
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        controller: commenController,
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
                    radius: 28,
                    //  radius: _mediaQ.height * 0.036,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser!;
                        if (commenController.text.isNotEmpty) {
                          String message = commenController.text;
                          commenController.clear();
                          String encryptedMessage =
                              Provider.of<CommunityPostFunction>(context,
                                      listen: false)
                                  .encryption(message);
                          var commentdata = {
                            'userName': user.displayName,
                            'comment': encryptedMessage,
                            'date': DateTime.now().toString(),
                          };
                          await Provider.of<CommunityPostFunction>(context,
                                  listen: false)
                              .addComment(communityNodeId, nodeId, commentdata);
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
