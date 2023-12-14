import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';

class Goals extends StatefulWidget {
  String dates;
  Goals({super.key, required this.dates});

  @override
  _Goals createState() => _Goals();
}

class _Goals extends State<Goals> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  int? idealWeight;
  int? idealCalories;
  int? idealHours;
  bool isLoading = true;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchidealWeight();
    fetchidealCalories();
    fetchidealHours();
  }

  @override
  void didUpdateWidget(covariant Goals oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dates != oldWidget.dates) {
      fetchidealWeight();
      fetchidealCalories();
      fetchidealHours();
    }
  }

// fetch data ---------------------------------------------------------------
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
// end fetch data ------------------------------------------------------

// store data ------------------------------------------------------------
  Future<void> storeIAmount(int? amount) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDoc.set({'goalWeight': idealWeight}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

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

  Future<void> storeIHours(int? hours) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDoc.set({'GoalHours': idealHours}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
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

  Future<void> storeICalories(int? calories) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDoc
          .set({'GoalCalories': idealCalories}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
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
// end of store data ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTileCard(
                key: cardA,
                leading: const CircleAvatar(child: Icon(Icons.list)),
                title: const Text('Goal'),
                subtitle: idealWeight != null
                    ? Text(
                        'Your weight goal is $idealWeight lbs. Your calorie goal is $idealCalories. Your ideal hours of workout is $idealHours')
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
                              labelText: 'Enter your ideal weight',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              idealWeight = int.tryParse(value ?? '');
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (int.tryParse(value)! <= 0) {
                                return 'Please enter a positive number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter your ideal calorie intake',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              idealCalories = int.tryParse(value ?? '');
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (int.tryParse(value)! <= 0) {
                                return 'Please enter a positive number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText:
                                  'Enter your ideal hours of exercise sessions',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              idealHours = int.tryParse(value ?? '');
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (int.tryParse(value)! <= 0) {
                                return 'Please enter a positive number';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                storeIAmount(idealWeight);
                                storeICalories(idealCalories);
                                storeIHours(idealHours);
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
