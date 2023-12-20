import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';


class TeacherPostTile extends StatefulWidget {
  TeacherPostTile({super.key,required this.email,required this.postImageUrl,required this.name,required this.stamp,required this.topicName,required this.topicDescription,required this.doc,required this.userProfile,required this.usefull,required this.commentBy});
  String email;
  String postImageUrl;
  String name;
  Timestamp stamp;
  String topicName;
  String topicDescription;
  String doc;
  String userProfile;
  int usefull;
  var commentBy;
  @override
  State<TeacherPostTile> createState() => _PageState();
}

class _PageState extends State<TeacherPostTile> {
  bool isLike=false;
  bool isComment=false;
  bool add=false;
  bool isLikeComment=false;
  TextEditingController commentController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Data is : ${widget.commentBy}");
  }
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Card(
      elevation: 30,
      shape: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
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
                usermodel["Profile-URL"]!=null
                    ?
                Image.network(usermodel["Profile-URL"])
                    :
                AutoSizeText(
                  usermodel["Name"].toString().substring(0,1),
                  style: GoogleFonts.tiltNeon(
                      color: Colors.black,
                      fontSize: size.height*0.035,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            title: AutoSizeText(widget.name),
            subtitle:  const AutoSizeText("Teacher"),
            trailing: IconButton(
              onPressed: () async {
                if(!isLike){
                  await FirebaseFirestore.instance.collection("Teachers Post").doc("${widget.doc}").update({
                    "Liked by":FieldValue.arrayUnion([usermodel["Email"]]),
                    "usefully":FieldValue.increment(1)
                  });
                }
                else{
                  await FirebaseFirestore.instance.collection("Teachers Post").doc("${widget.doc}").update({
                    "Liked by":FieldValue.arrayRemove([usermodel["Email"]]),
                  "usefully":FieldValue.increment(-1)
                  });
                }
                setState(() {
                  isLike=!isLike;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              icon:isLike
                  ?
              Icon(Icons.thumb_up,size: size.height*0.03,color: Colors.pinkAccent,)
                  :
              Icon(Icons.thumb_up,size: size.height*0.03,color:Colors.black26),
            ),

          ),
          Divider(
            color: Colors.black,
            height: size.height*0.015,
            thickness: 1,
            endIndent: size.height*0.02,
            indent: size.height*0.02,
          ),
          SizedBox(height: size.height*0.01,),
          Padding(
            padding: EdgeInsets.only(left: size.width*0.04),
            child:  AutoSizeText(widget.topicName,
              style: GoogleFonts.tiltNeon(
                  fontWeight: FontWeight.w400,
                  fontSize: size.height*0.022,
                  color: Colors.black
              ),),
          ),
          SizedBox(height: size.height*0.01,),
          Padding(
            padding: EdgeInsets.only(left: size.width*0.04),
            child:  AutoSizeText(widget.topicDescription),
          ),
          SizedBox(height: size.height*0.01,),
          SizedBox(
            width: size.width,
            height:widget.postImageUrl!="null"? size.height*0.3:size.height*0,
            child:
            widget.postImageUrl.toString()!="null"
                ?
            Image.network(widget.postImageUrl,fit: BoxFit.scaleDown,)
                :
            const SizedBox(),
          ),
          ListTile(
            leading: SizedBox(
              width: size.width*0.38,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {

                      setState(() {
                        isComment=!isComment;
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                    icon:isComment
                        ?
                    Icon(Icons.comment,size: size.height*0.03,color: Colors.pinkAccent,)
                        :
                    Icon(Icons.comment,size: size.height*0.03,color:Colors.black26),
                  ),
                ],
              ),
            ),
            trailing: AutoSizeText("Date : ${widget.stamp.toDate().toString().split(" ")[0]}",
              style: GoogleFonts.tiltNeon(
                  fontSize: size.height*0.02
              ),),
          ),
          isComment
          ?
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: Colors.transparent,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: size.width*0.045,
                    ),
                    SizedBox(
                      width: size.width*0.9,
                      child: TextField(
                        controller: commentController,
                        maxLines: 1,
                        decoration:  InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                              onPressed: () async {
                               if(!add)
                                 {
                                   Timestamp stamp=Timestamp.now();
                                   await FirebaseFirestore.instance.collection("Teachers Post")
                                       .doc(widget.doc)
                                       .update({
                                     "Comment By":FieldValue.arrayUnion([{
                                       "Name":usermodel["Name"],
                                       "Email":usermodel["Email"],
                                       "Stamp":stamp,
                                       "Description":commentController.text.toString(),
                                     }]),
                                     "usefully":FieldValue.increment(1)
                                   }).whenComplete(() async {
                                     await FirebaseFirestore.instance.collection("Teachers Point")
                                         .doc("Teachers Point")
                                         .update({
                                       usermodel["Email"].toString().split("@")[0]:FieldValue.increment(1),
                                       widget.email.toString().split("@")[0]:FieldValue.increment(1)
                                     }).whenComplete(() {
                                       setState(() {
                                         commentController.clear();
                                       });
                                     });
                                   });

                                 }
                               setState(() {
                                 add=!add;
                               });

                              },
                           icon: Icon(Icons.add,size: size.height*0.035,color: Colors.green,)),
                           hintText: "Add Comment",
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.black,
                  height: size.height*0.015,
                  thickness: 1,
                  endIndent: size.height*0.02,
                  indent: size.height*0.02,
                ),
               SizedBox(
                 width: size.width*0.9,
                 child: ListView.builder(
                   itemCount: widget.commentBy.length,
                   shrinkWrap: true,
                   itemBuilder: (context, index) {
                     print("Response is :${widget.commentBy[index]["Description"]}");
                   return Padding(
                     padding:  EdgeInsets.only(top:size.height*0.01,bottom: size.height*0.01),
                     child: AnimatedContainer(

                       duration: const Duration(milliseconds: 100),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(size.height*0.015)),
                             border: Border.all(
                               color: Colors.black,
                               width: 1
                             )
                           ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                               Container(
                                 height: size.height*0.05,
                                 child: ListTile(
                                   tileColor: Colors.transparent,
                                   leading: CircleAvatar(
                                     radius: size.width*0.038,
                                     backgroundColor: Colors.black,
                                     child: CircleAvatar(
                                       radius: size.width*0.035,
                                       backgroundColor: Colors.green,

                                       child: AutoSizeText(
                                         widget.name.toString().substring(0,1),
                                         style: GoogleFonts.tiltNeon(
                                             color: Colors.black,
                                             fontSize: size.height*0.035,
                                             fontWeight: FontWeight.w600
                                         ),
                                       ),
                                     ),
                                   ),
                                   title: AutoSizeText(widget.commentBy[index]["Name"]),
                                   trailing: IconButton(
                                     onPressed: () async {
                                      if(!isLikeComment)
                                        {
                                          await FirebaseFirestore.instance.collection("Teachers Point").doc("Teachers Point").update({
                                            widget.commentBy[index]["Email"].toString().split("@")[0]:FieldValue.increment(1)
                                          });
                                        }
                                      else{
                                        await FirebaseFirestore.instance.collection("Teachers Point").doc("Teachers Point").update({
                                        widget.commentBy[index]["Email"].toString().split("@")[0]:FieldValue.increment(-1)
                                        });
                                        
                                      }
                                       setState(() {
                                         isLikeComment=!isLikeComment;
                                       });
                                     },
                                     style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                                     icon:isLikeComment
                                         ?
                                     Icon(Icons.thumb_up,size: size.height*0.02,color: Colors.pinkAccent,)
                                         :
                                     Icon(Icons.thumb_up,size: size.height*0.02,color:Colors.black26),
                                   ),
                                 ),
                               ),
                           Divider(
                             color: Colors.black,
                             thickness: 1,
                             endIndent: size.height*0.02,
                             indent: size.height*0.02,
                           ),


                           SizedBox(
                             height: size.height*0.01,
                           ),
                           Row(
                             children: [
                               SizedBox(width: size.width*0.035,),
                               AutoSizeText(widget.commentBy[index]["Description"].toString(),
                               style: GoogleFonts.openSans(
                                 color: Colors.black,
                                 fontSize: size.height*0.018
                               ),),
                             ],
                           ),
                           SizedBox(
                             height: size.height*0.01,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               AutoSizeText("Date : ${widget.commentBy[index]["Stamp"].toDate().toString().split(" ")[0]}",
                                 style: GoogleFonts.tiltNeon(
                                     fontSize: size.height*0.01
                                 ),),
                               SizedBox(width: size.width*0.01,)
                             ],
                           ),
                         ],
                       ),
                     ),
                   );

                 },),
               )

              ],
            )

          )
              :
              const SizedBox()
        ],
      ),
    );
  }
}
