import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Progress extends StatefulWidget {
  String currentDate;
  Progress({super.key, required this.currentDate});

  @override
  _Progress createState() => _Progress();
}

class _Progress extends State<Progress> {
  //preloaded
  bool isLoading = false;
  int? idealWeight;
  int? idealCalories;
  int? idealHours;
  int? currentWeight;
  int? currentCalories;
  int? currentHours;

  //new load
  int? difWeight;
  int? difCalories;
  int? difHours;
  String? feeling;

  void iniState() {
    fetchCurrentWeight();
    fetchHours();
    fetchStoredCalorie();
    fetchidealCalories();
    fetchidealHours();
    fetchidealWeight();
    calculateDifference();
  }

  void calculateDifference() {
    if (idealWeight == null && currentWeight == null) {
      difWeight = idealWeight! - currentWeight!;
    }
    if (idealCalories == null && currentCalories == null) {
      difCalories = idealCalories! - currentCalories!;
    }
    if (idealHours == null && currentHours == null) {
      difHours = idealHours! - currentCalories!;
    }
  }

// fetch data -----------------------------------------
  void fetchidealWeight() async {
    setState(() {
      isLoading = true;
    });

    int weight = await getStoredIWeight();
    setState(() {
      idealWeight = weight;
      isLoading = false;
    });
  }

  void fetchidealCalories() async {
    setState(() {
      isLoading = true;
    });

    int calories = await getStoredICalories();
    setState(() {
      idealCalories = calories;
      isLoading = false;
    });
  }

  void fetchidealHours() async {
    setState(() {
      isLoading = true;
    });

    int hours = await getStoredIHours();
    setState(() {
      idealHours = hours;
      isLoading = false;
    });
  }

  void fetchStoredCalorie() async {
    setState(() {
      isLoading = true;
    });

    int calories = await getStoredCalorie();
    setState(() {
      currentCalories = calories;
      isLoading = false;
    });
  }

  void fetchCurrentWeight() async {
    setState(() {
      isLoading = true;
    });

    int storedWeight = await getStoredWeight();
    setState(() {
      currentWeight = storedWeight;
      isLoading = false;
    });
  }

  void fetchHours() async {
    setState(() {
      isLoading = true;
    });

    int hours = await getStoredHours();
    setState(() {
      currentHours = hours;
      isLoading = false;
    });
  }

  // end fetch data ---------------------------

  // get data -----------------------------------

  Future<int> getStoredIWeight() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['goalWeight'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredIHours() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['hoursOfExercise'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredICalories() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['GoalCalories'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredHours() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.currentDate)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['hoursOfExercise'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredWeight() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.currentDate)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['dailyWeight'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredCalorie() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.currentDate)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['calorieIntake'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

// end of get data -----------------------------------------------

// store these datas

//
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
