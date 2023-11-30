import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  _Weight createState() => _Weight();
}

class _Weight extends State<Weight> {
  final _formkey = GlobalKey<FormState>();
  int? weights;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your weight'),
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
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  storeWeight(weights);
                }
              },
              child: const Text('submit'),
            )
          ])),
    );
  }
}

Future<void> storeWeight(int? calories) async {
  if (calories == null) return;
  //fill the rest to store this shit
}
