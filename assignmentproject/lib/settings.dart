import 'dart:html';

import 'package:assignmentproject/components/drawer.dart';
import 'package:assignmentproject/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;

  void upDateLocation(bool value) async {
    if (value) {
      LocationPermission status = await Geolocator.requestPermission();
      if (status == LocationPermission.always ||
          status == LocationPermission.whileInUse) {
        setState(() {
          _locationEnabled = true;
        });
      } else {
        setState(() {
          _locationEnabled = false;
        });
      }
    } else {
      setState(() {
        _locationEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Enable Location'),
            value: _locationEnabled,
            onChanged: (bool value) {
              setState(() {
                upDateLocation(value);
              });
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInPage()));
            },
          )
        ]));
  }
}
