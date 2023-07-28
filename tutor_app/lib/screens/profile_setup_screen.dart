import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/user_profile.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _subjectsController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  String? _phoneNumber; // Nullable
  String? _profilePictureURL; // Nullable
  String? name; // Nullable
  String _role = 'student'; // Default role

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Here you should upload the image file to Firebase Storage
      // and get the download URL. The download URL should be saved
      // in _profilePictureURL.
      setState(() {
        //_profilePictureURL = pickedFile.path;
        uploadImage(pickedFile.path);// Replace with actual download URL
      });
    }
  }


  void uploadImage(String imagePath) async{
    final _firebaseStorage = FirebaseStorage.instance;
    var file = File(imagePath);

    if (imagePath != null){
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('images/imageName/${auth.currentUser?.uid.toString()}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        print("downloadUrl");
        print(downloadUrl);
        _profilePictureURL = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final subjects = _subjectsController.text.split(',').map((s) => s.trim()).toList();
      final hourlyRate = _role == 'tutor'
          ? double.parse(_hourlyRateController.text.trim())
          : 0.0;
      final user = UserProfile(
        uid: auth.currentUser?.uid ?? '', // Providing a default value in case currentUser is null
        name: name ?? '', // Providing a default value in case _profilePictureURL is null
        profilePicture: _profilePictureURL ?? '', // Providing a default value in case _profilePictureURL is null
        email: auth.currentUser?.email ?? '', // Providing a default value in case email is null
        phoneNumber: _phoneNumber ?? '', // Providing a default value in case _phoneNumber is null
        role: _role,
        subjects: subjects,
        hourlyRate: {for (var subject in subjects) subject: hourlyRate},
        rating: 0.0,
      );
      print(name);
      print("${user.name}");
      db.updateUserProfile(user);
      // Navigate to student or tutor home screen based on _role

      if (_role == 'student') {
         Navigator.pushReplacementNamed(context, '/studentHome');
      } else {
        Navigator.pushReplacementNamed(context, '/tutorHome');
      }
    }
  }
  late FirebaseAuth auth;
  late DatabaseService db;
  @override
  Widget build(BuildContext context) {
    auth = FirebaseAuth.instance;
    db = DatabaseService();

    //auth = Provider.of<FirebaseAuth>(context, listen: false);
   // db = Provider.of<DatabaseService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Profile Setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your name.' : null,
              onSaved: (value) => name = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number.' : null,
              onSaved: (value) => _phoneNumber = value,
            ),
            DropdownButtonFormField(
              value: _role,
              decoration: InputDecoration(labelText: 'Role'),
              items: ['student', 'tutor'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role[0].toUpperCase() + role.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _role = value.toString();
                });
              },
            ),
            TextFormField(
              controller: _subjectsController,
              decoration: InputDecoration(labelText: 'Subjects (comma separated)'),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter the subjects.' : null,
            ),
            if (_role == 'tutor')
              TextFormField(
                controller: _hourlyRateController,
                decoration: InputDecoration(labelText: 'Hourly Rate'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your hourly rate.' : null,
              ),
            ElevatedButton(
              child: Text('Pick profile picture'),
              onPressed: _pickImage,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
