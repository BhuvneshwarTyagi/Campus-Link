import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';



class Chat_Info extends StatefulWidget {
  const Chat_Info({super.key, required this.channel, required this.membersCount, required this.url});
  final String channel;
  final int membersCount;
  final String url;
  @override
  State<Chat_Info> createState() => _Chat_InfoState();
}


class _Chat_InfoState extends State<Chat_Info> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        leading:
          IconButton(
              onPressed: (){
                Navigator.pop(context);
                },
              icon: const Icon(Icons.arrow_back_ios_new)
          )
        ,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.black12
              ),
                 height: size.height*0.35,
              padding: EdgeInsets.all(size.width*0.03),
              child:  Column(
                children: [
                  SizedBox(
                    height: size.height*0.03,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: size.height*0.07,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: NetworkImage(widget.url),
                        child:widget.url==null?
                        AutoSizeText(widget.channel.split(" ")[6])
                        :
                          null
                    ),
                      Positioned(
                        bottom: -5,
                        right: size.height*0.01,
                        child: IconButton(
                          icon: Icon(Icons.camera_enhance,size:size.height*0.03 ,color: Colors.white,),
                          onPressed: () async {

                            ImagePicker imagePicker=ImagePicker();
                            print(imagePicker);
                            XFile? file=await imagePicker.pickImage(source: ImageSource.gallery);
                            print(file?.path);

                            // Create reference of Firebase Storage

                            Reference reference=FirebaseStorage.instance.ref();

                            // Create Directory into Firebase Storage

                            Reference image_directory=reference.child("User_profile");


                            Reference image_folder=image_directory.child("${usermodel["Email"]}");

                            await image_folder.putFile(File(file!.path)).whenComplete(() async {
                              String download_url=await image_folder.getDownloadURL();
                              print("uploaded");
                              print(download_url);
                              await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                "image_URL":download_url,
                              });
                              setState(() {
                                database().fetchuser();
                              });
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height*0.018,
                  ),
                  AutoSizeText(
                      widget.channel,
                    style: GoogleFonts.exo(
                      color: Colors.black,
                      fontSize: size.height*0.025,
                      fontWeight:FontWeight.w600
                    ),


                      ),
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  AutoSizeText(
                    "Group : ${widget.membersCount} participants",
                    style: GoogleFonts.exo(
                        color: Colors.black,
                        fontSize: size.height*0.02,
                        fontWeight:FontWeight.w600
                    ),


                  ),

                ],
              ),
            ),
            SizedBox(
              height: size.height*0.01,
            ),

            Container(
              height: size.height*0.1,
              width: size.width,
              decoration: const BoxDecoration(

                color: Colors.black12
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   AutoSizeText(
                     "About Group",
                     style: GoogleFonts.exo(
                     color: Colors.indigo,
                   fontSize: size.height*0.024,
                   fontWeight: FontWeight.w600
                   ),

                   ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Row(
                      children: [
                        AutoSizeText(
                          "Created by ",
                          style:GoogleFonts.exo(
                            fontSize: size.height*0.019,
                            fontWeight: FontWeight.w500
                          ) ,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ?
                            AutoSizeText(
                              "${snapshot.data!.data()?["CreatedOn"]["Name"]}, ${snapshot.data!.data()?["CreatedOn"]["Date"].toDate().day}/${snapshot.data!.data()?["CreatedOn"]["Date"].toDate().month}/${snapshot.data!.data()?["CreatedOn"]["Date"].toDate().year}",
                              style:GoogleFonts.exo(
                                  fontSize: size.height*0.019,
                                  fontWeight: FontWeight.w500
                              ) ,
                            )
                            :
                                const SizedBox();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            Container(
              height: size.height,
              decoration: const BoxDecoration(

                  color: Colors.black12
              ),
              child:  Column(
                children: [
                  SizedBox(
                    height:size.height*0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "   ${widget.membersCount} participants",
                          style: GoogleFonts.exo(
                              color: Colors.black,
                              fontSize: size.height*0.02,
                              fontWeight:FontWeight.w400
                          ),


                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.4,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
                      builder: (context, snapshot) {
                        return ListView.builder(

                          itemCount: snapshot.data?.data()!["Members"].length,
                          itemBuilder: (context, index) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection(snapshot.data?.data()!["Members"][index]["Post"]).doc(snapshot.data?.data()!["Members"][index]["Email"]).snapshots(),
                            builder: (context, snapshot2) {
                              return snapshot2.hasData
                                  ?
                              Padding(
                                padding:  EdgeInsets.all(size.height*0.009),
                                child: SizedBox(
                                  height: size.height*0.06,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Row(

                                             children: [
                                               CircleAvatar(
                                                 radius: size.width*0.07,
                                                 backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                                                 child: snapshot2.data?.data()!["Profile_URL"]!=null
                                                     ?
                                                 Image(image: NetworkImage(snapshot2.data?.data()!["Profile_URL"]))
                                                     :
                                                 AutoSizeText( snapshot2.data?.data()!["Name"].toString().substring(0,1) ?? "A",
                                                   style: GoogleFonts.exo(
                                                       fontSize: size.height*0.022,
                                                       fontWeight: FontWeight.w600
                                                   ),
                                                 ),


                                               ),
                                               SizedBox(
                                                 width: size.width*0.02,
                                               ),
                                               Column(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 crossAxisAlignment: CrossAxisAlignment.start,

                                                 children: [
                                                   AutoSizeText( snapshot2.data?.data()!["Name"],
                                                     style: GoogleFonts.exo(
                                                         fontSize: size.height*0.022,
                                                         fontWeight: FontWeight.w600
                                                     ),
                                                   ),
                                                   AutoSizeText(
                                                     "User_description",
                                                     style: GoogleFonts.exo(
                                                         fontSize: size.height*0.01,
                                                         fontWeight: FontWeight.w500
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                               SizedBox(
                                                 width: size.width*0.18,
                                               ),
                                             ],
                                           ),
                                           snapshot.data?.data()!["Admins"].contains(usermodel["Email"])
                                           ?
                                           Container(
                                             height: size.height*0.03,
                                             width: size.width*0.22,
                                             decoration: BoxDecoration(
                                                 shape: BoxShape.rectangle,
                                                 borderRadius: BorderRadius.all(Radius.circular(8)),
                                                 border: Border.all(
                                                     color: Colors.black,
                                                     width: 1
                                                 ),
                                                color: Colors.black54
                                             ),
                                             child: Center(
                                               child: AutoSizeText(
                                                 "Group Admin",
                                                 style: GoogleFonts.exo(
                                                     fontSize: size.height*0.016,
                                                     fontWeight: FontWeight.w600,
                                                   color: Colors.white
                                                 ),
                                               ),
                                             ),
                                           )
                                           :
                                           const SizedBox(),
                                         ],
                                       ),
                                ),
                              )
                                  :
                              const SizedBox()
                              ;
                            }
                          );
                        },);
                      }
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
