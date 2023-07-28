import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/user_profile.dart';
import '../services/database_service.dart';

class Tutor_Profile_Screen extends StatefulWidget {
  Tutor_Profile_Screen({
    super.key,
    required this.uid,
  });

  String uid;


  @override
  State<StatefulWidget> createState() => tutor_profile();
}

class tutor_profile extends State<Tutor_Profile_Screen> {
  final _firestoreService = DatabaseService();
  UserProfile? userProfile;
  double rate_update = 0;
  bool progress_update = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.uid");
    print(widget.uid);
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    try {
      userProfile = await _firestoreService.getUserProfile(widget.uid);
      rate_update = userProfile!.rating;
      setState(() {});
    } catch (e) {
      print(e); // In production, handle the exception gracefully.
    }
  }

  @override
  Widget build(BuildContext context) {


    return userProfile != null
        ? Scaffold(
            appBar: AppBar(
              title: Text("${userProfile?.name ?? "Unknown"}"),
            ),
            body: Container(
                margin: EdgeInsets.all(15),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProfile?.profilePicture ?? '',
                      ),
                      radius: 50,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "${userProfile?.name ?? "Unknown"}",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(
                            "Email :",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            "${userProfile?.email ?? "Unknown"}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(
                            "Phone Number :",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            "${userProfile?.phoneNumber ?? "Unknown"}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                        "Subject :",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),

                          Flexible(
                            child: Text(
                              "${userProfile?.subjects.join(', ') ?? "Unknown"}",maxLines: 2,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(
                            "Rate :",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            "${userProfile?.rating ?? "Unknown"}/5",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: userProfile!.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                         rate_update = rating;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          progress_update = true;
                           userProfile!.rating = rate_update;
                           _firestoreService.updateUserProfile(userProfile!).whenComplete(() {
                             progress_update = false;
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rating Successfully update")));
                             setState(() {

                             });
                           });

                        },
                        child: !progress_update ?  Text("Rating") : CircularProgressIndicator()),
                  ],
                )))
        : Center(child: CircularProgressIndicator());
  }
}
