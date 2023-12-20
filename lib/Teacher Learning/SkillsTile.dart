import 'package:auto_size_text/auto_size_text.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import 'Discussion.dart';
import 'Quiz Screen.dart';
import 'openPdfonline.dart';

class SkillsTile extends StatefulWidget {
  const SkillsTile({super.key, required this.title, required this.status, required this.currentLevel, required this.urls, required this.name, required this.quiz});
  final String title;
  final String status;
  final int currentLevel;
  final String name;
  final List<dynamic> urls;
  final Map<String ,dynamic> quiz;
  @override
  State<SkillsTile> createState() => _SkillsTileState();
}

class _SkillsTileState extends State<SkillsTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: ExpansionTile(
          title: AutoSizeText(
            widget.title,style: GoogleFonts.tiltNeon(
            fontSize: size.width*0.04,
            color: Colors.black
          ),
          ),
        trailing: SizedBox(
          width: size.width*0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AutoSizeText(
                "Status ${widget.status}",style: GoogleFonts.tiltNeon(
                  fontSize: size.width*0.04,
                  color: Colors.black
              ),
              ),

              // PopupMenuButton(
              //   onSelected: (value) async {
              //     if(value==0){
              //       final ref =  FirebaseFirestore.instance.collection("Discussion").doc(widget.name);
              //       await ref.get().then((value) async {
              //         if(value.exists){
              //           ref.update({
              //             "Members" : FieldValue.arrayUnion([usermodel["Email"]]),
              //             usermodel["Email"].toString().split("@")[0] : {
              //               "Name" : usermodel["Name"],
              //               "Count" : FieldValue.increment(0)
              //             }
              //           });
              //         }
              //         else{
              //           await ref.update({
              //             "Members" : FieldValue.arrayUnion([usermodel["Email"]]),
              //             usermodel["Email"].toString().split("@")[0] : {
              //               "Name" : usermodel["Name"],
              //               "Count" : FieldValue.increment(0)
              //             },
              //             "Messages" : []
              //           });
              //         }
              //       });
              //     }
              //   },
              //   itemBuilder: (context) {
              //   return [
              //     const PopupMenuItem(
              //       value: 0,
              //         child:
              //     )
              //   ];
              // },)
            ],
          ),
        ),
        children: [
          SizedBox(
            height: size.height*0.4,
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: CircleAvatar(
                        radius: size.width*0.03,
                        backgroundColor: widget.currentLevel > index ? Colors.green : Colors.red,
                      ),
                      title: AutoSizeText(
                        "Level ${index+1}",style: GoogleFonts.tiltNeon(
                          fontSize: size.width*0.04,
                          color: Colors.black
                      ),
                      ),
                      trailing: AutoSizeText(
                        widget.status,style: GoogleFonts.tiltNeon(
                          fontSize: size.width*0.04,
                          color: Colors.black
                      ),
                      ),
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return OnlinePdfViewer(url: widget.urls[index], name: "${widget.name} ${index+1}",);
                        },));
                    },
                  ),
                  index<3
                      ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: size.width*0.04),
                            child: SizedBox(
                              height: size.height*0.04,
                              child: VerticalDivider(
                                width: size.width*0.04,
                                color: Colors.black,
                                thickness: 5,

                              ),
                            ),
                          ),
                          index==2
                              ?
                          ListTile(
                              leading: CircleAvatar(
                                radius: size.width*0.03,
                                backgroundColor: widget.status =="Certified" ? Colors.green : Colors.red,
                              ),
                              title: AutoSizeText(
                                "Assignment",style: GoogleFonts.tiltNeon(
                                  fontSize: size.width*0.04,
                                  color: Colors.black
                              ),
                              ),
                              trailing: AutoSizeText(
                                widget.status,style: GoogleFonts.tiltNeon(
                                  fontSize: size.width*0.04,
                                  color: Colors.black
                              ),
                              ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return QuizScreen(notesId: widget.currentLevel,subject: "${widget.name}");
                              },));
                            },
                          )
                          :const SizedBox(),
                        ],
                      )
                      :
                      const SizedBox()
                ],
              );
            },),
          ),
          TextButton(
            onPressed: ()async {
              final ref =  FirebaseFirestore.instance.collection("Discussion").doc(widget.name);
              await ref.get().then((value) async {
                if(value.exists){
                  ref.update({
                    "Members" : FieldValue.arrayUnion([usermodel["Email"]]),
                    usermodel["Email"].toString().split("@")[0] : {
                      "Name" : usermodel["Name"],
                      "Count" : FieldValue.increment(0)
                    }
                  }).whenComplete(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Discussion(channel: widget.name);

                    },));
                  });
                }
                else{
                  await ref.set({
                    "Members" : FieldValue.arrayUnion([usermodel["Email"]]),
                    usermodel["Email"].toString().split("@")[0] : {
                      "Name" : usermodel["Name"],
                      "Count" : FieldValue.increment(0)
                    },
                    "Messages" : []
                  }).whenComplete((){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Discussion(channel: widget.name);

                    },));
                  });
                }
              });

            },
            child: AutoSizeText("Discussion group"),),
        ],
    ),
    );
  }
}
