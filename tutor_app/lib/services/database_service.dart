import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/models/user_profile.dart';

class DatabaseService {
 // final CollectionReference _userProfileCollection = FirebaseFirestore.instance.collection('userProfiles');
  final CollectionReference _userProfileCollection = FirebaseFirestore.instance.collection('users');

  Future<void> setUserProfile(UserProfile userProfile) async {
    try {
      await _userProfileCollection.doc(userProfile.uid).set(userProfile.toMap());
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
      throw e;
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      await _userProfileCollection.doc(userProfile.uid).update(userProfile.toMap());
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
      throw e;
    }
  }

  Future<UserProfile> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _userProfileCollection.doc(uid).get();
      return UserProfile.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
      throw e;
    }
  }

  Future<List<UserProfile>> getTutorsBasedOnSubjects(List<String> subjects) async {
    try {
      //QuerySnapshot querySnapshot = await _userProfileCollection.where('isTutor', isEqualTo: true).get();
      QuerySnapshot querySnapshot = await _userProfileCollection.where('role', isEqualTo: "tutor").get();
      print("querySnapshot");
      print(querySnapshot.docs);
      List<UserProfile> tutors = querySnapshot.docs.map((doc) => UserProfile.fromMap(doc.data() as Map<String, dynamic>)).toList();
      return tutors.where((tutor) => tutor.subjects.any((subject) => subjects.contains(subject))).toList();
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
      throw e;
    }
  }

  Future<List<UserProfile>> getStudentsBasedOnSubjects(List<String> subjects) async {
    try {
      //QuerySnapshot querySnapshot = await _userProfileCollection.where('isTutor', isEqualTo: false).get();
      QuerySnapshot querySnapshot = await _userProfileCollection.where('role', isEqualTo: "student").get();
      print("querySnapshot getStudentsBasedOnSubjects");
      print(querySnapshot.docs.first);
      List<UserProfile> students = querySnapshot.docs.map((doc) => UserProfile.fromMap(doc.data() as Map<String, dynamic>)).toList();
      print(students.length);
      return students.where((student) => student.subjects.any((subject) => subjects.contains(subject))).toList();
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
      throw e;
    }
  }
}