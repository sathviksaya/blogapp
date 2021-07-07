import 'package:blogapp/screens/blogScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogCard extends StatefulWidget {
  final blog;
  const BlogCard({Key? key, required this.blog}) : super(key: key);

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  int commentsCount = 0, likesCount = 0;
  bool isNew = true;

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
    isNew = commentsCount == 0 && likesCount == 0 ? true : false;
  }

  @override
  void initState() {
    getCounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return BlogScreen(
                blog: widget.blog,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 5,
        ),
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
              widget.blog["blogPoster"],
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: isNew ? 70 : 80,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blog["title"],
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      isNew
                          ? Text(
                              "New Blog",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Row(
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
                              ],
                            ),
                      Spacer(),
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
            ),
          ],
        ),
      ),
    );
  }
}
