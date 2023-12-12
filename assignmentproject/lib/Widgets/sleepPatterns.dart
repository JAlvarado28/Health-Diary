// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_web_auth/flutter_web_auth.dart';
// import 'package:fitbitter/fitbitter.dart';

// class SleepPatterns extends StatefulWidget {
//   String dates;
//   SleepPatterns({super.key, required this.dates});

//   @override
//   _SleepPatterns createState() => _SleepPatterns();
// }

// class _SleepPatterns extends State<SleepPatterns> {
//   String? userID;
//   DateTime? dateOfSleep;
//   DateTime? entryDateTime;

//   bool isLoading = true;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();

//   bool isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchSP();
//   }

//   Future<void> fetchSP() async {
//     try {
//       FitbitSleepDataManager fitbitSleepDataManager = FitbitSleepDataManager(
//         clientID: '23RJW6',
//         clientSecret: '0e2f9ee7fc48449c2268b95633e32cf5',
//       );

//       FitbitCredentials fitbitCredentials = await getStoredFibitCred();
//       FitbitSleepAPIURL fitbitSleepAPIURL = FitbitSleepAPIURL.day(
//         date: DateTime.now(),
//         fitbitCredentials: fitbitCredentials,
//       );

//       List<FitbitData> sleepData =
//           await fitbitSleepDataManager.fetch(fitbitSleepAPIURL);

//       if (sleepData.isNotEmpty) {
//         totalSleep = calculateSleep(sleepData);

//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<FitbitCredentials> getStoredFibitCred() async {
//     try {
//       String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (userDoc.exists) {
//         String userID = userDoc['userID'];
//         String accessToken = userDoc['accessToken'];
//         String refreshToken = userDoc['refreshToken'];
//         return FitbitCredentials(
//             userID: userID,
//             fitbitAccessToken: accessToken,
//             fitbitRefreshToken: refreshToken);
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     return FitbitCredentials(
//         userID: "userID",
//         fitbitAccessToken: "fitbitAccessToken",
//         fitbitRefreshToken: "fitbitRefreshToken");
//   }

//   Future<void> StoreSleep(int? calories) async {
//     try {
//       String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       DocumentReference userDoc = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('dates')
//           .doc(widget.dates);

//       await userDoc.set({'HeartThreshold': limit}, SetOptions(merge: true));
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//   }

//   Future<int> getStoredSleep() async {
//     try {
//       String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (userDoc.exists) {
//         Map<String, dynamic>? userData =
//             userDoc.data() as Map<String, dynamic>?;
//         return userData?['HeartThreshold'] as int? ?? 0;
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     return 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const CircularProgressIndicator()
//         : SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ExpansionTileCard(
//                 key: cardA,
//                 leading: const CircleAvatar(child: Icon(Icons.water)),
//                 title: const Text('Current Heart Rate'),
//                 subtitle: restingHeartRate != null
//                     ? Text('$restingHeartRate BPM')
//                     : const Text('No data for today'),
//                 onExpansionChanged: (expanded) {
//                   setState(() {
//                     isExpanded = expanded;
//                   });
//                 },
//                 children: <Widget>[
//                   const Divider(thickness: 1.0, height: 1.0),
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: <Widget>[
//                           TextFormField(
//                             decoration: const InputDecoration(
//                               labelText: 'Enter the threshold to alert you!',
//                               border: OutlineInputBorder(),
//                             ),
//                             keyboardType: TextInputType.number,
//                             onSaved: (value) {
//                               limit = int.tryParse(value ?? '')!;
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a value';
//                               }
//                               if (int.tryParse(value)! <= 0) {
//                                 return 'Please enter a positive number';
//                               }
//                               return null;
//                             },
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 _formKey.currentState!.save();
//                                 storeHeartLimit(limit);
//                                 if (isExpanded) {
//                                   cardA.currentState?.collapse();
//                                 }
//                               }
//                             },
//                             child: const Text('Submit'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }
