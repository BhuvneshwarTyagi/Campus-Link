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
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.black12
              ),
                 height: size.height*0.7,
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
                        child: AutoSizeText(widget.channel.split(" ")[6]),
                    ),
                      Positioned(
                        bottom: -5,
                        left: 35,
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
                    height: size.height*0.02,
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
                  SizedBox(
                    height: size.height*0.02,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height*0.02,
            ),

            Container(
              height: size.height*0.5,
              decoration: const BoxDecoration(

                color: Colors.black12
              ),
            )
          ],
        ),
      ),
    );
  }
}
