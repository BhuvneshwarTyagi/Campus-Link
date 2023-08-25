import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipe_to/swipe_to.dart';
import 'background_image.dart';
import 'chat_info.dart';

class chat_page extends StatefulWidget {
  const chat_page({Key? key, required this.channel}) : super(key: key);
  final String channel;
  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  TextEditingController messageController = TextEditingController();
  final ScrollController scrollController= ScrollController();
  List<int> tick=[];
  bool selected=false;
  int index1=-1;
  int replyIndex=0;
  double replyBoxHeight=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Messages").doc(widget.channel).snapshots(),
        builder: (context,snapshot) {
          List<dynamic> message = snapshot.data?.data()!["Messages"]==null ? [] : snapshot.data?.data()!["Messages"].reversed.toList();
          return
            snapshot.hasData
                ?
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/images/${usermodel["bg"]}"),fit: BoxFit.fill)
              ),
              child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: !selected
                  ?
              AppBar(
                  elevation: 0,
                  backgroundColor: Colors.black54,
                  leadingWidth: size.width*0.09,
                  leading: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: size.height*0.03,
                        backgroundColor: Colors.white70,
                        backgroundImage: NetworkImage(snapshot.data?.data()!["image_URL"]),
                      ),
                      SizedBox(
                        width: size.width*0.03,
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context,
                            PageTransition(
                              childCurrent: chat_page(channel: widget.channel),
                              child: Chat_Info(channel: widget.channel, membersCount: snapshot.data!.data()!["Members"].length,url: snapshot.data?.data()!["image_URL"],),
                              type: PageTransitionType.rightToLeftJoined,
                              duration: const Duration(milliseconds: 300)
                          ),
                          );
                        },
                        child: SizedBox(
                          width: size.width*0.5,
                          height: size.height*0.04,
                          child: Center(
                            child: AutoSizeText(
                              widget.channel,
                              style: GoogleFonts.exo(
                                  color: Colors.white,
                                  fontSize: size.width*0.04
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget> [

                    PopupMenuButton(
                      icon: Icon(Icons.more_vert,size: size.height*0.04,),
                      itemBuilder: (context) {

                        return[
                          PopupMenuItem(
                              child:TextButton(
                                  onPressed: (){

                                  }, child:const Text("Search",style: TextStyle(color: Colors.black),))),
                          PopupMenuItem(child:TextButton(onPressed: (){
                            }, child:const Text("Wallpaper",style: TextStyle(color: Colors.black),))),
                          PopupMenuItem(
                              child:TextButton(
                                  onPressed: (){

                                  }, child:const Text("Setting",style: TextStyle(color: Colors.black),))),
                          PopupMenuItem(
                              child:TextButton(
                                  onPressed: (){

                                  }, child:const Text("More",style: TextStyle(color: Colors.black),))),
                        ];
                      },)
                    ],
                  )
                  :
              AppBar(
                elevation: 0,
                backgroundColor: Colors.black54,
                leadingWidth: size.width*0.09,
                leading: IconButton(
                    onPressed: (){
                      setState(() {
                        selected=!selected;
                      });

                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                          "Messages" : FieldValue.arrayRemove([message[index1]])
                        });
                        setState(() {
                          index1=-1;
                          selected=!selected;
                        });
                }, icon: const Icon(Icons.delete_outline))
                ],
              ),
              body: SizedBox(
                height: size.height,
                //color: Colors.black26,
                child: message.isNotEmpty
                    ?
                ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  itemCount: message.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    bool Reply=false;
                    message[index]["Reply"]==null
                        ?
                    Reply=false
                        :
                        Reply=message[index]["Reply"];
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          index!=message.length-1
                              ?
                          message[index+1]["Stamp"].toDate().day==message[index]["Stamp"].toDate().day
                              ?
                          const SizedBox()
                              :
                          date(message[index]["Stamp"].toDate())
                              :
                          date(message[index]["Stamp"].toDate())
                          ,
                          message[index]["UID"]==usermodel["Email"]
                              ?
                          SwipeTo(
                            onLeftSwipe: (){setState(() {
                              replyBoxHeight=size.height*0.17;
                              replyIndex=index;
                            });},
                            child: InkWell(
                              onLongPress: () async {
                                setState(() {
                                  index1=index;
                                  selected=!selected;
                                });

                              },
                                child: bubble("${message[index]["text"]}","${message[index]["Name"]}","${message[index]["Image"]}", message[index]["Stamp"].toDate(), true,size,index,message.length,Reply,
          Reply
              ?
          message[int.parse("${message.length-message[index]["Reply_Index"]-1}")]["Name"]: "",
                                    Reply
                                        ?
                                    message[int.parse("${message.length-message[index]["Reply_Index"]-1}")]["text"]: ""
                                ),
                            ),
                          )
                              :
                          SwipeTo(
                            onRightSwipe: () {
                              setState(() {
                                replyBoxHeight=size.height*0.17;
                                replyIndex=index;
                              });
                            },
                              child: bubble("${message[index]["text"]}","${message[index]["Name"]}","${message[index]["Image"]}", message[index]["Stamp"].toDate(), false,size,index,message.length,Reply , Reply
                                  ?
                              message[int.parse("${message.length-message[index]["Reply_Index"]-1}")]["Name"]: "",
                                  Reply
                                      ?
                                  message[int.parse("${message.length-message[index]["Reply_Index"]-1}")]["text"]: ""  ),
                          )
                        ],
                      );
                  },
                )
                    :
                const SizedBox(),

              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: size.width,
                  //color: Colors.black26,
                  padding: EdgeInsets.all(size.width*0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                          alignment: Alignment.bottomCenter,
                        children: [

                          AnimatedContainer(
                            height: replyBoxHeight,
                            width: size.width*0.82,
                            decoration: const BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                            duration: const Duration(milliseconds: 100),

                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  width: size.width*0.8,
                                margin: EdgeInsets.only(
                                    bottom: size.height*0.07,
                                    top: size.height*0.01,
                                  right: size.height*0.01,
                                  left: size.height*0.01,

                                ),
                                padding: EdgeInsets.all(size.height*0.008),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(message[replyIndex]["Name"],style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                    ),
                                    ),
                                    Text(
                                      message[replyIndex]["text"].toString()
                                          .substring(0,message[replyIndex]["text"].length<120 ? message[replyIndex]["text"].length : 120),
                                      style: GoogleFonts.exo(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13
                                    ),),
                                  ],
                                ),
                              ),
                                IconButton(
                                    onPressed: (){
                                      setState(() {
                                        replyBoxHeight=0;
                                        replyIndex=0;
                                      });
                                    },
                                    icon: const Icon(Icons.clear))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height*0.062,
                            width: size.width*0.8,
                            child: TextField(
                              controller: messageController,
                              enableSuggestions: true,
                              onTapOutside: (event) async {
                                await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                  usermodel["Email"].toString().split("@")[0] : {
                                    "Last_Active" : DateTime.now(),
                                    "Read_Count" : message.length-1
                                  }
                                });
                              },
                              maxLines: 5,
                              minLines: 1,
                              autocorrect: true,
                              textAlign:TextAlign.start,
                              style: const TextStyle(color: Colors.white,fontSize: 18),
                              decoration: InputDecoration(
                                fillColor: Colors.white70,
                                filled: true,
                                hintText: "Message",
                                hintStyle:  GoogleFonts.exo(
                                  color: Colors.black54,
                                  fontSize: 19,//height:size.height*0.0034
                                ),
                                contentPadding: EdgeInsets.only(left: size.width*0),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(color: Colors.black54, width: 1)
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    borderSide: BorderSide(color: Colors.black54, width: 1)
                                ),
                                prefixIcon: Icon(Icons.emoji_emotions_outlined,size: size.height*0.042,color: Colors.black87,),
                              ),

                            ),
                          ),
                        ]
                      ),
                      TextButton(
                              onPressed: () async {
                            messageController.text.trim()==""
                                ?
                                null
                                :
                            await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                              "Messages": FieldValue.arrayUnion([{
                                "Name": usermodel["Name"].toString(),
                                "UID": usermodel["Email"].toString(),
                                "text": messageController.text.trim().toString(),
                                "Stamp": DateTime.now(),
                                "Reply": replyBoxHeight!=0 ? true : false,
                                "Reply_Index": message.length-replyIndex-1,
                              }])
                            },
                            ).whenComplete(() async {
                              setState(() {
                                messageController.clear();
                                replyBoxHeight=0;
                                replyIndex=0;
                              });
                              List<dynamic> tokens = await FirebaseFirestore
                                  .instance
                                  .collection("Messages")
                                  .doc(widget.channel)
                                  .get().then((value){
                                    return value.data()?["Token"];
                              });
                              for(var element in tokens){
                                element.toString() != usermodel["Token"]
                                    ?
                                database().sendPushMessage(element, messageController.text.trim(), "New Message",widget.channel)
                                    :
                                null;
                              }
                            },
                            );
                          },
                             child: CircleAvatar(
                               backgroundColor: Colors.white,
                               radius: size.height*0.025,
                               child: Icon(
                                 Icons.send,
                                 size: size.height*0.03,
                                 color: Colors.black,
                               ),
                             ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
            )
                :
            const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
  }

  Widget show_date(String chatTime,BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.032,
          width: MediaQuery.of(context).size.width*0.28,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(63, 63, 63,1),
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(
              color: const Color.fromRGBO(63, 63, 63,1),
              width: 1
            )
          ),
          child: Center(
            child: AutoSizeText(
                chatTime,
              style: GoogleFonts.exo(
                fontSize: 16,
                color:Colors.black54
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget bubble(String text,String name,String image, DateTime stamp,bool sender,Size size,int index,int length,bool reply,String replyToName,String ReplyToText){
    //int min=tick[0];
    return Align(
      alignment: sender ?
      Alignment.centerRight
          :
      Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: sender ?
        MainAxisAlignment.end
            :
        MainAxisAlignment.start
        ,
        children: [

          sender
              ?
          const SizedBox()
              :
          Row(
            children: [
              SizedBox(width: size.width * 0.02),
              CircleAvatar(
                radius: size.width * 0.045,
                backgroundImage: image !="null"?

                NetworkImage(image)
                    :
                null,
                // backgroundColor: Colors.teal.shade300,
                child: image == "null" ?
                AutoSizeText(
                  name.substring(0, 1),
                  style: GoogleFonts.exo(
                      fontSize: size.height * 0.01,
                      fontWeight: FontWeight.w600),
                )
                    :
                null,
              ),
            ],
          ),

          Container(
            width: text.length > 23
                ?
            size.width * 0.028 * 25
                :
            name.length >= text.length
                ?
            size.width * 0.037 * name.length
                :
            size.width * 0.035 * text.length
            ,
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.01,
                vertical: size.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: sender ?
                  const Radius.circular(15)
                      :
                  const Radius.circular(15),
                  topLeft: !sender ?
                  const Radius.circular(15)
                      :
                  const Radius.circular(15),
                  bottomLeft: sender ?
                  const Radius.circular(15)
                      :
                  const Radius.circular(0),
                  bottomRight: !sender ?
                  const Radius.circular(15)
                      :
                  const Radius.circular(0),
                )
            ),
            padding: EdgeInsets.symmetric(horizontal: size.height*0.02,vertical: size.height*0.003),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                reply
                    ?
                Container(

                  margin: EdgeInsets.only(
                    bottom: size.height*0.01,
                    top: size.height*0.01,

                  ),
                  padding: EdgeInsets.all(size.height*0.008),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(replyToName,style: GoogleFonts.exo(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        color: Colors.white
                      ),
                      ),
                      Text(
                        ReplyToText.toString()
                            .substring(0,ReplyToText.length<120 ? ReplyToText.length : 120),
                        style: GoogleFonts.exo(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.white
                        ),),
                    ],
                  ),
                )
                    :
                const SizedBox(),
                SizedBox(
                  child: AutoSizeText(name,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.028,
                        fontWeight: FontWeight.w600
                    ),),
                ),
                SizedBox(
                  width: size.width * 0.92,
                  child: AutoSizeText(
                    text,
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.92,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        "${stamp.hour}:${stamp.minute < 10 ? "0" : ""}${stamp.minute} ${stamp.hour < 12 ? "am" : "pm"}",
                        style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: size.width * 0.022,
                            fontWeight: FontWeight.w400
                        ),
                        textAlign: TextAlign.right,
                      ),
                      // sender
                      //     ?
                      // Icon(
                      //   Icons.check_circle_outline,
                      //   color: min>length-index
                      //       ?
                      //   Colors.green
                      //       :
                      //   Colors.black.withOpacity(0.8),
                      // )
                      //     :
                      // const SizedBox()
                    ],
                  ),
                )
              ],
            ),
          ),

          !sender
              ?
          const SizedBox()
              :
          Row(
            children: [
              CircleAvatar(
                radius: size.width * 0.045,
                backgroundImage: image !="null"?

                NetworkImage(image)
                    :
                null,
                // backgroundColor: Colors.teal.shade300,
                child: image == "null" ?
                AutoSizeText(
                  name.substring(0, 1),
                  style: GoogleFonts.exo(
                      fontSize: size.height * 0.01,
                      fontWeight: FontWeight.w600),
                )
                    :
                null,
              ),
              SizedBox(width: size.width * 0.02),
            ],
          ),
        ],
      ),
    );
  }
  Widget date(DateTime date){

    return DateChip(
        date: date,
      color: Colors.white,

    );
  }
  Future<void> readTick() async {
    await FirebaseFirestore
        .instance
        .collection("Messages")
        .doc(widget.channel)
        .get()
        .then((value) {
          value
              .data()!["Members"]
              .forEach((email) async {
        await FirebaseFirestore
            .instance
            .collection("Messages")
            .doc(widget.channel)
            .get()
            .then((value2) {
          tick.add(
              value2.data()![email.toString().split("@")[0]]["Readed_count"]);
        });
      });
    }).whenComplete(() => setState((){}));

  }
  updateReadedCount(String channel,int length) async {
    await FirebaseFirestore
        .instance
        .collection("Messages")
        .doc(channel)
        .update({
      usermodel["Email"].toString().split("@")[0] : {"Readed_count":length}
    }).whenComplete(() => readTick());

  }
  // Future<String> takeScreenShot() async {
  //   final imageFile = await chatcontroller.capture();
  //   final directory = await getExternalStorageDirectory();
  //   final imagePath = await File('${directory?.path}/image.png').create();
  //   await imagePath.writeAsBytes(imageFile!).whenComplete(() {
  //     Future.delayed(const Duration(seconds: 3));
  //       SSpath = "${directory?.path}/image.png";
  //
  //     print(SSpath);
  //   });
  //
  //   /// Share Plugin
  //   return "";
  // }
  }
