
import 'package:campus_link_teachers/Achievements/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../Constraints.dart';
import 'add_post.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({Key? key}) : super(key: key);

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Achievements")
            .orderBy("Time-Stamp", descending: true)
            .orderBy("Likes", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data?.docs[0].data());
          return snapshot.hasData
              ?
          ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,

                  itemBuilder: (context, index) {
                    return (snapshot.data!.docs[index].data()["Liked by"]!=null
                        ||
                        (snapshot.data!.docs[index].data()["Liked by"] != null && !snapshot.data!.docs[index].data()["Liked by"].contains(usermodel["Email"])))
                        ||
                        (snapshot.data!.docs[index].data()["Disliked by"]==null ||  !snapshot.data!.docs[index].data()["Disliked by"].contains(usermodel["Email"]))
                    ?
                    PostTile(
                      email: snapshot.data?.docs[index].data()["Email"],
                      postImageUrl: snapshot.data!.docs[index].data()["Image-URL"].toString(),
                      likes: snapshot.data?.docs[index].data()["Likes"],
                      name: snapshot.data?.docs[index].data()["Name"],
                      stamp: snapshot.data!.docs[index].data()["Time-Stamp"],
                      topicName: snapshot.data?.docs[index].data()["Topic"],
                      topicDescription: snapshot.data?.docs[index]
                          .data()["Topic-Description"],
                      postedBy:
                      snapshot.data!.docs[index].data()["Post by"],
                      doc: snapshot.data!.docs[index].data()["doc"],
                      userProfile:snapshot.data!.docs[index].data()["Profile_URL"].toString(),
                      alreadyLiked:
                      snapshot.data!.docs[index].data()["Like by"]!=null
                        ?
                      snapshot.data!.docs[index].data()["Like by"].contains(usermodel["Email"])
                      :
                      false,
                    )
                    :
                    const SizedBox();




                  },
                )
              :
          const SizedBox();
        },
      ),
      floatingActionButton: Container(
        height: size.height*0.072,
        width: size.height*0.072,
        decoration:  BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.all(Radius.circular( size.height*0.072))
        ),
        child: InkWell(
          onTap: (){
            Navigator.push(context, PageTransition(
              child: const addPost(),
              type: PageTransitionType.bottomToTopJoined,
              duration: const Duration(milliseconds: 400),
              alignment: Alignment.bottomCenter,
              childCurrent: const AchievementPage(),
            ),);
          },
            child: Icon(Icons.add,size: size.height*0.04,color: Colors.white70,weight: 5,)),
      ),
    );
  }
}
