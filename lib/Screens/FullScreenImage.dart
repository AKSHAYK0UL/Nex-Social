import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Model/FilePickAndUploadFunction.dart';
import 'package:provider/provider.dart';

class FullScreenImage extends StatefulWidget {
  static const routeName = 'FullScreenImage';
  const FullScreenImage({super.key});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool viewMode = true;
  double? _progress;
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final imageUrl = routeData['ImageUrl'];
    final tag = routeData['Tag'];
    return SafeArea(
      child: Scaffold(
        appBar: !_show
            ? null
            : AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  _progress != null
                      ? const Text('')
                      : IconButton(
                          onPressed: () async {
                            await Provider.of<FilePickAndUploadFunction>(
                                    context,
                                    listen: false)
                                .getStoragePermission();

                            FileDownloader.downloadFile(
                              url: imageUrl!,
                              downloadDestination:
                                  DownloadDestinations.publicDownloads,
                              notificationType: NotificationType.all,
                              onProgress: (_, progress) {
                                setState(
                                  () {
                                    print(_progress);
                                    _progress = progress;
                                  },
                                );
                              },
                              onDownloadCompleted: (_) {
                                setState(() {
                                  _progress = null;
                                });
                                Provider.of<CommunityFunctionClass>(context,
                                        listen: false)
                                    .showSnackBar('Saved');
                              },
                              onDownloadError: (_) {
                                Provider.of<CommunityFunctionClass>(context,
                                        listen: false)
                                    .showSnackBar('Failed');
                              },
                            );
                          },
                          icon: const Icon(Icons.download),
                        ),
                ],
              ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Hero(
                  tag: tag!,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _show = !_show;
                      });
                    },
                    child: Center(
                      child: InteractiveViewer(
                        constrained: viewMode,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_progress != null)
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    value: _progress,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
