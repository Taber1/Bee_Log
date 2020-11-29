import 'dart:io';
import 'package:bee_log/Screens/home.dart';
import 'package:bee_log/Widgets/CustomProgressIndicator.dart';
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

  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future SaveToDb(context) async {
    // Upload task
    showLoaderDialog(context);
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Post Images");
    var timeKey = DateTime.now();
    UploadTask uploadTask =
        storageReference.child(timeKey.toString() + ".jpg").putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    imageUrl = (await taskSnapshot.ref.getDownloadURL());
    imageUrl = imageUrl.toString();
    print("imageUrl=" + imageUrl);
    // Database Code
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d');
    var formatTime = DateFormat('hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference reference = FirebaseDatabase.instance.reference();

    var data = {
      "image": imageUrl,
      "title": title,
      "description": description,
      "date": date,
      "time": time,
      "Fav": false,
    };

    reference.child("Posts").push().set(data);
    reference.child("Posts").once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      for (var individualKey in KEYS) {
        reference
            .child("Posts")
            .child(individualKey)
            .update({'key': individualKey});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Post uploaded successfully"),
    ));

    Navigator.pop(context);
    Navigator.pop(context, true);
    // imageUrl = await (await taskSnapshot).ref.getDownloadURL();
    // setState(() {
    //   imageUrl = imageUrl.toString();
    // });
    // print("Uploaded Successfully !!!");
// database upload
  }

  @override
  Widget build(BuildContext context) {
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
                              Colors.black.withOpacity(0.2), BlendMode.dstATop))
                      : DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Container(
                  child: Visibility(
                    visible: val,
                    child: FlatButton(
                      onPressed: () {
                        if (_image == null) {
                          pickImage();
                          setState(() {
                            val = false;
                          });
                        } else {
                          // uploadImage(context);
                          // setState(() {
                          //   val = false;
                          //   showLoaderDialog(context);
                          // });

                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload),
                          Text(
                            "Pick Image",
                            style: TextStyle(fontSize: 17),
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
                color: Colors.orange,
                child: Text("Post"),
                onPressed: () {
                  SaveToDb(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
