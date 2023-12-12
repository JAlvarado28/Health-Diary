import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key});

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Page'),
      ),
      body: const Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Health Diary',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '''
            An android app that will help you manage good healthy habits and alert your emergency
contacts when your heart rate reaches a certain threshold. The app will allow users to record
their calorie intake, water intake, set goals (desired action such as weight loss or just increase
amount of exercise), morning/night weight, and the types of exercising they are doing. The data
will be stored using Firebase which will be based on the user’s Google Authenticator profile. The
data will be stored in the order of: Email/Profile > Week # > Day > etc. The user will be able to
see their data each day and be able to change it by editing the form. There will be weekly
reviews where the week results (average weight, calorie intake, amount of exercise, etc) will be
compared to their targeted goals and the user is able to take a photo at the end of the week with
a comment of how they feel and with a progression bar showing how close/far they are to their
goal. This will allow the user to see any results and feel motivated depending on how committed
they were. The data for heartbeat and sleep patterns will be collected from a restFull API
provided by Fitbit. The data from the APIs and the user’s input will be visualized in the
homepage as cards which they can manipulate to their preferences. If the heart rate threshold is
reached and the user does not reply to the prompt given within the app or notification on their
phone, it will send an automated email to the user’s emergency contact of the user’s location
and heart rate. This is more targeted to those that live alone or are alone for the majority of the
day, who have a history of heart conditions. The app will allow the user to use their location or
set certain locations in google maps not to alert their contacts (school, job, gym, etc). All of this
will combine the user-generated data with the Fitbit watch integration and will offer a
comprehensive tool for tracking, analyzing, and improving their overall health.
''',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
