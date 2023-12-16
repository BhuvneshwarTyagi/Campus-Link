import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class MyPost extends StatefulWidget {
  const MyPost({Key? key}) : super(key: key);

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  bool isLike=false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: StreamBuilder(
        stream:  FirebaseFirestore.instance
            .collection("Achievements").where("Email",isEqualTo: usermodel["Email"])
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
              return Padding(
                padding:  EdgeInsets.only(top:size.height*0.004),
                child: AnimatedContainer(
                  decoration:  BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1
                    ),
                    color: Colors.white,
                  ),
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        tileColor: Colors.transparent,
                        leading:  CircleAvatar(
                          radius: size.width*0.08,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: size.width*0.062,
                            backgroundColor: Colors.green,
                            child:
                            snapshot.data?.docs[index].data()["Profile_URL"]!=null
                                ?
                            Image.network(snapshot.data?.docs[index].data()["Profile_URL"])
                                :
                            AutoSizeText(snapshot.data!.docs[index].data()["Name"].toString().substring(0,1),
                              style:GoogleFonts.exo(
                                  color: Colors.black,
                                  fontSize: size.height*0.035,
                                  fontWeight: FontWeight.w600
                              ) ,)
                            ,
                          ),
                        ),
                        title: AutoSizeText(snapshot.data!.docs[index].data()["Name"]),
                        subtitle:  AutoSizeText(snapshot.data!.docs[index].data()["Post by"]),
                        trailing: Container(
                            height: size.height*0.053,
                            width: size.width*0.065,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Center(child: Column(
                              children: [
                                snapshot.data!.docs[index].data()["Likes"]==0
                                ?
                                Icon(Icons.thumb_up,size: size.height*0.03,color: Colors.blueGrey,)
                                :
                                Icon(Icons.thumb_up,size: size.height*0.03,color: Colors.pinkAccent,),
                                AutoSizeText("${snapshot.data!.docs[index].data()["Likes"]}")
                              ],
                            ))

                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        height: size.height*0.015,
                        thickness: 1,
                        endIndent: size.height*0.02,
                        indent: size.height*0.02,
                      ),
                      SizedBox(height: size.height*0.02,),
                      Padding(
                        padding: EdgeInsets.only(left: size.width*0.026),
                        child:  AutoSizeText(snapshot.data!.docs[index].data()["Topic"],
                          style: GoogleFonts.tiltNeon(
                              fontWeight: FontWeight.w400,
                              fontSize: size.height*0.022,
                              color: Colors.black
                          ),),
                      ),
                      SizedBox(height: size.height*0.02,),
                      Padding(
                        padding: EdgeInsets.only(left: size.width*0.026),
                        child:  AutoSizeText(snapshot.data!.docs[index].data()["Topic-Description"]),
                      ),
                      SizedBox(height: size.height*0.02,),
                      SizedBox(
                        width: size.width,
                        height:snapshot.data!.docs[index].data()["Image-URL"].toString()!="null"? size.height*0.5:size.height*0,
                        child:
                        snapshot.data!.docs[index].data()["Image-URL"].toString()!="null"
                            ?
                        Image.network(snapshot.data!.docs[index].data()["Image-URL"],fit: BoxFit.cover,)
                            :
                        const SizedBox(),
                      ),
                      Container(
                        height: size.height*0.022,
                        color: Colors.white70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end ,
                          children: [
                            SizedBox(
                              width: size.width*0.02,
                            ),
                            Padding(
                              padding:  EdgeInsets.all(size.height*0.001),
                              child: AutoSizeText("Date : ${snapshot.data!.docs[index].data()["Time-Stamp"].toDate().toString().split(" ")[0]}",
                                style: GoogleFonts.exo(
                                    fontSize: size.height*0.02
                                ),),
                            ),
                            SizedBox(
                              width: size.width*0.02,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },)
          :
          const SizedBox(
            child: Center(child: AutoSizeText("No Post Created Yet")),
          );
        },
      ),
    );
  }
}
