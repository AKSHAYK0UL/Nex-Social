import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickAndUploadFunction with ChangeNotifier {
  final storage = FirebaseStorage.instance;

//Uplaod file to the fireBase storage

  Future<(String, UploadTask)> uploadFileToFireBase(
      {required String fileName, required String filepath}) async {
    File file = File(filepath);
    UploadTask? uploadTask;

    try {
      uploadTask = storage.ref('Media/$fileName').putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      print('URL : $url');
      print("UPLAODE HELLOW ${uploadTask}");
      return (url, uploadTask);
    } on FirebaseException catch (_) {
      print("UPLOAD ERROR????");
      rethrow;
    }
  }

//Pick file from the storage
  Future<(String, String)> pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'MP4',
        'MKV',
        'MOV',
        'AVI',
        'WEBM'
      ],
    );
    if (result == null) {
      Provider.of<CommunityFunctionClass>(navigatorkey.currentContext!,
              listen: false)
          .showSnackBar('No file picked');
    }

    final path = result!.files.single.path;
    final fileName = result.files.single.name;
    print('Path$path');
    print('FileName$fileName');
    return (path!, fileName);
  }

  Future<void> getStoragePermission() async {
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

    PermissionStatus status30 = await Permission.manageExternalStorage.status;

    PermissionStatus status29 = await Permission.storage.status;

    if (status30.isDenied && deviceInfo.version.sdkInt >= 30) {
      await Permission.manageExternalStorage.request();
    } else if (status29.isDenied && deviceInfo.version.sdkInt <= 29) {
      await Permission.storage.request();
    } else if (status30.isPermanentlyDenied || status29.isPermanentlyDenied) {
      await openAppSettings();
    }
    print("AAAAAAAAAAAAAAAAAAA: ${status30.toString()}");
  }
}

/*

else if (status30.isDenied) {
      await Permission.storage.request().then((status) async {
        if (status.isDenied) {
          await openAppSettings();
        }
      });
    }
 */