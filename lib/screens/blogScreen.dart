import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  final blog;
  const BlogScreen({Key? key, required this.blog}) : super(key: key);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BlogScreen"),
      ),
    );
  }
}
