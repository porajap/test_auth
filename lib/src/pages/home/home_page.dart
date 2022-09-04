import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:test_auth/src/pages/login/login_page.dart';
import 'package:test_auth/src/utils/app_bar.dart';

import '../lock/lock_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? currentUserAuth;


  @override
  void initState() {
    currentUserAuth = firebaseAuth.currentUser;

    super.initState();
  }

  Future refreshFirebaseUser() async {
    if (firebaseAuth.currentUser != null) {
      final user = firebaseAuth.currentUser;
      final idTokenResult = await user!.getIdTokenResult(true);

      DateTime currentDate = DateTime.now();
      DateTime tokenExp = idTokenResult.expirationTime!;

      if (!currentDate.isBefore(tokenExp)) {
        print("token exp");
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/login'),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Home", context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LockPage(),
            ),
          );
        },
        child: Icon(Icons.lock),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        currentUserAuth?.photoURL == null
                            ? CircleAvatar()
                            : CircleAvatar(
                                child: Image.network("${currentUserAuth?.photoURL}"),
                              ),
                        Text("${currentUserAuth?.phoneNumber}"),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          ModalRoute.withName('/login'),
                        );
                      },
                      child: Text("Sign out"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
