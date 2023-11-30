import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Exercise extends StatefulWidget {
  const Exercise({super.key});

  @override
  _Exercise createState() => _Exercise();
}

class _Exercise extends State<Exercise> {
  final _formkey = GlobalKey<FormState>();
  int? amountExercise;
  String? typeofExercise;
  bool isExpanded = false;

  int? storedAmountExercise;
  String? storedTypeofExercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter the amount of Exercise you did'),
      ),
      body: Form(
          key: _formkey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'How many exercises?'),
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
              decoration: const InputDecoration(labelText: 'Type of Exercise'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                typeofExercise = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  storeExercise(amountExercise, typeofExercise);
                }
              },
              child: const Text('submit'),
            )
          ])),
    );
  }
}

Future<void> storeExercise(int? calories, String? typeofExercise) async {
  if (calories == null) return;
  //fill the rest to store this shit
}
