import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Model/CommunityPostModel.dart';
import 'package:nex_social/Model/FilePickAndUploadFunction.dart';
import 'package:nex_social/main.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';

class ImagePreviewAndUpload extends StatefulWidget {
  static const routeName = 'ImagePreviewAndUpload';
  ImagePreviewAndUpload({super.key});

  @override
  State<ImagePreviewAndUpload> createState() => _ImagePreviewAndUploadState();
}

class _ImagePreviewAndUploadState extends State<ImagePreviewAndUpload> {
  final user = FirebaseAuth.instance.currentUser!;

  String? imageUrl;
  bool _isloading = true;
  bool _uploadingFile = false;
  bool _uploadCompleted = false;
  bool istrue = true;
  @override
  void didChangeDependencies() {
    if (istrue) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        setState(() {
          _isloading = false;
        });
      });
      final routeDate =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final filePath = routeDate['Filepath'];
      final fileName = routeDate['FileName']!;
      if (fileName.toLowerCase().contains('.AVI'.toLowerCase()) ||
          fileName.toLowerCase().contains('.WEBM'.toLowerCase()) ||
          fileName.toLowerCase().contains('.MOV'.toLowerCase()) ||
          fileName.toLowerCase().contains('.MP4'.toLowerCase()) ||
          fileName.toLowerCase().contains('.MKV'.toLowerCase())) {
        initVideoPlayer(filePath!);
      }
      istrue = false;
    }
    super.didChangeDependencies();
  }

  late final PodPlayerController controller;
  void initVideoPlayer(String filePath) async {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.file(
        File(filePath),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: true,
        ),
      ),
    )..initialise().then((_) {
        controller.pause();
      });
  }

  bool isImage(String fileName) {
    if (fileName.toLowerCase().contains('.png'.toLowerCase()) ||
        fileName.toLowerCase().contains('.jpg'.toLowerCase()) ||
        fileName.toLowerCase().contains('.jpeg'.toLowerCase())) {
      return true;
    }
    return false;
  }

  bool isVideo(String fileName) {
    if (fileName.toLowerCase().contains('.MP4'.toLowerCase()) ||
        fileName.toLowerCase().contains('.MKV'.toLowerCase()) ||
        fileName.toLowerCase().contains('.MOV'.toLowerCase()) ||
        fileName.toLowerCase().contains('.AVI'.toLowerCase()) ||
        fileName.toLowerCase().contains('.WEBM'.toLowerCase())) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  final _postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final routeDate =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final filePath = routeDate['Filepath'];
    final fileName = routeDate['FileName'];

    final CommunityNodeId = routeDate['CommunityNodeId'];
    final _mediaQ = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: WidgetsBinding.instance.window.viewInsets.bottom > 0
                          ? 5
                          : 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Stack(
                          children: [
                            Center(
                              child: isImage(fileName!)
                                  ? ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaX: 0.80, sigmaY: 0.80),
                                      child: Image.file(
                                        File(filePath!),
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                      ),
                                    )
                                  : isVideo(fileName)
                                      ? PodVideoPlayer(
                                          controller: controller,
                                          videoAspectRatio: 16 / 9,
                                          onLoading: (context) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        )
                                      : null,
                            ),
                            if (_uploadingFile && !_uploadCompleted)
                              const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Uploading...',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_uploadCompleted && !_uploadingFile)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green.shade400,
                                      child: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Done',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            // !_uploadingFile
                            //     ? Expanded(
                            //         flex: !_uploadingFile && _uploadCompleted
                            //             ? 1
                            //             : 1,
                            //         child: SizedBox(
                            //           height: _mediaQ.height * 0.070,
                            //           // width: _mediaQ.width * 0.95,
                            //           child: ElevatedButton.icon(
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //             style: ElevatedButton.styleFrom(
                            //               shape: RoundedRectangleBorder(
                            //                 borderRadius:
                            //                     BorderRadius.circular(15),
                            //               ),
                            //             ),
                            //             icon: const Icon(Icons.arrow_back),
                            //             label: const Text('Back'),
                            //           ),
                            //         ),
                            //       )
                            //     : const Text(''),

                            Expanded(
                              child: Card(
                                color: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: TextField(
                                  decoration: InputDecoration(
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
                              child: _uploadingFile && !_uploadCompleted
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : !_uploadingFile && _uploadCompleted
                                      ? IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            setState(() {
                                              _uploadingFile = true;
                                            });
                                            try {
                                              var data = await Provider.of<
                                                          FilePickAndUploadFunction>(
                                                      context,
                                                      listen: false)
                                                  .uploadFileToFireBase(
                                                fileName: fileName,
                                                filepath: filePath!,
                                              );
                                              imageUrl = data.$1;

                                              if (imageUrl!.isNotEmpty) {
                                                String encryptedMessage = '';
                                                if (_postController
                                                    .text.isNotEmpty) {
                                                  encryptedMessage = Provider.of<
                                                              CommunityPostFunction>(
                                                          navigatorkey
                                                              .currentContext!,
                                                          listen: false)
                                                      .encryption(
                                                          _postController.text);
                                                }
                                                await Provider.of<
                                                            CommunityPostFunction>(
                                                        navigatorkey
                                                            .currentContext!,
                                                        listen: false)
                                                    .onAddPost(
                                                  user.displayName!,
                                                  user.email!,
                                                  user.uid,
                                                  encryptedMessage,
                                                  CommunityNodeId,
                                                  imageUrl!,
                                                )
                                                    .then((value) {
                                                  setState(() {
                                                    _uploadingFile = false;
                                                    _uploadCompleted = true;
                                                  });
                                                });
                                              }

                                              print('DOWNLOAD URL : $imageUrl');
                                            } on FirebaseException catch (e) {
                                              print(
                                                  'ERROR UPLOD ${e.toString()}');
                                              Provider.of<CommunityFunctionClass>(
                                                      navigatorkey
                                                          .currentContext!,
                                                      listen: false)
                                                  .showSnackBar(
                                                      'Fail to upload file');
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
                        )

                        //             const SizedBox(
                        //               width: 10,
                        //             ),
                        //             Expanded(
                        //               flex: !_uploadingFile && _uploadCompleted ? 0 : 1,
                        //               child: SizedBox(
                        //                 height: _mediaQ.height * 0.070,
                        //                 // width: _mediaQ.width * 0.95,
                        //                 child: !_uploadCompleted && !_uploadingFile
                        //                     ? ElevatedButton.icon(
                        //                         onPressed: () async {
                        //                           setState(() {
                        //                             _uploadingFile = true;
                        //                           });
                        //                           try {
                        //                             var data = await Provider.of<
                        //                                         FilePickAndUploadFunction>(
                        //                                     context,
                        //                                     listen: false)
                        //                                 .uploadFileToFireBase(
                        //                               fileName: fileName,
                        //                               filepath: filePath!,
                        //                             );
                        //                             imageUrl = data.$1;

                        //                             if (imageUrl!.isNotEmpty) {
                        //                               await Provider.of<
                        //                                           CommunityPostFunction>(
                        //                                       navigatorkey
                        //                                           .currentContext!,
                        //                                       listen: false)
                        //                                   .onAddPost(
                        //                                       user.displayName!,
                        //                                       user.email!,
                        //                                       user.uid,
                        //                                       imageUrl!,
                        //                                       CommunityNodeId,
                        //                                       "")
                        //                                   .then((value) {
                        //                                 setState(() {
                        //                                   _uploadingFile = false;
                        //                                   _uploadCompleted = true;
                        //                                 });
                        //                               });
                        //                             }

                        //                             print('DOWNLOAD URL : $imageUrl');
                        //                           } on FirebaseException catch (e) {
                        //                             print('ERROR UPLOD ${e.toString()}');
                        //                             Provider.of<CommunityFunctionClass>(
                        //                                     navigatorkey.currentContext!,
                        //                                     listen: false)
                        //                                 .showSnackBar(
                        //                                     'Fail to upload file');
                        //                           }
                        //                         },
                        //                         style: ElevatedButton.styleFrom(
                        //                           shape: RoundedRectangleBorder(
                        //                             borderRadius:
                        //                                 BorderRadius.circular(15),
                        //                           ),
                        //                         ),
                        //                         icon: const Icon(Icons.upload),
                        //                         label: const Text('Uplaod'),
                        //                       )
                        //                     : null,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        ),
                  ],
                ),
              ),
      ),
    );
  }
}
