import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:fitbitter/fitbitter.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key});

  @override
  _HeartRate createState() => _HeartRate();
}

class _HeartRate extends State<HeartRate> {
  String? userID;
  int? restingHeartRate;
  DateTime? dateofMonitoring;
  int? minimumOutofRange;
  int? maximumOutofRange;
  int limit = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHBP();
  }

  Future<void> fetchHBP() async {
    try {
      FitbitHeartRateDataManager fitbitHeartRateDataManager =
          FitbitHeartRateDataManager(
        clientID: '23RJW6',
        clientSecret: '0e2f9ee7fc48449c2268b95633e32cf5',
      );

      FitbitCredentials fitbitCredentials = await getStoredFibitCred();

      FitbitHeartRateAPIURL fitbitHeartRateAPIURL = FitbitHeartRateAPIURL.day(
        date: DateTime.now(),
        fitbitCredentials: fitbitCredentials,
      );
      List<FitbitHeartRateData> fitbitHeartRateData =
          await fitbitHeartRateDataManager.fetch(fitbitHeartRateAPIURL);

      if (fitbitHeartRateData.isNotEmpty) {
        setState(() {
          restingHeartRate = fitbitHeartRateData.first.restingHeartRate;
          isLoading = false;
        });
        checkHBP(restingHeartRate);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<FitbitCredentials> getStoredFibitCred() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('FBusers')
          .get();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void checkHBP(int? heartRate) {
    if (heartRate != null && heartRate > limit) {
      showAlert();
    }
  }

  void showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Heart Rate limit hit!"),
              content:
                  const Text("Your heart rate has exceeded the limit. Chill."),
              actions: <Widget>[
                TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    return Center(
      child: Text('Your resting heart rate: $restingHeartRate'),
    );
  }
}
