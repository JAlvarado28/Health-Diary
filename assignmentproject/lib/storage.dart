import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import "package:flutter/foundation.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class HealthApp {
  bool _initialized = false;

  HealthApp();

  Future<void> initializeDefault() async {
    if (!_initialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      if (kDebugMode) {
        print("Initialized default app");
      }
    }
  }

  Future<void> writeData(String userId, String week, String day,
      Map<String, dynamic> HealthData) async {
    try {
      // var userId =
      // if(userId == null) throw Exception("User not logged in");
      await initializeDefault();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('weeks')
          .doc(week)
          .collection('days')
          .doc(day)
          .set(HealthData, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<Map<String, dynamic>?> readData(
      String userId, String week, String day) async {
    try {
      // var userId =
      // if(userId == null) throw Exception("User not logged in");
      await initializeDefault();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('weeks')
          .doc(week)
          .collection('days')
          .doc(day)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  Future<void> StoreUserID(String userId, String email) async {
    try {
      await initializeDefault();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'email': email}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
