import 'package:assignmentproject/home.dart';
import 'package:flutter/material.dart';
import 'package:assignmentproject/storage.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(),
    home: Home(),
  ));
}
