import 'package:bee_log/Models/posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Posts/PostScreen.dart';

class myFavourites extends StatefulWidget {
  @override
  _myFavouritesState createState() => _myFavouritesState();
}

class _myFavouritesState extends State<myFavourites> {
  List<Posts> favPost = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Null> favListRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var Data = snapshot.value;
      favPost.clear();

      for (var individualKey in KEYS) {
        if (Data[individualKey]['Fav'] == true) {
          Posts posts = Posts(
              Data[individualKey]["date"],
              Data[individualKey]["description"],
              Data[individualKey]["image"],
              Data[individualKey]["time"],
              Data[individualKey]["title"],
              Data[individualKey]["key"],
              Data[individualKey]['Fav']);

          favPost.add(posts);
        }
        setState(() {
          // print('length:${listPost.length}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.home),
          ),
        ),
        body: FutureBuilder(
          future: favListRefresh(),
          builder: (context, snapshot) {
            return favPost.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No item available",
                        textAlign: TextAlign.center,
                      ),
                      Center(
                          child: Icon(
                        FontAwesomeIcons.exclamationCircle,
                      ))
                    ],
                  )
                : StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    crossAxisCount: 4,
                    itemCount: favPost.length,
                    itemBuilder: (BuildContext context, int index) {
                      return eachFavPost(
                          favPost[index].date,
                          favPost[index].description,
                          favPost[index].image,
                          favPost[index].time,
                          favPost[index].title,
                          favPost[index].id,
                          favPost[index].fav);
                    },
                  );
          },
        ));
  }
}

class eachFavPost extends StatefulWidget {
  String date;
  String description;
  String image;
  String time;
  String title;
  String id;
  bool fav;
  eachFavPost(this.date, this.description, this.image, this.time, this.title,
      this.id, this.fav);

  @override
  _eachFavPostState createState() => _eachFavPostState();
}

class _eachFavPostState extends State<eachFavPost> {
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

  Future<Null> cardFuture() async {
    await Future.delayed(Duration(seconds: 1));
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    setState(() {
      return postRef.child(widget.id).child("Fav");
    });
  }

  iconSet(bool fav) {
    fav == false
        ? setIcon = Icon(Icons.favorite_border)
        : setIcon = Icon(Icons.favorite, color: Colors.red);
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var Data = snapshot.value;

      for (var individualKey in KEYS) {
        (Data[individualKey]["Fav"] == true)
            ? setIcon = Icon(Icons.favorite_border)
            : setIcon = Icon(Icons.favorite, color: Colors.red);
      }
    });
    return setIcon;
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
    return FutureBuilder(
      future: cardFuture(),
      builder: (context, snapshot) => GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                    widget.image,
                    widget.title,
                    widget.description,
                    widget.date,
                    widget.time,
                    widget.id,
                    widget.fav))),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 180,
                child: Image.network(
                  widget.image,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.title,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () => favToggle(widget.id),
                    child: setIcon,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
