import 'package:assignmentproject/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(MaterialApp(
    title: 'Health Diary',
    theme: ThemeData(),
    home: const SignInPage(),
  ));
}
