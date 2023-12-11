// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import 'package:intl/intl.dart';

// class Goals extends StatefulWidget {
//   String dates;
//   Goals({super.key, required this.dates});

//   @override
//   _Goals createState() => _Goals();
// }

// class _Goals extends State<Goals> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
//   int? weights;
//   int? amountExercise;
//   int? idealCalories;
//   bool isLoading = true;
//   bool isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchStoredCalorie();
//   }

//   void fetchStoredCalorie() async {
//     int calories = await getStoredCalorie();
//     setState(() {
//       idealCalories = calories;
//       isLoading = false;
//     });
//   }

//   Future<void> storeCalorie(int? calorieIntake) async {
//     try {
//       String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       String date = DateFormat('MM-dd-yyyy').format(DateTime.now());
//       DocumentReference userDoc = FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('dates')
//           .doc(date);

//       await userDoc
//           .set({'calorieIntake': calorieIntake}, SetOptions(merge: true));
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//   }

//   Future<int> getStoredCalorie() async {
//     try {
//       String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//       String date = DateFormat('MM-dd-yyyy').format(DateTime.now());

//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(userId)
//           .collection('dates')
//           .doc(date)
//           .get();

//       if (userDoc.exists) {
//         Map<String, dynamic>? userData =
//             userDoc.data() as Map<String, dynamic>?;
//         return userData?['calorieIntake'] as int? ?? 0;
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
//                 leading: const CircleAvatar(child: Icon(Icons.fastfood)),
//                 title: const Text('Calorie Intake'),
//                 subtitle: calorieIntake != null
//                     ? Text('Consumed $calorieIntake calories')
//                     : const Text('No data for todat'),
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
//                               labelText: 'Enter Calorie Intake',
//                               border: OutlineInputBorder(),
//                             ),
//                             keyboardType: TextInputType.number,
//                             onSaved: (value) {
//                               calorieIntake = int.tryParse(value ?? '');
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
//                                 storeCalorie(calorieIntake);
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


// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';

// // class Goals extends StatefulWidget {
// //   const Goals({super.key});

// //   @override
// //   _Goals createState() => _Goals();
// // }

// // class _Goals extends State<Goals> {
// //   final _formkey = GlobalKey<FormState>();
// //   int? weights;
// //   int? amountExercise;
// //   int? idealCalories;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Enter your desired goals'),
// //       ),
// //       body: Form(
// //           key: _formkey,
// //           child: Column(children: <Widget>[
// //             TextFormField(
// //               decoration: const InputDecoration(labelText: 'Weight in lbs'),
// //               keyboardType: TextInputType.number,
// //               onSaved: (value) {
// //                 weights = int.tryParse(value!);
// //               },
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter a value';
// //                 }
// //                 if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
// //                   return 'Please enter a positive number';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             TextFormField(
// //               decoration:
// //                   const InputDecoration(labelText: 'Amount of Exercises'),
// //               keyboardType: TextInputType.number,
// //               onSaved: (value) {
// //                 amountExercise = int.tryParse(value!);
// //               },
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter a value';
// //                 }
// //                 if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
// //                   return 'Please enter a positive number';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             TextFormField(
// //               decoration: const InputDecoration(labelText: 'Ideal Calories'),
// //               keyboardType: TextInputType.number,
// //               onSaved: (value) {
// //                 idealCalories = int.tryParse(value!);
// //               },
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter a value';
// //                 }
// //                 if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
// //                   return 'Please enter a positive number';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 if (_formkey.currentState!.validate()) {
// //                   _formkey.currentState!.save();
// //                   storeGoals(weights, amountExercise, idealCalories);
// //                 }
// //               },
// //               child: const Text('submit'),
// //             )
// //           ])),
// //     );
// //   }
// // }

// // Future<void> storeGoals(
// //     int? weight, int? amountExercise, int? idealCalories) async {
// //   if (weight == null || amountExercise == null || idealCalories == null) return;

// //   //fill the rest to store this shit
// // }
