class UserProfile {
  String uid;
  String? profilePicture;
  String? name;
  String email;
  String phoneNumber;
  String role; // 'student' or 'tutor'
  List<String> subjects;
  Map<String, double> hourlyRate; // Map subjects to rates.
  double rating;

  UserProfile({
    required this.uid,
    this.profilePicture,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.subjects,
    required this.hourlyRate,
    required this.rating,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      profilePicture: map['profilePicture'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      subjects: List<String>.from(map['subjects']),
      hourlyRate: Map<String, double>.from(map['hourlyRate']),
      rating: double.parse(map['rating'].toString()),
    );
  }

  // Convert UserProfile to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'profilePicture': profilePicture,
      'name':name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'subjects': subjects,
      'hourlyRate': hourlyRate,
      'rating': rating,
    };
  }
}