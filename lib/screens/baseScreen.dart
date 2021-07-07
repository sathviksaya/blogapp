import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addScreen.dart';
import 'homeScreen.dart';
import 'profileScreen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedTabIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    AddScreen(),
    ProfileScreen(),
  ];
  final List<String> titles = ["Blog Posts", "Post a Blog","Profile"];

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTabIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedTabIndex],
          style: TextStyle(
            color: Colors.black54,
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: screens[_selectedTabIndex],
      bottomNavigationBar: DotNavigationBar(
        currentIndex: _selectedTabIndex,
        borderRadius: 50,
        onTap: _handleIndexChanged,
        marginR: const EdgeInsets.fromLTRB(30, 5, 30, 10),
        paddingR: const EdgeInsets.only(bottom: 2, top: 2),
        items: [
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.green,
            unselectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: Icon(Icons.add),
            selectedColor: Colors.green,
            unselectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: _selectedTabIndex != 2 ? CircleAvatar(
              backgroundColor: Colors.black,
              maxRadius: 13,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL ?? "",
                  height: 25,
                  fit: BoxFit.fill,
                ),
              ),
            ) : Icon(Icons.person),
            selectedColor: Colors.green,
            unselectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
