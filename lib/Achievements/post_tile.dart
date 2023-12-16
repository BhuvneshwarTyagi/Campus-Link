import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class PostTile extends StatefulWidget {
   PostTile({super.key,required this.email,required this.postImageUrl,required this.likes,required this.name,required this.stamp,required this.topicName,required this.topicDescription,required this.postedBy,required this.doc,required this.userProfile,required this.alreadyLiked});
   String email;
   String postImageUrl;
   int likes;
   String name;
   Timestamp stamp;
   String topicName;
   String topicDescription;
   String postedBy;
   String doc;
   String userProfile;
   bool alreadyLiked;
  @override
  State<PostTile> createState() => _PageState();
}

class _PageState extends State<PostTile> {
  bool isLike=false;
  @override
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
            subtitle:  AutoSizeText(widget.postedBy),

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
              width: size.width*0.25,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("Achievements").doc(widget.doc).update({
                          "Likes":FieldValue.increment(1),
                          "Liked by":FieldValue.arrayUnion([usermodel["Email"]])
                        });
                        setState(() {
                          isLike=!isLike;
                        });

                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                    icon: widget.alreadyLiked || isLike
                        ?
                    Icon(Icons.thumb_up,size: size.height*0.03,color: Colors.pinkAccent,)
                        :
                    Icon(Icons.thumb_up,size: size.height*0.03,color:Colors.black26),
                  ),
                  IconButton(
                    onPressed: () async {

                        print("${widget.email.toString().split("@")[0]}-${widget.stamp.toDate()}");
                        await FirebaseFirestore.instance
                            .collection("Achievements").doc(widget.doc).update({
                          "Dislikes":FieldValue==0?0:FieldValue.increment(1),
                          "Disliked by":FieldValue.arrayUnion([usermodel["Email"]])
                        });
                        setState(() {
                          isLike=!isLike;
                        });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                    icon: widget.alreadyLiked || isLike
                        ?
                    Icon(Icons.thumb_down,size: size.height*0.03,color: Colors.pinkAccent,)
                        :
                    Icon(Icons.thumb_down,size: size.height*0.03,color:Colors.black26),
                  ),
                ],
              ),
            ),
            trailing: AutoSizeText("Date : ${widget.stamp.toDate().toString().split(" ")[0]}",
              style: GoogleFonts.tiltNeon(
                  fontSize: size.height*0.02
              ),),
          ),
        ],
      ),
    );
  }
}
