import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/screens/tutor_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/student_home_screen.dart';
import 'screens/tutor_home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TutorMatchApp());
}

class TutorMatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutor Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitializerWidget(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/profileSetup': (context) => ProfileSetupScreen(),
        '/studentHome': (context) => StudentHomeScreen(),
        '/tutorHome': (context) => TutorHomeScreen(),
      },
    );
  }
}

class InitializerWidget extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  late FirebaseAuth _auth;
  bool use_data = false;

  @override
  void initState() {
    super.initState();

  }

  _check()async{
    User? user = _auth.currentUser;
    print("user?.email.toString()");
    print(user?.email.toString());
    if (user != null) {
      await _auth.authStateChanges().listen(_authStateChanges(user));
    }else{
      use_data = true;

      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });

    }
  }

   _authStateChanges(User? user) async {
    print("Check1");
    if (user != null) {
      print("Check2");
      // Fetch the user's role and navigate to the appropriate screen.
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      print("doc['userRole']");
      print(doc['userRole']);
      if (doc['userRole'] == 'student') {
        Navigator.pushReplacementNamed(context, '/studentHome');
        //Navigator.pushReplacementNamed(context, '/profileSetup');
      } else {
        Navigator.pushReplacementNamed(context, '/tutorHome');
      }
    } else {
      print("Check3");
       Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is just a placeholder until the auth state change listener
    // gives us a new user or tells us that there is no user signed in.
    _auth = FirebaseAuth.instance;
    _check();
    return Scaffold(
      body:
      use_data ?
      Container(child: Center(child: Text("Something went wrong!"),)):
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}