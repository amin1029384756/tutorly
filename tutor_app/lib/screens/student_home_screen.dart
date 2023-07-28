import 'package:flutter/material.dart';
import 'package:tutor_app/models/user_profile.dart';
import 'package:tutor_app/screens/tutor_profile_screen.dart';
import 'package:tutor_app/services/database_service.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final _firestoreService = DatabaseService();
  List<UserProfile> _tutors = [];

  @override
  void initState() {
    super.initState();
    _fetchTutors();
  }

  void _fetchTutors() async {
    try {
      List<String> subjects = ["Math", "Science"]; // Add a method to get student's subjects.
      _tutors = await _firestoreService.getTutorsBasedOnSubjects(subjects);
      setState(() {});
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor List'),
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

      body:_tutors.length != 0? ListView.builder(
        itemCount: _tutors.length,
        itemBuilder: (context, index) {
          final tutor = _tutors[index];
          print("tutor.rating");
          print(tutor.rating);
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(tutor.profilePicture ?? '')),
            title: Text(tutor.email),
            subtitle: Text('Subjects: ${tutor.subjects.join(', ')}'),
            trailing: Text('Rating: ${tutor.rating}/5'),
            onTap: () {
              print(tutor.uid);
              // add function to view tutor profile
              //Navigator.pushNamed(context, '/tutorProfile',arguments: Tutor_Profile_Screen(uid: tutor.uid));
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Tutor_Profile_Screen(uid:tutor.uid))).then((value){
                _fetchTutors();
              });

            },
          );
        },
      ) : Container(child: Center(child: Text("No Data Found"))),
    );
  }
}