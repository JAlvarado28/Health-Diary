import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class WaterIntake extends StatefulWidget {
  const WaterIntake({super.key});

  @override
  _WaterIntake createState() => _WaterIntake();
}

class _WaterIntake extends State<WaterIntake> {
  final _formkey = GlobalKey<FormState>();
  int? WaterIntake;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Water Intake by bottles/cups'),
      ),
      body: Form(
          key: _formkey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Water Intake'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                WaterIntake = int.tryParse(value!);
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
                  storeWaterIntake(WaterIntake);
                }
              },
              child: const Text('submit'),
            )
          ])),
    );
  }
}

Future<void> storeWaterIntake(int? calories) async {
  if (calories == null) return;
  //fill the rest to store this shit
}
