import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_auth/src/pages/home/home_page.dart';
import 'package:test_auth/src/pages/login/login_page.dart';
import 'package:test_auth/src/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/utils/app_theme.dart';

bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '${Constants.appName}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.primaryTheme,
      home: _auth.currentUser == null ? LoginPage() : HomePage(),
    );
  }
}

