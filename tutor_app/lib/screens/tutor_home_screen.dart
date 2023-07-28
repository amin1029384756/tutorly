import 'package:flutter/material.dart';
import 'package:tutor_app/models/user_profile.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:tutor_app/services/database_service.dart';

class TutorHomeScreen extends StatefulWidget {
  @override
  _TutorHomeScreenState createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  final _firestoreService = DatabaseService();
  List<UserProfile> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  void _fetchStudents() async {
    try {
      List<String> subjects = ["Math", "Science"]; // Add a method to get tutor's subjects.
      _students = await _firestoreService.getStudentsBasedOnSubjects(subjects);
      setState(() {});
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),

      body:_students.length != 0?
      ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(student.profilePicture ?? '')),
            title: Text(student.email),
            subtitle: Text(student.subjects.join(', ')),
          );
        },
      ) :  Container(child: Center(child: Text("No Data Found"),)),
    );
  }
}
