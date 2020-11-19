import 'dart:io';
import 'package:bee_log/Screens/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
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
  bool val = true;
  var titleCont = TextEditingController();
  var desCont = TextEditingController();
  String title;
  String description;
  String imageUrl;

  void SaveToDb(url, context) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference reference = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "title": title,
      "description": description,
      "date": date,
      "time": time,
    };

    reference.child("Posts").push().set(data);
    Navigator.pop(context);
  }

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
          FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = DateTime.now();
      UploadTask uploadTask =
          storageReference.child(timeKey.toString() + ".jpg").putFile(_image);
      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => Navigator.pop(context));
      imageUrl = await (await taskSnapshot).ref.getDownloadURL();
      setState(() {
        imageUrl = imageUrl.toString();
      });
      print("Uploaded Successfully !!!");
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
                    borderRadius: BorderRadius.circular(10),
                    image: _image == null
                        ? DecorationImage(
                            image: AssetImage("assets/images/noimage.png"),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.dstATop))
                        : DecorationImage(
                            image: FileImage(_image), fit: BoxFit.cover)),
                child: Center(
                  child: Visibility(
                    visible: val,
                    child: FlatButton(
                      onPressed: () {
                        if (_image == null) {
                          pickImage();
                        } else {
                          uploadImage(context);
                          setState(() {
                            val = false;
                            showLoaderDialog(context);
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload),
                          Text(
                            _image == null ? "Pick Image" : "Upload Image",
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: titleCont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Add Title",
                    suffixIcon: IconButton(
                      icon: Icon(FontAwesomeIcons.paperPlane),
                      onPressed: () {},
                    )),
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: desCont,
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
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
              ),
              RaisedButton(
                onPressed: () => SaveToDb(imageUrl, context),
              )
            ],
          ),
        ),
      ),
    );
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(
          width: 5,
        ),
        Container(
            margin: EdgeInsets.only(left: 7), child: Text("Uploading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
