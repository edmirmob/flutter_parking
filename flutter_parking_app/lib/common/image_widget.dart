import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as paths;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageWidget extends StatefulWidget {
  final Function(File image) uploadFile;
  ImageWidget(this.uploadFile);
  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  File _storageImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    final File fileImg = File(imageFile.path);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storageImage = fileImg;
      widget.uploadFile(_storageImage);
    });
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final fileName = paths.basename(imageFile.path);
    final savedImage = await fileImg.copy('${appDirectory.path}/$fileName');
  }

  Future<void> _takePictureGallery() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final File fileImg = File(imageFile.path);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storageImage = fileImg;
      widget.uploadFile(_storageImage);
    });
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    final fileName = paths.basename(imageFile.path);
    final savedImage = await fileImg.copy('${appDirectory.path}/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
      Container(
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 50,
          child: ClipOval(
            child: _storageImage != null
                ? Image.file(
                    _storageImage,
                    fit: BoxFit.fill,
                    width: 120,
                    height: 120,
                  )
                : Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                    colorBlendMode: BlendMode.color,
                  ),
          ),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 1,
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("From where do you want to take the photo?"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Text("Gallery"),
                              onTap: () {
                                _takePictureGallery();
                                Navigator.pop(context);
                              },
                            ),
                            Padding(padding: EdgeInsets.all(8.0)),
                            GestureDetector(
                              child: Text("Camera"),
                              onTap: () {
                                _takePicture();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Icon(
              Icons.add_a_photo,
              size: 25,
            ),
          ),
        ),
      ),
    ]);
  }
}
