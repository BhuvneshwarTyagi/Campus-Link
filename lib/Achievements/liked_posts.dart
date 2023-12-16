import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Achievements/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class LikedPost extends StatefulWidget {
  const LikedPost({Key? key}) : super(key: key);

  @override
  State<LikedPost> createState() => _LikedPostState();
}

class _LikedPostState extends State<LikedPost> {

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: StreamBuilder(
        stream:  FirebaseFirestore.instance
            .collection("Achievements").where("Liked by",arrayContains: usermodel["Email"])
            .orderBy("Time-Stamp", descending: true)
            .orderBy("Likes", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ?
          ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return PostTile(
                  email: snapshot.data?.docs[index].data()["Email"],
                  postImageUrl: snapshot.data!.docs[index].data()["Image-URL"].toString(),
                  likes: snapshot.data?.docs[index].data()["Likes"],
                  name: snapshot.data?.docs[index].data()["Name"],
                  stamp: snapshot.data?.docs[index].data()["Time-Stamp"],
                  topicName: snapshot.data?.docs[index].data()["Topic"],
                  topicDescription: snapshot.data?.docs[index].data()["Topic-Description"],
                  postedBy: snapshot.data?.docs[index].data()["Post by"],
                  doc: snapshot.data?.docs[index].data()["doc"],
                  userProfile: snapshot.data?.docs[index].data()["User_Profile"],
                  alreadyLiked: true
              );
            },)
              :
          const SizedBox(
            child: Center(child: AutoSizeText("No Post Liked Yet")),
          );
        },
      ),
    );
  }
}
