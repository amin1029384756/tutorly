import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Please Enter";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Please Enter";
                  } else {
                    return null;
                  }
                }),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential =
                          await _auth.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      User? user = userCredential.user;
                      if (userCredential.user != null) {
                        await _auth
                            .authStateChanges()
                            .listen(_authStateChanges(user));
                      } else {
                        print("Something went wrong!");
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "user-not-found") {
                        print("No user found with that email");
                      } else if (e.code == "wrong-password") {
                        print("Wrong password provided for that email");
                      }
                    }
                  }
                },
                child: Text("Login")),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Text("Register"))

          ],
        ),
      ),
    );
  }

  _authStateChanges(User? user) async {
    print("Check1");
    if (user != null) {
      print("Check2");
      // Fetch the user's role and navigate to the appropriate screen.
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
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
      Navigator.pushReplacementNamed(context, '/register');
    }
  }
}
