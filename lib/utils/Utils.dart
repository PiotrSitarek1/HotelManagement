import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

void showToast(String message, {Toast length = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

Future<String> uploadImageToFirebaseStorage(File file) async {
  String imageName = DateTime.now().millisecondsSinceEpoch.toString();
  final reference =
  FirebaseStorage.instance.ref().child('images/$imageName.jpg');
  final uploadTask = reference.putFile(file);

  await uploadTask.whenComplete(() => null);

  String imageUrl = await reference.getDownloadURL();
  return imageUrl;
}

Future<File?> downloadImageFile(String imageUrl) async {
  try {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    final bytes = await ref.getData();

    if (bytes != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory("${appDir.path}/images");
      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final tempFile = File("${imagesDir.path}/$imageName.jpg");
      await ref.writeToFile(tempFile);
      return tempFile;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}