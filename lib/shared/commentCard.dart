import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final time;
  final blogId;
  final comment;
  final commentator;
  const CommentCard(
      {Key? key,
      required this.time,
      required this.blogId,
      required this.commentator,
      required this.comment})
      : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: IconButton(
          onPressed: () {
            setState(() {
              liked = !liked;
            });
          },
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
        tileColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          widget.comment,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.commentator,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              widget.time,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection("blogPosts")
                .doc(widget.blogId)
                .collection("comments")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
