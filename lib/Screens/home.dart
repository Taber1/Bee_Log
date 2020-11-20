import 'package:bee_log/Screens/addPost.dart';
import 'package:bee_log/Screens/drawer.dart';
import 'package:bee_log/Screens/login.dart';
import 'package:bee_log/Models/posts.dart';
import 'package:bee_log/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  String name;
  String email;
  String imgUrl;
  HomePage(this.imgUrl, this.name, this.email);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> listPost = [];
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ListRefresh();
  }

  Future<Null> ListRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    DatabaseReference postRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postRef.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.keys;
      var Data = snapshot.value;
      listPost.clear();

      for (var individualKey in KEYS) {
        Posts posts = Posts(
            Data[individualKey]["date"],
            Data[individualKey]["description"],
            Data[individualKey]["image"],
            Data[individualKey]["time"],
            Data[individualKey]["title"]);

        listPost.add(posts);
      }
      setState(() {
        print('Length:${listPost.length}');
      });
    });
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(navigatorKey.currentContext,
                    MaterialPageRoute(builder: (context) => AddPost()));
              })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ListRefresh,
        child: listPost.length == 0
            ? Center(child: Text("No Posts Available"))
            : ListView.builder(
                itemCount: listPost.length,
                itemBuilder: (context, index) {
                  return eachCard(
                      listPost[index].date,
                      listPost[index].description,
                      listPost[index].image,
                      listPost[index].time,
                      listPost[index].title);
                }),
      ),
      drawer: Draw_Wer(widget.imgUrl, widget.name, widget.email),
    );
  }
}

Widget eachCard(date, description, image, time, title) {
  return Card(
    child: Stack(children: [
      Container(
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date + " " + time),
                SizedBox(
                  height: 2,
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      image: image != null
                          ? DecorationImage(
                              image: NetworkImage(image), fit: BoxFit.cover)
                          : DecorationImage(
                              image: AssetImage('assets/images/noimage.png'))),
                )
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(navigatorKey.currentContext).size.width *
                      0.65,
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    maxLines: 7,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Positioned(
        bottom: 5,
        right: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: Icon(Icons.comment),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {},
              child: Icon(Icons.favorite_border),
            ),
          ],
        ),
      )
    ]),
  );
}
