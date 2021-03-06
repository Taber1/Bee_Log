import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  String imageUrl;
  String title;
  String description;
  String date;
  String time;
  String id;
  bool fav;
  PostScreen(this.imageUrl, this.title, this.description, this.date, this.time,
      this.id, this.fav);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isFav;
  Icon setIcon;
  Future<bool> favToggle(String id) async {
    setState(() {
      isFav = !isFav;
      isFav == false
          ? setIcon = Icon(Icons.favorite_border)
          : setIcon = Icon(Icons.favorite, color: Colors.red);
      DatabaseReference ref =
          FirebaseDatabase.instance.reference().child("Posts").child(widget.id);
      ref.update({"Fav": isFav});
    });
  }

  @override
  void initState() {
    isFav = widget.fav;
    isFav == false
        ? setIcon = Icon(Icons.favorite_border)
        : setIcon = Icon(Icons.favorite, color: Colors.red);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //child: Image.network(widget.imageUrl),
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(child: Text(widget.date + " " + widget.time))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () => favToggle(widget.id),
                    child: setIcon,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
