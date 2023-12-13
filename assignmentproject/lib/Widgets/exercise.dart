import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';

class Exercise extends StatefulWidget {
  String dates;
  Exercise({super.key, required this.dates});

  @override
  _Exercise createState() => _Exercise();
}

class _Exercise extends State<Exercise> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  int? amountOfExercise;
  int? hoursOfExercise;
  String? typesOfExercise;
  bool isLoading = true;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchAmount();
    fetchHours();
    fetchTypes();
  }

  @override
  void didUpdateWidget(covariant Exercise oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dates != oldWidget.dates) {
      fetchAmount();
      fetchHours();
      fetchTypes();
    }
  }

// fetch data ---------------------------------------------------------------
  void fetchAmount() async {
    setState(() {
      isLoading = true;
    });

    int amount = await getStoredAmount();
    setState(() {
      amountOfExercise = amount;
      isLoading = false;
    });
  }

  void fetchHours() async {
    setState(() {
      isLoading = true;
    });

    int hours = await getStoredHours();
    setState(() {
      hoursOfExercise = hours;
      isLoading = false;
    });
  }

  void fetchTypes() async {
    setState(() {
      isLoading = true;
    });

    String types = await getStoredTypes();
    setState(() {
      typesOfExercise = types;
      isLoading = false;
    });
  }
// end fetch data ------------------------------------------------------

// store data ------------------------------------------------------------
  Future<void> storeAmount(int? amount) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates);

      await userDoc
          .set({'amountOfExercise': amountOfExercise}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<int> getStoredAmount() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['amountOfExercise'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> storeHours(int? hours) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates);

      await userDoc
          .set({'hoursOfExercise': hoursOfExercise}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<int> getStoredHours() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates)
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

  Future<void> storeTypes(String? types) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates);

      await userDoc
          .set({'typesOfExercise': typesOfExercise}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String> getStoredTypes() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['typesOfExercise'] as String? ?? '';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return '';
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
                leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
                title: const Text('Exercise Diary'),
                subtitle: amountOfExercise != null
                    ? Text(
                        'You did $amountOfExercise exercises in $hoursOfExercise hrs : $typesOfExercise')
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
                              labelText: 'Enter amount of Exercise',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              amountOfExercise = int.tryParse(value ?? '');
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
                              labelText: 'Enter amount of hours exercising',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              hoursOfExercise = int.tryParse(value ?? '');
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
                                  'Enter the list of exercises: E.g Cardio, Weights',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              typesOfExercise = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9, ]+$')
                                  .hasMatch(value)) {
                                return 'Please no special characters';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                storeAmount(amountOfExercise);
                                storeHours(hoursOfExercise);
                                storeTypes(typesOfExercise);
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
