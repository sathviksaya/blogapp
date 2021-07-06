import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  late String title, blogPoster, description;
  late File _image;
  final ImagePicker picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var uploadTime = DateTime.now().toString();

  Future getAndSaveImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    await firebase_storage.FirebaseStorage.instance
        .ref('BlogPosters/$uploadTime.png')
        .putFile(_image);
    blogPoster = await firebase_storage.FirebaseStorage.instance
        .ref('BlogPosters/$uploadTime.png')
        .getDownloadURL();
  }

  void upload() async {
    await FirebaseFirestore.instance
        .collection('blogPosts')
        .doc(uploadTime)
        .set({
      "uploadTime": uploadTime,
      "title": title,
      "blogPoster": blogPoster,
      "description": description,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 150,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => getAndSaveImage(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/addImage.jpg",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: _image.isAbsolute
                      //     ? SizedBox()
                      //     : Image.file(
                      //         _image,
                      //         fit: BoxFit.fill,
                      //       ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (val) {
                    setState(() => title = val);
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        // color: Colors.transparent,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    maxLines: 8,
                    onChanged: (val) {
                      setState(() => description = val);
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Blog description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      upload();
                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please fill all the fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                      );
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
