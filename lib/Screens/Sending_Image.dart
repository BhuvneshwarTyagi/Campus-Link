import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Constraints.dart';
import '../Database/database.dart';

class SendImage extends StatefulWidget {
  const SendImage({super.key, required this.imagePath, required this.channel});
  final XFile imagePath;
  final String channel;
  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(image: FileImage(File(widget.imagePath.path)),fit: BoxFit.fill)
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(backgroundColor: Colors.black54),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: size.width,
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,vertical: size.height*0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    width: size.width * 0.78,
                    child: TextField(
                      controller: messageController,
                      enableSuggestions: true,
                      maxLines: 5,
                      minLines: 1,
                      autocorrect: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                        fillColor: Colors.white70,
                        filled: true,
                        hintText: "Message",
                        hintStyle: GoogleFonts.exo(
                          color: Colors.black54,
                          fontSize:
                          19, //height:size.height*0.0034
                        ),
                        contentPadding: EdgeInsets.only(
                            left: size.width * 0),
                        enabledBorder:
                        const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    12.0)),
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1)),
                        focusedBorder:
                        const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    12.0)),
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1)),
                        prefixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          size: size.height * 0.042,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Reference reference=FirebaseStorage.instance.ref();

                      // Create Directory into Firebase Storage

                      Reference image_directory=reference.child("Message_Images");


                      Reference image_folder=image_directory.child("${usermodel[widget.channel]}");

                      Reference channel=image_directory.child("${DateTime.now()}");

                     TaskSnapshot snap= await channel.putFile(File(widget.imagePath.path));
                     String URL=await snap.ref.getDownloadURL();
                      await FirebaseFirestore.instance
                          .collection("Messages")
                          .doc(widget.channel)
                          .update(
                        {
                          "Messages": FieldValue.arrayUnion([
                            {
                              "Name": usermodel["Name"]
                                  .toString(),
                              "UID": usermodel["Email"]
                                  .toString(),
                              "text": messageController.text
                                  .trim()
                                  .toString(),
                              "Stamp": DateTime.now(),
                              "Reply": false,
                              "Reply_Index": 0,
                              "Image_Text": true,
                              "Image_Url" : URL
                            }
                          ])
                        },
                      ).whenComplete(
                            () async {
                          setState(() {
                            messageController.clear();
                          });
                          List<dynamic> tokens =
                          await FirebaseFirestore.instance
                              .collection("Messages")
                              .doc(widget.channel)
                              .get()
                              .then((value) {
                            return value.data()?["Token"];
                          });
                          for (var element in tokens) {
                            element.toString() !=
                                usermodel["Token"]
                                ? database().sendPushMessage(
                                element,
                                messageController.text.trim(),
                                widget.channel)
                                : null;
                          }
                          Navigator.pop(context);
                        },

                      );

                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: size.height * 0.032,
                      child: Icon(
                        Icons.send,
                        size: size.height * 0.032,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
