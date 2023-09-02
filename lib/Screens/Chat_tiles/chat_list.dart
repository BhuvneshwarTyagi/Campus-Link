import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import '../background_image.dart';
import 'chat.dart';

class chatsystem extends StatefulWidget {
  const chatsystem({super.key});

  @override
  State<chatsystem> createState() => _chatsystemState();
}

class _chatsystemState extends State<chatsystem> {

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(63, 63, 63,1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text("Chats"),
        actions: <Widget> [

          PopupMenuButton(
            icon: Icon(Icons.more_vert,size: size.height*0.04,),
            itemBuilder: (context) {

              return[
                PopupMenuItem(
                    child:TextButton(
                        onPressed: (){

                        }, child:const Text("Search",style: TextStyle(color: Colors.black),))),
                PopupMenuItem(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Messages").doc(usermodel["Message_channels"][0]).snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ?
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Background_image(groupimage: snapshot.data!.data()!["image_URL"], channel: usermodel["Message_channels"][0],),
                            ),
                            );

                          },
                          child:const Text("Wallpaper",style: TextStyle(color: Colors.black),
                          ),
                        )
                            :
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                          radius: size.width*0.07,
                          child: const CircularProgressIndicator(),
                        );
                      },
                    ),
                ),

              ];
            },)
        ],
      ),
      body: usermodel["Message_channels"]==null || usermodel["Message_channels"].length<0
          ?
      Center(
        child: Container(
          width: size.width*0.9,
          height: size.height*0.1,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            gradient: LinearGradient(
                colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.1),
            ])
          ),
          child: Center(
            child: AutoSizeText("Please add subject first.",style: GoogleFonts.gfsDidot(
              color: Colors.white,
              fontSize: size.height*0.035
            ),)
          ),
        ),
      )
          :
      SizedBox(
        height: size.height*0.9,
        width: size.width,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: usermodel["Message_channels"].length,
          itemBuilder: (context, index) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Messages").doc(usermodel["Message_channels"][index]).snapshots(),
                builder: (context, snapshot) {
                  int readCount=0;
                  int count=0;
                  snapshot.hasData
                      ?
                  readCount= snapshot.data?.data()!["Messages"].length
                      :
                  null;
                  snapshot.hasData
                      ?
                  count= int.parse("${snapshot.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]}")
                      :
                  null;
                return snapshot.hasData
                    ?
                InkWell(
                  onTap: () async {
                    int readCount1 = 0;
                    int count1 = 0;
                    readCount1 = snapshot.data?.data()!["Messages"].length;
                    count1 = int.parse("${snapshot.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]}");
                    for (int i = readCount1; i > count1; i--) {
                      String? stamp = snapshot.data!
                          .data()?["Messages"][i-1]["Stamp"];
                      String? email = snapshot.data!.data()?["Messages"]
                      [i-1]["Email"];

                      if (email != usermodel["Email"]) {
                        await FirebaseFirestore.instance
                            .collection("Messages")
                            .doc(usermodel["Message_channels"][index])
                            .collection("Messages_Detail")
                            .doc("Messages_Detail")
                            .update({
                          "${email}_${stamp}_Seen": FieldValue.arrayUnion([
                            {
                              "Email": usermodel["Email"],
                              "Stamp": DateTime.now()
                            }
                          ]),
                        });
                      }
                    }
                    await FirebaseFirestore.instance
                        .collection("Messages")
                        .doc(usermodel["Message_channels"][index])
                        .update({
                      usermodel["Email"].toString().split("@")[0]: {
                        "Last_Active": DateTime.now(),
                        "Read_Count": readCount1,
                        "Active": true,
                        "Token": FieldValue.arrayUnion([usermodel["Token"]])
                      }
                    }).whenComplete((){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => chat_page(channel: usermodel["Message_channels"][index]),
                        ),
                      );
                    });
                  },
                  child: Container(
                    height: size.height*0.1,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                    padding: EdgeInsets.all(size.width*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                          radius: size.width*0.07,
                         // backgroundImage: NetworkImage(snapshot.data!.data()!["image_URL"]),
                        ),

                        SizedBox(width: size.width*0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText("${usermodel["Message_channels"][index]}",
                              style: GoogleFonts.poppins(color: Colors.black,fontSize: size.width*0.045,fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width*0.7,
                                  child: AutoSizeText("${snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["Name"]}: ${snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"] : snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].toString().substring(0,25)}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black.withOpacity(0.80),
                                        fontSize: size.width*0.035,
                                        fontWeight: FontWeight.w400
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                readCount - count>0
                                    ?
                                CircleAvatar(
                                  radius: size.width*0.03,
                                  backgroundColor: Colors.green,
                                  child: AutoSizeText("${readCount - count}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: size.width*0.035,
                                        fontWeight: FontWeight.w400
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                                    :
                                const SizedBox(),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
                    :
                const loading(text: "Fetching Chats from server");
              }
            );
          },
        ),
      ),
    );
  }
}
