import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';
import 'background_image.dart';
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
      ListView.builder(
        itemCount: usermodel["Message_channels"].length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection("Messages")
                  .doc(usermodel["Message_channels"][index])
                  .update({
                usermodel["Email"]
                    .toString()
                    .split("@")[0]: {
                  "Last_Active": DateTime.now(),
                  "Read_Count": FieldValue,
                  "Active": true,
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Messages").doc(usermodel["Message_channels"][index]).snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ?
                      CircleAvatar(
                        backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                        radius: size.width*0.07,
                        backgroundImage: NetworkImage(snapshot.data!.data()!["image_URL"]),
                      )
                          :
                      CircleAvatar(
                        backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                        radius: size.width*0.07,
                        child: const CircularProgressIndicator(),
                      );
                    },
                  ),

                  SizedBox(width: size.width*0.03),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText("${usermodel["Message_channels"][index]}",
                        style: GoogleFonts.poppins(color: Colors.black,fontSize: size.width*0.045,fontWeight: FontWeight.w500),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Messages").doc(usermodel["Message_channels"][index]).snapshots(),
                        builder: (context, snapshot2) {
                          int count=0;
                          snapshot2.hasData
                              ?
                          count= snapshot2.data?.data()!["Messages"].length-snapshot2.data?.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]-1
                              :
                          null;

                          return snapshot2.hasData
                              ?
                          Row(
                            children: [
                              SizedBox(
                                width: size.width*0.7,
                                child: AutoSizeText("${snapshot2.data?.data()!["Messages"][snapshot2.data?.data()!["Messages"].length-1]["Name"]}: ${snapshot2.data?.data()!["Messages"][snapshot2.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot2.data?.data()!["Messages"][snapshot2.data?.data()!["Messages"].length-1]["text"] : snapshot2.data?.data()!["Messages"][snapshot2.data?.data()!["Messages"].length-1]["text"].toString().substring(0,25)}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.80),
                                      fontSize: size.width*0.035,
                                      fontWeight: FontWeight.w400
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              count>0
                                  ?
                              CircleAvatar(
                                radius: size.width*0.03,
                                backgroundColor: Colors.green,
                                child: AutoSizeText("$count",
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
                              :
                          SizedBox(
                            height: size.height*0.03,
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  // counting(List<dynamic> a,DateTime b,int c,int d){
  //   int count=0;
  //   print(".............b:     ${b.toString().split(".")[0]}");
  //   print(".............b:     $b");
  //    DateTime user_stamp=DateTime.parse(b.toString().split(".")[0]);
  //    print('.............$user_stamp');
  //   for(int i=c;i<d;i++){
  //      DateTime msg_stamp=DateTime.parse(a[i]["Stamp"].toString().split(".")[0]);
  //     if(user_stamp.isBefore(msg_stamp)){
  //       count++;
  //     }
  //   }
  //   return count;
  // }
}
