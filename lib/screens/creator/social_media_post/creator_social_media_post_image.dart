import 'dart:io';

import 'package:atlast_mobile_app/services/image_uploading_service.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class CreatorSocialMediaPostImage extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const CreatorSocialMediaPostImage({
    Key? key,
    required this.navKey,
  }) : super(key: key);

  @override
  _CreatorSocialMediaPostImageState createState() =>
      _CreatorSocialMediaPostImageState();
}

class _CreatorSocialMediaPostImageState
    extends State<CreatorSocialMediaPostImage> {
  File? imageFile;
  String? imageUrl;

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    String url =
        await ImageUploadingService.uploadImage(File(pickedFile!.path));
    setState(() {
      imageFile = File(pickedFile!.path);
      imageUrl = url;
    });
    // Navigator.pop(context);
    widget.navKey.currentState!.pushNamed("/post-1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          imageFile != null
              ? Container(
                  child: Image.file(imageFile!),
                )
              : Container(
                  child: Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * .6,
                  ),
                ),
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                child: Text('Take a picture for your post'),
                onPressed: () {
                  _getFromCamera();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 16))),
              ))
        ],
      ),
    );
  }
}
