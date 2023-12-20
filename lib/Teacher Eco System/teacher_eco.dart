import 'package:campus_link_teachers/Teacher%20Eco%20System/teacher_post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Constraints.dart';
import 'add_new_post.dart';

class teacherEcoSystem extends StatefulWidget {
  const teacherEcoSystem({Key? key}) : super(key: key);

  @override
  State<teacherEcoSystem> createState() => _teacherEcoSystemState();
}

class _teacherEcoSystemState extends State<teacherEcoSystem> {
  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
          title: Container(
            height: size.height*0.05,
            width: size.width*0.72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(size.height*0.02))
            ),
            child:TextField(
              controller: searchController,
              maxLines: 1,
              decoration:  InputDecoration(
                suffixIcon: Icon(Icons.search,size: size.height*0.026,color: Colors.black,),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(size.height*0.02)),
                )
                // other decoration properties...
              ),

            ),

          ),
        ),
        body:  StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Teachers Post")
              .orderBy("Time-Stamp", descending: true)
              .orderBy("usefully", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.data!=null
                ?
            ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,

              itemBuilder: (context, index) {
                return
                  TeacherPostTile(
                    email: snapshot.data?.docs[index].data()["Email"],
                    postImageUrl: snapshot.data!.docs[index].data()["Image-URL"].toString(),
                    usefull: snapshot.data?.docs[index].data()["usefully"] ?? false,
                    name: snapshot.data?.docs[index].data()["Name"],
                    stamp: snapshot.data!.docs[index].data()["Time-Stamp"],
                    topicName: snapshot.data?.docs[index].data()["Topic"],
                    topicDescription: snapshot.data?.docs[index]
                        .data()["Topic-Description"],
                    doc: snapshot.data!.docs[index].data()["doc"],
                    userProfile:snapshot.data!.docs[index].data()["Profile_URL"].toString(),
                    commentBy: snapshot.data!.docs[index].data()["Comment By"] ?? ""
                    ,
                  );
              },
            )
                :
            const SizedBox();
          },
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height:size.height*0.065,
              width: size.height*0.065,
              decoration: const BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.circle
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                onPressed: (){
                  Navigator.push(context, PageTransition(
                    child: const AddTeacherPost(),
                    type: PageTransitionType.bottomToTopJoined,
                    duration: const Duration(milliseconds: 400),
                    alignment: Alignment.bottomCenter,
                    childCurrent: const teacherEcoSystem(),
                  ),);
                },
                child: Icon(Icons.add,size:size.height*0.035,color: Colors.white),
              ),
            ),
            SizedBox(
              width: size.width*0.02,
            )
          ],
        ),
      ),
    );
  }
}
