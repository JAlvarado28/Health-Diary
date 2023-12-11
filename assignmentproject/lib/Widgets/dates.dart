import 'package:assignmentproject/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

// create dates class
class Dates extends StatefulWidget {
  final String dates;
  final Function(String) onDateChanged;
  const Dates({super.key, required this.dates, required this.onDateChanged});

  @override
  // ignore: library_private_types_in_public_api
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2023, 11, 1),
      lastDay: DateTime.utc(2030, 12, 25),
      calendarFormat: _calendarFormat,
      onDaySelected: (selectedDay, focusedDay) async {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        String newDate = DateFormat('MM-dd-yyyy').format(selectedDay);
        widget.onDateChanged(newDate);

        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        await HealthApp().storeDatesUpdate(userId, newDate);
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusDay) {
        _focusedDay = focusDay;
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            final text = DateFormat.E().format(day);

            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
