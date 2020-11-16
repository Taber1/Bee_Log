import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File _image;
  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadImage(BuildContext context) async {
      String fileName = basename(_image.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() =>
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Uploaded Successfully !!!"))));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add your Post"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: FlatButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.file_upload), Text("Upload Image")],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Add Title",
                    suffixIcon: IconButton(
                      icon: Icon(FontAwesomeIcons.paperPlane),
                      onPressed: () {},
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Add Description",
                    suffixIcon: IconButton(
                      icon: Icon(FontAwesomeIcons.paperPlane),
                      onPressed: () {},
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
