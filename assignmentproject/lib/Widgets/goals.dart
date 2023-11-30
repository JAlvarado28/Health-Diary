import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  _Goals createState() => _Goals();
}

class _Goals extends State<Goals> {
  final _formkey = GlobalKey<FormState>();
  int? weights;
  int? amountExercise;
  int? idealCalories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your desired goals'),
      ),
      body: Form(
          key: _formkey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Weight in lbs'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                weights = int.tryParse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                  return 'Please enter a positive number';
                }
                return null;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Amount of Exercises'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                amountExercise = int.tryParse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                  return 'Please enter a positive number';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ideal Calories'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                idealCalories = int.tryParse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                  return 'Please enter a positive number';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  storeGoals(weights, amountExercise, idealCalories);
                }
              },
              child: const Text('submit'),
            )
          ])),
    );
  }
}

Future<void> storeGoals(
    int? weight, int? amountExercise, int? idealCalories) async {
  if (weight == null || amountExercise == null || idealCalories == null) return;

  //fill the rest to store this shit
}
