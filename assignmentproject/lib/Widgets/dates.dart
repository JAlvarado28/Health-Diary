import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// create dates class
class Dates extends StatefulWidget {
  final String weekID;
  const Dates({super.key, required this.weekID});

  @override
  // ignore: library_private_types_in_public_api
  _DatesState createState() => _DatesState();
}

// collect and write Date data
class _DatesState extends State<Dates> {
  List<DateTime> dateList = [];
  Map<DateTime, dynamic> datesData = {};

  @override
  void initState() {
    super.initState();
    dateList = getPastDates();
    getDates();
  }

//get the List of dates
  List<DateTime> getPastDates() {
    return List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: index));
    }).reversed.toList();
  }

  Future<void> getDates() async {
    for (var date in dateList) {
      String dateID = DateFormat('yyyyMMdd').format(date);

      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc('userId')
            .collection('weeks')
            .doc(widget.weekID)
            .collection('days')
            .doc(dateID)
            .get();

        if (snapshot.exists && snapshot.data() != null) {
          datesData[date] = snapshot.data() as Map<String, dynamic>;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: dateList.map((date) {
            bool isActive = date == DateTime.now();
            return DateBox(
              date: date,
              active: isActive,
              data: datesData[date],
            );
          }).toList(),
        ));
  }
}

// week days box display
class DateBox extends StatelessWidget {
  final bool active;
  final DateTime date;
  final Map<String, dynamic>? data;

  const DateBox({
    super.key,
    this.active = false,
    required this.date,
    this.data,
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
