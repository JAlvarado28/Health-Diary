import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dates extends StatefulWidget {
  const Dates({super.key});

  @override
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> {
  List<DateTime> dateList = [];

  @override
  void initState() {
    super.initState();
    fetchDates();
  }

  Future<void> fetchDates() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('chosenWeek').get();
    var fetchedDates =
        snapshot.docs.map((doc) => DateTime.parse(doc['date'])).toList();

    setState(() {
      dateList = fetchedDates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dateList.map((date) => DateBox(date: date)).toList(),
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final bool active;
  final DateTime date;
  const DateBox({
    super.key,
    this.active = false,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(colors: [
                    Color(0xff92eff),
                    Color(0xff1ebdf8),
                  ], begin: Alignment.topCenter)
                : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white,
            )),
        child: DefaultTextStyle.merge(
          style: active ? const TextStyle(color: Colors.white) : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat('E').format(date),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  )),
              Text(DateFormat('d').format(date),
                  style: TextStyle(
                    fontSize: 30,
                  )),
            ],
          ),
        ));
  }
}
