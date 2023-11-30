import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class CalorieIntake extends StatefulWidget {
  const CalorieIntake({super.key});

  @override
  _CalorieIntake createState() => _CalorieIntake();
}

class _CalorieIntake extends State<CalorieIntake> {
  final _formkey = GlobalKey<FormState>();
  int? calorieIntake;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Calorie Intake'),
      ),
      body: Form(
          key: _formkey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Calorie Intake'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                calorieIntake = int.tryParse(value!);
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
                  storeCalorieIntake(calorieIntake);
                }
              },
              child: const Text('submit'),
            )
          ])),
    );
  }
}

Future<void> storeCalorieIntake(int? calories) async {
  if (calories == null) return;
  //fill the rest to store this shit
}
