import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late String title, blogPoster, description, source;
  File _image = File("");
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
      "author": FirebaseAuth.instance.currentUser!.uid,
      "authorName": FirebaseAuth.instance.currentUser!.displayName,
      "title": title,
      "blogPoster": blogPoster,
      "description": description,
      "source": source,
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        border: Border.all(
                            color: !_image.isAbsolute
                                ? Colors.transparent
                                : Colors.black54),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: !_image.isAbsolute
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Add Image"),
                              ],
                            )
                          : Image.file(
                              _image,
                              fit: BoxFit.contain,
                            ),
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
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return "Please fill the title";
                    }
                    return null;
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Title *",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (val) {
                    setState(() => source = val);
                  },
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      source = "NA";
                    }
                  },
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Source",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 8,
                  onChanged: (val) {
                    setState(() => description = val);
                  },
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return "Please fill the description";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Blog description *",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      upload();
                      formKey.currentState!.reset();
                      setState(() {
                        _image = File("");
                      });
                      Fluttertoast.showToast(
                        msg: "Successfully posted your blog",
                        backgroundColor: Colors.white,
                        textColor: Colors.black54,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please fill all the fields",
                        backgroundColor: Colors.white,
                        textColor: Colors.black54,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                      );
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("Post"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
