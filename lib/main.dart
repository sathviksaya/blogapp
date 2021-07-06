import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/authScreen.dart';
import 'screens/baseScreen.dart';
import 'shared/loadingScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Blog App',
          theme: ThemeData(
            primarySwatch: Colors.green,
            errorColor: Color(0xffd32f2f),
          ),
          debugShowCheckedModeBanner: false,
          home: snapshot.connectionState != ConnectionState.done
              ? Scaffold(
                  body: LoadingScreen(),
                )
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: LoadingScreen(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                          child: Text("Something Went Wrong!"),
                        ),
                      );
                    }
                    if (snapshot.data != null) {
                      return BaseScreen();
                    }
                    return AuthScreen();
                  },
                ),
        );
      },
    );
  }
}
