import 'package:flutter/material.dart';

import 'allBlogs.dart';
import 'myBlogs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                child: Text(
                  "All Blogs",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "My Blogs",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
              children: [
                AllBlogs(),
                MyBlogs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
