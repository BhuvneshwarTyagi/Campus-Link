import 'package:auto_size_text/auto_size_text.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    markFalse();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(63, 63, 63,1),
        titleSpacing: 0,
        leadingWidth: size.width*0.13,
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
            return SizedBox(
              height: size.height*0.1,
              width: size.width,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Messages").doc(usermodel["Message_channels"][index]).snapshots(),
                  builder: (context, snapshot) {
                    print("chat List");
                    markFalse();
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
                  snapshot.data!.data()!["Type"] == "Personal"
                      ?
                  InkWell(
                    onTap: () async {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(channel: usermodel["Message_channels"][index]),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height*0.11,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                      padding: EdgeInsets.all(size.width*0.02),
                      child: StreamBuilder(
                        stream: FirebaseFirestore
                            .instance
                            .collection(snapshot.data!.data()!["Members"][0]["Name"]==usermodel["Name"] ? snapshot.data!.data()!["Members"][1]["Post"] : snapshot.data!.data()!["Members"][0]["Post"])
                            .doc(snapshot.data!.data()!["Members"][0]["Name"]==usermodel["Name"] ? snapshot.data!.data()!["Members"][1]["Email"] : snapshot.data!.data()!["Members"][0]["Email"])
                            .snapshots(),
                        builder: (context, snapshot1) {
                          return snapshot1.hasData ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color.fromRGBO(86, 149, 178, 1),
                                radius: size.width*0.07,
                                backgroundImage: snapshot1.data!.data()!["Profile_URL"]!="null"? NetworkImage(snapshot1.data!.data()!["Profile_URL"]) : null,
                                child: snapshot1.data?.data()!["Profile_URL"] == "null"
                                    ?
                                AutoSizeText(
                                  snapshot.data!.data()?["Type"] == "Personal"
                                      ?
                                  snapshot.data!.data()!["Members"][0] == usermodel["Name"]
                                      ?
                                  snapshot.data!.data()!["Members"][1].toString().substring(0,1)
                                      :
                                  usermodel["Name"].toString().substring(0,1)
                                      :
                                  usermodel["Message_channels"][index].toString().split(" ")[6].substring(0, 1),
                                  style: GoogleFonts.exo(
                                      color: Colors.black,
                                      fontSize: size.height * 0.035,
                                      fontWeight: FontWeight.w600),
                                )
                                    : null,
                              ),

                              SizedBox(width: size.width*0.03),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                  snapshot1.data!.data()!["Name"],
                                    style: GoogleFonts.poppins(color: Colors.black,fontSize: size.width*0.045,fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width*0.7,
                                        child: AutoSizeText("${
                                            snapshot.data?.data()!["Messages"].length >0
                                                ?
                                            snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["Name"]
                                                :
                                            ""
                                        } : ${
                                            snapshot.data?.data()!["Messages"].length > 0
                                                ?
                                            snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"] : snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].toString().substring(0,25)
                                                :
                                            ""
                                        }",
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
                          )
                              :
                          const SizedBox();
                        }
                      ),
                    ),
                  )
                  :
                  InkWell(
                    onTap: () async {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(channel: usermodel["Message_channels"][index]),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height*0.11,
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
                            backgroundImage: snapshot.data!.data()!["image_URL"]!="null"? NetworkImage(snapshot.data!.data()!["image_URL"]) : null,
                            child: snapshot.data?.data()!["image_URL"] == "null"
                                ?
                            AutoSizeText(
                              usermodel["Message_channels"][index].toString().split(" ")[6].substring(0, 1),
                              style: GoogleFonts.exo(
                                  color: Colors.black,
                                  fontSize: size.height * 0.035,
                                  fontWeight: FontWeight.w600),
                            )
                                : null,
                          ),

                          SizedBox(width: size.width*0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                              usermodel["Message_channels"][index],
                                style: GoogleFonts.poppins(color: Colors.black,fontSize: size.width*0.045,fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width*0.7,
                                    child: AutoSizeText("${
                                        snapshot.data?.data()!["Messages"].length >0
                                            ?
                                        snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["Name"]
                                            :
                                        ""
                                    } : ${
                                        snapshot.data?.data()!["Messages"].length > 0
                                            ?
                                        snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].length <25 ? snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"] : snapshot.data?.data()!["Messages"][snapshot.data?.data()!["Messages"].length-1]["text"].toString().substring(0,25)
                                            :
                                        ""
                                    }",
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
                  Text("Fetching Chats from server",
                    style: GoogleFonts.exo(
                        color: Colors.white,
                        fontSize: size.height*0.035
                    ),);
                }
              ),
            );
          },
        ),
      ),
    );
  }
  Future<void> markFalse() async {
    for(var channel in usermodel["Message_channels"]){
      await FirebaseFirestore.instance.collection("Messages").doc(channel).update({
        "${usermodel["Email"].toString().split("@")[0]}.Active" : false
      });
    }
    print(".....................false");
  }
}
