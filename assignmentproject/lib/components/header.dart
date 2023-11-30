import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.blue,
      child: Stack(children: [
        Container(
            color: Colors.blue,
            child: const Stack(
              children: [
                Positioned(
                  top: 35,
                  right: 40,
                  child: CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person, size: 25),
                  ),
                ),
                Positioned(
                    left: 33,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Diary',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Hello',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ))
              ],
            )),
        const Drawer(),
      ]),
    );
  }
}
