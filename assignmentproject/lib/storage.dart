import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:intl/intl.dart';
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
      await initializeDefault();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
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
      await initializeDefault();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
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

  Future<void> storeUserID(String userId, String email) async {
    try {
      await initializeDefault();
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userDoc.set({'email': email}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> storeDates(String userId, String date) async {
    try {
      await initializeDefault();
      DocumentReference dateDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(date);
      await dateDoc.set({'date': date}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> storeDatesUpdate(String userId, String date) async {
    try {
      DocumentReference dateDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(date);

      var existDoc = await dateDoc.get();
      if (!existDoc.exists) {
        await dateDoc.set({'date': date}, SetOptions(merge: true));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> storeFitbitUserID(
      String userId, FitbitCredentials fitbitCredentials) async {
    try {
      await initializeDefault();
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      Map<String, dynamic> fitbitMap = {
        'fitbitUserID': fitbitCredentials.userID,
        'fitbitAccessToken': fitbitCredentials.fitbitAccessToken,
        'fitbitRefreshToken': fitbitCredentials.fitbitRefreshToken,
      };
      await userDoc
          .set({'fitbitCredentials': fitbitMap}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> storeBool(String userId, bool trigger) async {
    try {
      await initializeDefault();
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDoc.set({'fitbitBool': trigger}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<bool> getStoredBool() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['fitbitBool'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return false;
  }
}
