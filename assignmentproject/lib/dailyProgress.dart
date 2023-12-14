import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:uuid/uuid.dart';

class Progress extends StatefulWidget {
  String currentDate;
  Progress({super.key, required this.currentDate});

  @override
  _Progress createState() => _Progress();
}

class _Progress extends State<Progress> {
  //preloaded
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int? idealWeight;
  int? idealCalories;
  int? idealHours;
  int? currentWeight;
  int? currentCalories;
  int? currentHours;

  //new load
  int? difWeight;
  int? difCalories;
  int? difHours;
  String? feeling;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  String? imageUrl;
  String? userComment;

  final TextEditingController _comment = TextEditingController();

  void _getPhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  }

  void _uploadPhoto() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  }

  @override
  void initState() {
    super.initState();
    fetchidealCalories();
    fetchidealHours();
    fetchidealWeight();
    fetchCurrentWeight();
    fetchHours();
    fetchStoredCalorie();
    calculateDifference();
    fetchLatestImage();
  }

  void calculateDifference() {
    if (idealWeight != null && currentWeight != null) {
      difWeight = currentWeight! - idealWeight!;
    }
    if (idealCalories != null && currentCalories != null) {
      difCalories = idealCalories! - currentCalories!;
    }
    if (idealHours != null && currentHours != null) {
      difHours = idealHours! - currentHours!;
    }
  }

// fetch data -----------------------------------------
  void fetchidealWeight() async {
    setState(() {
      isLoading = true;
    });

    int weight = await getStoredIWeight();
    setState(() {
      idealWeight = weight;
      isLoading = false;
      calculateDifference();
    });
  }

  void fetchidealCalories() async {
    setState(() {
      isLoading = true;
    });

    int calories = await getStoredICalories();
    setState(() {
      idealCalories = calories;
      isLoading = false;
      calculateDifference();
    });
  }

  void fetchidealHours() async {
    setState(() {
      isLoading = true;
    });

    int hours = await getStoredIHours();
    setState(() {
      idealHours = hours;
      isLoading = false;
      calculateDifference();
    });
  }

  void fetchStoredCalorie() async {
    setState(() {
      isLoading = true;
    });

    int calories = await getStoredCalorie();
    setState(() {
      currentCalories = calories;
      isLoading = false;
      calculateDifference();
    });
  }

  void fetchCurrentWeight() async {
    setState(() {
      isLoading = true;
    });

    int storedWeight = await getStoredWeight();
    setState(() {
      currentWeight = storedWeight;
      isLoading = false;
      calculateDifference();
    });
  }

  void fetchHours() async {
    setState(() {
      isLoading = true;
    });

    int hours = await getStoredHours();
    setState(() {
      currentHours = hours;
      isLoading = false;
      calculateDifference();
    });
  }

  // end fetch data ---------------------------

  // get data -----------------------------------
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickFile = await picker.pickImage(source: source);
      if (pickFile != null) {
        setState(() {
          imageFile = File(pickFile.path);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
    if (_formKey.currentState!.validate()) {
      if (imageFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfull Uploaded')),
        );
        var uuid = const Uuid();
        String uuidString = uuid.v4();
        String downloadURL = await uploadFile(uuidString);
        await addItem(downloadURL, _comment.text);
        if (kDebugMode) {
          print(uuidString);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please take a photo')),
        );
      }
    }
    setState(() {});
  }

  Future<void> addItem(String downloadURL, String title) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('photos')
        .add({
      'title': title,
      'url': downloadURL,
      'user': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String> uploadFile(String filename) async {
    Reference ref = FirebaseStorage.instance.ref().child('$filename.jpg');
    final SettableMetadata metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: <String, String>{'file': 'image'},
      contentLanguage: 'en',
    );
    UploadTask uploadTask = ref.putFile(imageFile!, metadata);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    if (kDebugMode) {
      print(downloadURL);
    }
    return downloadURL;
  }

  void fetchLatestImage() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('photos')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first.data() as Map<String, dynamic>;
      String? newUrl = doc['url'] as String?;
      String? newComment = doc['title'] as String?;
      setState(() {
        imageUrl = newUrl;
        userComment = newComment;
      });
    }
  }

  Future<int> getStoredIWeight() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['goalWeight'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredIHours() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['GoalHours'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredICalories() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['GoalCalories'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredHours() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.currentDate)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['hoursOfExercise'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredWeight() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.currentDate)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['dailyWeight'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<int> getStoredCalorie() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dates')
          .doc(widget.currentDate)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        return userData?['calorieIntake'] as int? ?? 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 0;
  }

// end of get data -----------------------------------------------

// store these datas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your daily progress'),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Your Current Progress:'),
                    if (idealWeight != null) Text('Ideal weight: $idealWeight'),
                    if (currentWeight != null)
                      Text('Current weight: $currentWeight'),
                    if (difWeight != null)
                      Text('    -Weight difference: $difWeight'),
                    if (idealCalories != null)
                      Text('Ideal calories consumed: $idealCalories'),
                    if (currentCalories != null)
                      Text('Current calories consumed: $currentCalories'),
                    if (difCalories != null)
                      Text('    -Calories consumed difference: $difCalories'),
                    if (idealHours != null)
                      Text('Ideal hours workout: $idealHours'),
                    if (currentHours != null)
                      Text('Current hours workout: $currentHours'),
                    if (difHours != null)
                      Text('    -Workout hours difference: $difHours'),
                    imageUrl != null
                        ? Image.network(imageUrl!)
                        : const Placeholder(
                            fallbackHeight: 200,
                            fallbackWidth: double.infinity,
                          ),
                    if (userComment != null) Text('Comment: $userComment'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          child: const Text('Take photo'),
                        ),
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: const Text('Choose from your Gallary'),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _comment,
                      decoration:
                          const InputDecoration(labelText: 'Add a comment'),
                      maxLines: 5,
                    ),
                    ElevatedButton(
                        onPressed: _submit, child: const Text('Submit'))
                  ],
                ))));
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }
}
