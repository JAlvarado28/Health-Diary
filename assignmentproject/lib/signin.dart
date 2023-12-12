// import 'package:assignmentproject/welcome.dart';
import 'package:assignmentproject/home.dart';
import 'package:assignmentproject/storage.dart';
import 'package:assignmentproject/welcome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {
  bool _initialized = false;
  UserCredential? _userCredential;
  GoogleSignInAccount? googleUser;
  late final List<DateTime> dateList;

  Future<void> initializeDefault() async {
    if (!_initialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      if (kDebugMode) {
        print("Initialized default app");
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!_initialized) {
      await initializeDefault();
    }
    // Trigger the authentication flow
    googleUser = await GoogleSignIn().signIn();

    if (kDebugMode) {
      if (googleUser != null) {
        print(googleUser!.displayName);
      }
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    _userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (_userCredential != null) {
      String userID = _userCredential!.user!.uid;
      String userEmail = _userCredential!.user!.email ?? 'No email';
      String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

      await HealthApp().storeUserID(userID, userEmail);
      await HealthApp().storeDates(userID, currentDate);

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Welcome(userID: userID, currentDate: currentDate)),
          (Route<dynamic> route) => false);
    }
    setState(() {});
    return _userCredential!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const SizedBox(),
          title: const Text('Welcome to Health Diary App'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getBody())));
  }

  List<Widget> getBody() {
    List<Widget> body = [];
    if (googleUser == null) {
      body.add(ElevatedButton(
        child: const Text('Sign in with Google'),
        onPressed: () async {
          _userCredential = await signInWithGoogle();
        },
      ));
    } else {
      body.add(ListTile(
        leading: GoogleUserCircleAvatar(identity: googleUser!),
        title: Text(googleUser!.displayName ?? ""),
        subtitle: Text(googleUser!.email),
      ));
      body.add(Text(FirebaseAuth.instance.currentUser!.uid));
      body.add(ElevatedButton(
          child: const Text('LogOut'),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            GoogleSignIn().signOut();
            setState(() {
              googleUser = null;
            });
          }));
    }
    return body;
  }
}
