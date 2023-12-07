import 'package:assignmentproject/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.blue,
      child: Stack(children: [
        Container(
            color: Colors.blue,
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  right: 20,
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? const Icon(Icons.person, size: 25)
                          : null,
                    ),
                  ),
                ),
                Positioned(
                    left: 70,
                    bottom: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Health Diary',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Hello, ${user?.displayName ?? ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ]),
    );
  }
}
