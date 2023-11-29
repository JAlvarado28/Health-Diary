import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 80,
        color: Colors.white,
        child: const IconTheme(
            data: IconThemeData(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.search),
                Icon(Icons.home),
                Icon(Icons.date_range),
                Icon(Icons.add_card),
              ],
            )));
  }
}
