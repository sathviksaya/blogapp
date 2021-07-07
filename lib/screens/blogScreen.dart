import 'package:blogapp/shared/commentCard.dart';
import 'package:blogapp/shared/loadingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogScreen extends StatefulWidget {
  final blog;
  const BlogScreen({Key? key, required this.blog}) : super(key: key);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  late String newComment;
  TextEditingController commentField = new TextEditingController();
  int commentsCount = 0, likesCount = 0;

  void getCounts() async {
    await FirebaseFirestore.instance
        .collection("blogPosts")
        .doc(widget.blog.id)
        .collection("comments")
        .get()
        .then((value) {
      setState(() {
        commentsCount = value.docs.length;
      });
    });
    await FirebaseFirestore.instance
        .collection("blogPosts")
        .doc(widget.blog.id)
        .collection("likes")
        .get()
        .then((value) {
      setState(() {
        likesCount = value.docs.length;
      });
    });
  }

  @override
  void initState() {
    getCounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                expandedHeight: MediaQuery.of(context).size.height * 0.6,
                floating: true,
                pinned: true,
                iconTheme: IconThemeData(
                  color: Colors.black54,
                ),
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Image.network(
                    widget.blog["blogPoster"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  widget.blog["title"],
                  maxLines: 6,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Wrap(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red[600],
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          likesCount.toString(),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Wrap(
                      children: [
                        Icon(
                          Icons.comment,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          commentsCount.toString(),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          "- ${widget.blog["authorName"]}",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          DateFormat('jm').format(
                                DateTime.parse(widget.blog["uploadTime"]),
                              ) +
                              ", " +
                              DateFormat('d MMM,yy').format(
                                DateTime.parse(widget.blog["uploadTime"]),
                              ),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.blog["description"],
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Comments",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.78,
                        child: TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Comment here"),
                          onChanged: (String? val) {
                            newComment = val!;
                          },
                          controller: commentField,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("blogPosts")
                              .doc(widget.blog.id)
                              .collection("comments")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            'comment': newComment,
                            'time': DateFormat('jm').format(DateTime.now()) +
                                ", " +
                                DateFormat('d MMM,yy').format(DateTime.now()),
                            'commentator':
                                FirebaseAuth.instance.currentUser!.displayName,
                          });
                          commentField.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("blogPosts")
                        .doc(widget.blog.id)
                        .collection("comments")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingScreen();
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            "No Comments here",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CommentCard(
                              blogId: widget.blog.id,
                              time: snapshot.data.docs[index]['time'],
                              commentator: snapshot.data.docs[index]
                                  ['commentator'],
                              comment: snapshot.data.docs[index]['comment'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
