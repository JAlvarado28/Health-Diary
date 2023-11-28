import 'package:assignmentproject/components/drawer.dart';
import 'package:assignmentproject/settings.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heath Diary'),
      ),
      drawer: getDrawer(context),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Page 2'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Settings(title: 'Settings')),
            );
          },
        ),
      ),
    );
  }
}
