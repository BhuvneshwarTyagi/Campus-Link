import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:searchfield/searchfield.dart';
import '../../Constraints.dart';
import '../Screens/loadingscreen.dart';




class addPost extends StatefulWidget {
   const addPost({super.key,});
  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {

  TextEditingController topicController = TextEditingController();
  TextEditingController topicDescription = TextEditingController();
  TextEditingController postByController=TextEditingController();
  bool fileSelected=false;
  FilePickerResult? filePath;
  List<String> postBy=["Student","Teacher"];

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: size.width*0.1,
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              "Add Post",
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: size.height * 0.023,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            const Icon(
              Icons.post_add,
              color: Colors.white,
            )
          ],
        ),
        centerTitle: true,
      ),
      body:  SizedBox(
        height: size.height*0.85,
        width: size.width*1,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height*0.032,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: size.height * 0.07,
                      width: size.width,
                      child: DottedBorder(
                        color: Colors.white,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          textAlign: TextAlign.start,
                          controller: topicController,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height*0.018
                          ),
                          decoration:  const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write Your Topic",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                          cursorColor: Colors.white,
                        ),
                      )),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: size.height * 0.2,
                      width: size.width,
                      child: DottedBorder(
                        color: Colors.white,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          textAlign: TextAlign.start,
                          controller: topicDescription,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.height*0.018,
                          ) ,
                          maxLines: 10,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Topic Description ",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                          cursorColor: Colors.white,
                        ),
                      )),
                ),
                SizedBox(
                  height: size.height*0.03,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height * 0.07,
                    width: size.width,
                    child: DottedBorder(
                      color: Colors.white,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      child:  SearchField(
                        suggestionItemDecoration: SuggestionDecoration(),
                        key: const Key('searchfield'),
                        controller: postByController,
                        searchStyle: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: size.height*0.02,
                            fontWeight: FontWeight.w600),
                        suggestionStyle: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize:  size.height*0.02,
                          fontWeight: FontWeight.w600,
                        ),
                        marginColor: Colors.transparent,
                        suggestionsDecoration: SuggestionDecoration(
                            color: Colors.white30,
                            //shape: BoxShape.rectangle,
                            //border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        searchInputDecoration: InputDecoration(
                          fillColor: Colors.black26.withOpacity(0.7),
                          filled: true,
                          hintText: "Post By",
                          hintStyle: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: size.height*0.02,
                              fontWeight: FontWeight.w500),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 0,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onSuggestionTap: (value) {

                          FocusScope.of(context).requestFocus();
                        },
                        enabled: true,
                        hint: "Post By",
                        itemHeight: 40,
                        maxSuggestionsInViewPort: 2,
                        suggestions:
                        postBy.map((e) => SearchFieldListItem(e)).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height*0.03,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: size.height * 0.1,
                      width: size.width,
                      child: DottedBorder(
                          color: Colors.white,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                size: size.height * 0.04,
                                Icons.upload_sharp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              AutoSizeText(
                                "Add any photo here",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FilePicker
                                      .platform
                                      .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['png','jpg'],
                                      allowMultiple: false).then((value) {
                                    print("${value!.files[0].extension}");
                                    if(value!.files[0].path!.isNotEmpty && value!.files[0].extension!=".pdf" && value!.files[0].extension!=".docx") {
                                      filePath = value;
                                      setState(() {
                                        fileSelected=true;
                                      });
                                    }
                                    else{
                                      print("Extension is : ${value.files[0].extension}");
                                      setState(() {
                                        fileSelected=false;
                                      });
                                      InAppNotifications.instance
                                        ..titleFontSize = 25.0
                                        ..descriptionFontSize = 15.0
                                        ..textColor = Colors.black
                                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                      InAppNotifications.show(
                                          title: 'Error',
                                          duration: const Duration(seconds: 2),
                                          description: "Please select only Image",
                                          leading: const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 40,
                                          ));
                                    }
                                  });
                                },
                                child: AutoSizeText(
                                  "Browse Photo",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontSize: size.height * 0.02,
                                      fontWeight: FontWeight.w700),
                                ),


                              ),
                              fileSelected
                                  ?
                              Icon(
                                size: size.height * 0.02,
                                Icons.check_circle,
                                color: Colors.green,
                              )
                                  :
                              const SizedBox()
                            ],
                          )
                      )),
                ),
                SizedBox(
                  height: size.height*0.03,),
                Center(
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.466,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue,
                            Colors.purpleAccent,
                          ],
                        ),
                        borderRadius:  BorderRadius.all(Radius.circular(size.width*0.033)),
                        border: Border.all(color: Colors.black, width: 2)
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent
                      ),
                      onPressed: () async {
                        if(topicDescription.text.toString().isNotEmpty && topicController.text.toString().isNotEmpty)
                        {
                          Navigator.push(context, PageTransition(
                              type: PageTransitionType.bottomToTop,
                              duration: const Duration(milliseconds: 400),
                              childCurrent: const addPost(),
                              child: const loading(text: "Post is public Please wait.......")));
                          DateTime stamp= DateTime.now();
                          DateTime deadline= DateTime.now();

                          String postImageUrl="";
                          if(filePath?.files[0].path != null)
                          {
                            Reference reference=FirebaseStorage.instance.ref();
                            Reference imageDirectory=reference.child("Achievements");
                            Reference channel=imageDirectory.child("${usermodel["Email"]}-$stamp");
                            TaskSnapshot snap= await channel.putFile(File("${filePath?.files[0].path}"));
                            postImageUrl=await snap.ref.getDownloadURL().whenComplete((){
                              print("Url is : ${postImageUrl}");
                            });
                          }


                          // Query Here....
                          print("Query starts....");
                          await FirebaseFirestore.instance.collection("Achievements")
                              .doc("${usermodel["Email"].toString().split("@")[0]}-$stamp")
                              .set({

                            "Image-URL":fileSelected?postImageUrl:null,
                            "Likes":0,
                            "Topic":topicController.text.toString(),
                            "Topic-Description":topicDescription.text.toString(),
                            "Time-Stamp":stamp,
                            "Name":usermodel["Name"],
                            "Email":usermodel["Email"],
                            "Post by":postByController.text.toString(),
                            "doc":"${usermodel["Email"].toString().split("@")[0]}-$stamp",
                            "User_Profile":usermodel["Profile_URL"].toString()
                          }).whenComplete((){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });

                        }
                        else{
                          InAppNotifications.instance
                            ..titleFontSize = 25.0
                            ..descriptionFontSize = 15.0
                            ..textColor = Colors.black
                            ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                            ..shadow = true
                            ..animationStyle = InAppNotificationsAnimationStyle.scale;
                          InAppNotifications.show(
                              title: 'Error',
                              duration: const Duration(seconds: 2),
                              description: "Please Provide Details For post",
                              leading: const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ));
                        }
                      },
                      child:  AutoSizeText("Public",
                        style: GoogleFonts.openSans(
                            fontSize: size.height * 0.025, color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),

                      ),
                    ),
                  ),
                ),


              ]),
        ),
      ),
    );
  }

}
