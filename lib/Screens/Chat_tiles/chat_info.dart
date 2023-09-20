import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:campus_link_teachers/Screens/Chat_tiles/Media_File.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';



class Chat_Info extends StatefulWidget {
  const Chat_Info({super.key, required this.channel, required this.membersCount, required this.url});
  final String channel;
  final int membersCount;
  final String url;
  @override
  State<Chat_Info> createState() => _Chat_InfoState();
}


class _Chat_InfoState extends State<Chat_Info> {
   bool _switched=false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    is_mute();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 8, 10, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: const BoxDecoration(

              ),
                 height: size.height*0.45,
              padding: EdgeInsets.all(size.width*0.03),
              child:  Column(
                children: [
                  SizedBox(
                    height: size.height*0.018,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,)
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.032,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: size.height*0.08,
                        backgroundColor: Colors.white30,
                        backgroundImage: widget.url != "null" ? NetworkImage(widget.url) : null,
                        child: widget.url=="null" ?
                        Icon(Icons.group,color:Colors.white30 ,size: size.height*0.1,) : null
                    ),
                      Positioned(
                        bottom: -5,
                        right: size.height*0.01,
                        child: IconButton(
                          icon: Icon(Icons.camera_enhance,size:size.height*0.04 ,color: Colors.white,),
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
                    height: size.height*0.04,
                  ),
                  AutoSizeText(
                      widget.channel,
                    style: GoogleFonts.openSans(
                      color: Colors.white70,
                      fontSize: size.height*0.025,
                      fontWeight:FontWeight.w600
                    ),


                      ),
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  AutoSizeText(
                    "Group : ${widget.membersCount} Participants",
                    style: GoogleFonts.openSans(
                        color: Colors.white30,
                        fontSize: size.height*0.02,
                        fontWeight:FontWeight.w600
                    ),


                  ),

                ],
              ),
            ),
            Container(
              height: size.height*0.007,
              width: size.width*1,
              color: Colors.white10,
            ),

            Container(
              height: size.height*0.28,
              width: size.width,
              decoration: const BoxDecoration(

              ),
              child: Padding(
                padding:EdgeInsets.all(size.height*0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   AutoSizeText(
                     "About Group",
                     style: GoogleFonts.openSans(
                     color: Colors.white70,
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
                          style:GoogleFonts.openSans(
                            color: Colors.white38,
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
                                  color: Colors.white38,
                                  fontSize: size.height*0.019,
                                  fontWeight: FontWeight.w500
                              ) ,
                            )
                            :
                                const SizedBox();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height*0.022,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _switched?

                      Icon(Icons.notifications,color: Colors.white30,size: size.height*0.035,)
                            :
                        Icon(Icons.notifications_off,color: Colors.white30,size: size.height*0.035,),
                        SizedBox(
                          width: size.width*0.03,
                        ),
                        AutoSizeText(
                          "Mute Notifications ",
                          style:GoogleFonts.exo(
                              color: Colors.white38,
                              fontSize: size.height*0.019,
                              fontWeight: FontWeight.w500
                          ) ,
                        ),
                        SizedBox(
                          width: size.width*0.26,
                        ),
                        SizedBox(
                          child: Switch(
                            value:!_switched ,
                              onChanged: (value) {
                                setState(() {
                                  _switched=!_switched;
                                });
                                if(value)
                                  {
                                    FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                      "Token":FieldValue.arrayRemove([usermodel["Token"]]),
                                    }).whenComplete(() => print(".................deleted........"));
                                  }
                                else{
                                  FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                    "Token":FieldValue.arrayUnion([usermodel["Token"]]),
                                  }).whenComplete(() => print(".................Added........"));
                                }
                              },
                            activeColor: Colors.black26,
                            activeTrackColor: Colors.white10,


                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height*0.018,
                    ),
                    InkWell(
                        onTap: (){
                      Navigator.push(
                        context,
                        PageTransition(
                            childCurrent:Chat_Info(channel: widget.channel, membersCount: widget.membersCount, url: widget.url,),
                            child:Media_files(channel: widget.channel,),
                            type: PageTransitionType
                                .rightToLeftJoined,
                            duration: const Duration(
                                milliseconds: 300)),
                      );
                    },
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.image,color: Colors.white30,size: size.height*0.035,),
                            SizedBox(
                              width: size.width*0.022,
                            ),
                            AutoSizeText(
                              "Show Media",
                              style: GoogleFonts.exo(
                                  color: Colors.white38,
                                  fontSize: size.height*0.02,
                                  fontWeight: FontWeight.w600
                              ),

                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: size.height*0.007,
              width: size.width*1,
              color: Colors.white10,
            ),
            Container(
              height: size.height,
              decoration: const BoxDecoration(
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height*0.015,
                  ),
                  SizedBox(
                    //height:size.height*0.025,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "   ${widget.membersCount} Participants",
                          style: GoogleFonts.openSans(
                              color: Colors.white70,
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
                        return snapshot.hasData
                            ?
                        ListView.builder(

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
                                          SizedBox(
                                            width: size.width*0.72,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: size.width*0.07,
                                                  backgroundColor: Colors.white10,
                                                  child: snapshot2.data!.data()!["Profile_URL"]!=null
                                                      ?
                                                  Image(image: NetworkImage(snapshot2.data?.data()!["Profile_URL"]))
                                                      :
                                                  AutoSizeText(
                                                    snapshot2.data?.data()!["Name"].toString().substring(0,1) ?? "A",
                                                    style: GoogleFonts.openSans(
                                                        fontSize: size.height*0.022,
                                                        color: Colors.white38,
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
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.white54,
                                                          fontSize: size.height*0.022,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      "User_description",
                                                      style: GoogleFonts.openSans(
                                                          color: Colors.white38,
                                                          fontSize: size.height*0.01,
                                                          fontWeight: FontWeight.w500
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          snapshot.data?.data()!["Admins"].contains(snapshot.data?.data()!["Members"][index]["Email"])
                                              ?
                                          Container(
                                            height: size.height*0.03,
                                            width: size.width*0.22,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                border: Border.all(
                                                    color: Colors.white38,
                                                    width: 1
                                                ),
                                                color: Colors.black54
                                            ),
                                            child: Center(
                                              child: AutoSizeText(
                                                "Group Admin",
                                                style: GoogleFonts.openSans(
                                                    color: Colors.white38,
                                                    fontSize: size.height*0.016,
                                                    fontWeight: FontWeight.w600,
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
                                  const SizedBox();
                                }
                            );
                          },)
                            :
                        const loading(text: "Fetching Data from the Server Please Wait",)
                        ;
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

  is_mute() async {
   await  FirebaseFirestore.instance.collection("Messages").doc(widget.channel).get().then((value) {
      setState(() {
        _switched=value.data()?["Token"].contains(usermodel["Token"]);
      });
      print(".............$_switched.....");
    });
  }
}
