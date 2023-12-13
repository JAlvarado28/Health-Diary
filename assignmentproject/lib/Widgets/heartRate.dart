import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:fitbitter/fitbitter.dart';
import 'dart:async';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key});

  @override
  _HeartRate createState() => _HeartRate();
}

class _HeartRate extends State<HeartRate> {
  String? userID;
  DateTime? dateOfMonitoring;
  double? value;
  int? restingHeartRate;
  int limit = 160;
  bool isLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  Timer? _timer;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    getHeartRateLimit();
    fetchHBP();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(minutes: 2), (Timer t) => fetchHBP());
  }

  Future<void> fetchHBP() async {
    try {
      FitbitHeartRateIntradayDataManager fitbitHeartRateIntradayDataManager =
          FitbitHeartRateIntradayDataManager(
        clientID: '23RJW6',
        clientSecret: '0e2f9ee7fc48449c2268b95633e32cf5',
      );

      FitbitCredentials fitbitCredentials = await getStoredFibitCred();
      FitbitHeartRateIntradayAPIURL fitbitHeartRateIntradayAPIURL =
          FitbitHeartRateIntradayAPIURL.dayAndDetailLevel(
        date: DateTime.now(),
        fitbitCredentials: fitbitCredentials,
        intradayDetailLevel: IntradayDetailLevel.ONE_MINUTE,
      );

      List<FitbitData> data = await fitbitHeartRateIntradayDataManager
          .fetch(fitbitHeartRateIntradayAPIURL);

      List<FitbitHeartRateIntradayData> heartRateData =
          data.whereType<FitbitHeartRateIntradayData>().toList();

      if (heartRateData.isNotEmpty) {
        int latest = heartRateData.last.value?.round() ?? 0;

        setState(() {
          restingHeartRate = latest;
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
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('fitbitCredentials')) {
          Map<String, dynamic> credentials = data['fitbitCredentials'];
          if (credentials.containsKey('fitbitAccessToken') &&
              credentials.containsKey('fitbitRefreshToken') &&
              credentials.containsKey('fitbitUserID')) {
            return FitbitCredentials(
                userID: credentials['fitbitUserID'],
                fitbitAccessToken: credentials['fitbitAccessToken'],
                fitbitRefreshToken: credentials['fitbitRefreshToken']);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    throw Exception('Fibit credentials are not found');
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

  Future<void> storeHeartLimit(int? calories) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDoc.set({'HeartThreshold': limit}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<int> getStoredHeartLimit() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['HeartThreshold'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  void getHeartRateLimit() async {
    int storedLimit = await getStoredHeartLimit();
    setState(() {
      limit = storedLimit;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTileCard(
                key: cardA,
                leading:
                    const CircleAvatar(child: Icon(Icons.heat_pump_rounded)),
                title: const Text('Current Heart Rate'),
                subtitle: restingHeartRate != null
                    ? Text('$restingHeartRate BPM')
                    : const Text('No data for today'),
                onExpansionChanged: (expanded) {
                  setState(() {
                    isExpanded = expanded;
                  });
                },
                children: <Widget>[
                  const Divider(thickness: 1.0, height: 1.0),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter the threshold to alert you!',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              limit = int.tryParse(value ?? '')!;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (int.tryParse(value)! <= 0) {
                                return 'Please enter a positive number';
                              }
                              if (limit < restingHeartRate!) {
                                showAlert();
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                storeHeartLimit(limit);
                                if (isExpanded) {
                                  cardA.currentState?.collapse();
                                }
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
