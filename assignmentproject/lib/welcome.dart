import 'package:assignmentproject/components/bottomNav.dart';
import 'package:assignmentproject/home.dart';
import 'package:assignmentproject/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class Welcome extends StatefulWidget {
  final String currentDate;
  final String userID;
  Welcome({super.key, required this.currentDate, required this.userID});

  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<Welcome> {
  bool _fitbitConnected = false;

  void fetchBool() async {
    _fitbitConnected = await HealthApp().getStoredBool();
    setState(() {});
  }

  void _connect() async {
    try {
      FitbitCredentials? fitbitCredentials = await FitbitConnector.authorize(
        clientID: '23RJW6',
        clientSecret: '0e2f9ee7fc48449c2268b95633e32cf5',
        redirectUri: 'myhealthdiary://callback',
        callbackUrlScheme: 'myhealthdiary',
      );
      if (fitbitCredentials != null) {
        bool trigger = true;
        await HealthApp().storeFitbitUserID(widget.userID, fitbitCredentials);
        await HealthApp().storeBool(widget.userID, trigger);
        fetchBool();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => NavigationBarApp(trigger: trigger)),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Health Diary"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Track you daily healthy habits here. Set goals and acheive them with this tracker!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Connect with your Fitbit to get the best user experience. If not, you can still use it, but some features might be disabled.",
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: _connect,
              child: const Text("Connect Fitbit"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      NavigationBarApp(trigger: _fitbitConnected),
                ),
              ),
              child: const Text("Skip for now"),
            ),
          ],
        ),
      ),
    );
  }
}
