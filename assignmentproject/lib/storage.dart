import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import "package:flutter/foundation.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class HealthApp {
  bool _initialized = false;

  HealthApp();

  Future<void> initializedDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initialized = true;
    if (kDebugMode) {
      print("Initialized default app $app");
    }
  }

  bool get isInitialized => _initialized;

  Future<void> writeData(
      String week, String day, Map<String, dynamic> HealthData) async {
    try {
      if (!isInitialized) await initializedDefault();

//      var userId =
//      if(userId == null) throw Exception("User not logged in");
      await FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
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

  Future<Map<String, dynamic>?> readData(String week, String day) async {
    try {
      if (!isInitialized) await initializedDefault();

//      var userId =
//      if(userId == null) throw Exception("User not logged in");
      await FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
          .collection('weeks')
          .doc(week)
          .collection('days')
          .doc(day)
          .get();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}


//   Future<int> readCounter() async {
//     try {
//       if (!isInitialized) {
//         await initializeDefault();
//       }
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       DocumentSnapshot ds =
//           await firestore.collection("example").doc("counter").get();
//       if (ds.exists && ds.data() != null) {
//         Map<String, dynamic> data = (ds.data() as Map<String, dynamic>);
//         if (data.containsKey("value")) {
//           return data["value"];
//         }
//       }
//       bool writeSuccess = await writeCounter(0);
//       if (writeSuccess) {
//         return 0;
//       }
//       await writeCounter(0);
//       return 0;
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     return -1;
//   }
// }
