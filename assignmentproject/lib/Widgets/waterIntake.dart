import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';

class WaterIntake extends StatefulWidget {
  String dates;
  WaterIntake({super.key, required this.dates});

  @override
  _WaterIntake createState() => _WaterIntake();
}

class _WaterIntake extends State<WaterIntake> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  int? waterIntake;
  bool isLoading = true;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchStoredCups();
  }

  @override
  void didUpdateWidget(covariant WaterIntake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dates != oldWidget.dates) {
      fetchStoredCups();
    }
  }

  void fetchStoredCups() async {
    setState(() {
      isLoading = true;
    });

    int cups = await getStoredWater();
    setState(() {
      waterIntake = cups;
      isLoading = false;
    });
  }

  Future<void> storeWater(int? waterIntake) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.dates);

      await userDoc.set({'waterIntake': waterIntake}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<int> getStoredWater() async {
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
        return userData?['waterIntake'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
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
                leading: const CircleAvatar(child: Icon(Icons.water)),
                title: const Text('Water Intake'),
                subtitle: waterIntake != null
                    ? Text('Drank $waterIntake cups of water')
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
                              labelText: 'Enter cups of water Intake',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              waterIntake = int.tryParse(value ?? '');
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
                                storeWater(waterIntake);
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
