import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          CircleAvatar(
            backgroundColor: Colors.black,
            maxRadius: 82,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                user!.photoURL ?? "",
                height: 160,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            user!.displayName ?? "",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            user!.email ?? "",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "LogOut",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Details provided by " + user!.providerData[0].providerId,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black26,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
