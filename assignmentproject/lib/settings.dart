import 'package:assignmentproject/components/drawer.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: getDrawer(context),
      body: Center(
        child: ElevatedButton(
          child: const Text('Home'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
