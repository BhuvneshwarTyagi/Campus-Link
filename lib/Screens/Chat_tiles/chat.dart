import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import '../../Database/database.dart';
import '../loadingscreen.dart';
import 'chat_info.dart';
import 'chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.channel}) : super(key: key);
  final String channel;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatController = ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    chatUsers: [],
  );
  final currentUser = ChatUser(
    id: '${usermodel["Email"]}',
    name: '${usermodel["Name"]}',
    profilePhoto: usermodel["Profile_URL"],
  );
  bool loadChat=true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .doc(widget.channel)
            .snapshots(),
        builder: (context, snapshot) {
          String channel='';
          int activeCount=0;
          if(snapshot.hasData){
            activeCount=activeStatus(snapshot);
            snapshot.data!.data()!['Type']=="Personal"
                ?
            snapshot.data!.data()!['Members'][0]["Email"]==usermodel["Email"]
                ?
            channel=snapshot.data!.data()!['Members'][1]["Name"]
                :
            channel=snapshot.data!.data()!['Members'][0]["Name"]
                :
            channel=widget.channel;
            if(loadChat){
              print("reloaded");
              for (var member in snapshot.data!.data()!["Members"]) {
                chatController.chatUsers.add(
                  ChatUser(
                    id: '${member["Email"]}',
                    name: member["Email"].toString().split("@")[0],
                    profilePhoto: snapshot.data!.data()![member["Email"].toString().split("@")[0]]["Profile_URL"],
                  ),
                );

              }

              for (var msg in snapshot.data!.data()!["Messages"]) {
                final message1 = Message(
                    id: msg['Stamp'].toString(),
                    message: msg['text'],
                    createdAt: msg['Stamp'].toDate(),
                    sendBy: msg["UID"],
                    replyMessage: ReplyMessage(
                      message: msg['ReplyMessage'],
                      messageId: msg["ReplyMessageId"],
                      messageType: MessageType.text,
                      replyTo: msg['ReplyTo'],
                      replyBy: msg['ReplyBy'],
                    )
                );
                chatController.initialMessageList.add(message1);
              }
              loadChat=false;
            }
            if(!loadChat && snapshot.data!.data()!["Messages"].length > snapshot.data!.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"]){
              print("..........inside");
              for (var member in snapshot.data!.data()!["Members"]) {
                chatController.chatUsers.add(
                  ChatUser(
                    id: '${member["Email"]}',
                    name: member["Email"].toString().split("@")[0],
                    profilePhoto: snapshot.data!.data()![member["Email"].toString().split("@")[0]]["Profile_URL"],
                  ),
                );

              }

              for (int i=snapshot.data!.data()![usermodel["Email"].toString().split("@")[0]]["Read_Count"];i<snapshot.data!.data()!["Messages"].length;i++) {
                print("...................i: $i");
                final message1 = Message (
                    id: snapshot.data!.data()!["Messages"][i]['Stamp'].toString(),
                    message: snapshot.data!.data()!["Messages"][i]['text'],
                    createdAt: snapshot.data!.data()!["Messages"][i]['Stamp'].toDate(),
                    sendBy: snapshot.data!.data()!["Messages"][i]["UID"],
                    replyMessage: ReplyMessage(
                      message: snapshot.data!.data()!["Messages"][i]['ReplyMessage'],
                      messageId: snapshot.data!.data()!["Messages"][i]["ReplyMessageId"],
                      messageType: MessageType.text,
                      replyTo: snapshot.data!.data()!["Messages"][i]['ReplyTo'],
                      replyBy: snapshot.data!.data()!["Messages"][i]['ReplyBy'],
                    )
                );
                chatController.initialMessageList.add(message1);
              }
              countUpdate(snapshot.data!.data()!["Messages"].length);
            }
          }

          return snapshot.hasData
              ?
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                    AssetImage("assets/images/${usermodel["bg"]}"),
                    fit: BoxFit.fill)),
            width: size.width,
            child: ChatView(
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return  Chat_Info(channel: widget.channel, membersCount: snapshot.data!.data()!["Members"].length, url: snapshot.data!.data()!["image_URL"], muted: snapshot.data!.data()![usermodel["Email"].toString().split("@")[0]]["Mute"] ?? false,);
                              },
                        ),
                    );
                    },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        channel,
                        style: GoogleFonts.exo(
                          fontSize: size.width*0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      activeCount > 0
                                                  ?
                                              AutoSizeText(
                                                "$activeCount Online",
                                                style: GoogleFonts.exo(
                                                    color: Colors
                                                        .green,
                                                    fontSize:
                                                    size.width *
                                                        0.028),
                                                minFontSize: 1,
                                                maxLines: 1,
                                              )
                                                  :
                                              const SizedBox(),
                    ],
                  ),
                ),
                elevation: 0,
                leading: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              profileCircleConfig: ProfileCircleConfiguration(
                circleRadius: size.width*0.03,
                profileImageUrl: usermodel["Profile_URL"],
              ),
              chatBackgroundConfig: const ChatBackgroundConfiguration(backgroundColor: Colors.black38),
              currentUser: currentUser,
              chatController: chatController,
              onSendTap: onSendTap,
              sendMessageConfig: SendMessageConfiguration(

                textFieldConfig: TextFieldConfiguration(
                  textStyle: GoogleFonts.exo(
                    fontSize: size.width*0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
                )
              ),
              chatViewState: ChatViewState.hasMessages,
              chatBubbleConfig:  ChatBubbleConfiguration(
                maxWidth: size.width*0.6,
                outgoingChatBubbleConfig: ChatBubble(
                  senderNameTextStyle: GoogleFonts.exo(
                    fontSize: size.width*0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),// demonstrates as current user chat bubble
                  margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
                  linkPreviewConfig: const LinkPreviewConfiguration(
                    proxyUrl: "Proxy URL", // Need for web
                    backgroundColor: Color(0xff272336),
                    bodyStyle: TextStyle(color: Colors.white),
                    titleStyle: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(0),
                  ),
                  textStyle: GoogleFonts.exo(
                    fontSize: size.width*0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )
                ),
                inComingChatBubbleConfig: ChatBubble( // demonstrates as current user chat bubble
                    margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
                    linkPreviewConfig: const LinkPreviewConfiguration(
                      proxyUrl: "Proxy URL", // Need for web
                      backgroundColor: Color(0xff272336),
                      bodyStyle: TextStyle(color: Colors.white),
                      titleStyle: TextStyle(color: Colors.white),
                    ),
                    color: Colors.deepPurple,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(0),
                    ),
                    textStyle: GoogleFonts.exo(
                      fontSize: size.width*0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )
                ),
              ),
              // Add this state once data is available.
              repliedMessageConfig: RepliedMessageConfiguration(
                repliedMsgAutoScrollConfig: const RepliedMsgAutoScrollConfig(
                  enableHighlightRepliedMsg: true,
                  enableScrollToRepliedMsg: true,
                  highlightScrollCurve: accelerateEasing,
                  highlightColor: Colors.green,
                  highlightScrollDuration: Duration(milliseconds: 100)
                ),
                textStyle: GoogleFonts.exo(
                  fontSize: size.width*0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                verticalBarColor: Colors.green,
                backgroundColor: Colors.white12,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                replyTitleTextStyle: GoogleFonts.exo(
                  fontSize: size.width*0.032,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // child: StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection("Messages")
            //         .doc(widget.channel)
            //         .collection("Messages_Detail")
            //         .doc("Messages_Detail")
            //         .snapshots(),
            //     builder: (context, snapshot2) {
            //
            //       return snapshot2.hasData
            //           ?
            //       Scaffold(
            //         backgroundColor: Colors.transparent,
            //         appBar: !selected
            //             ?
            //
            //         AppBar(
            //           elevation: 0,
            //           backgroundColor: Colors.black87,
            //           leadingWidth: size.width*0.13,
            //           titleSpacing: 0,
            //           leading: InkWell(
            //               onTap: () async {
            //                 Navigator.pushReplacement(
            //                     context,
            //                     MaterialPageRoute(builder: (context) {
            //                       return const chatsystem();
            //
            //                     },)
            //                 );
            //               },
            //               child: const Icon(
            //                   Icons.arrow_back_ios_new)),
            //           centerTitle: false,
            //           title:
            //           type == "Personal"
            //               ?
            //           StreamBuilder(
            //             stream: FirebaseFirestore
            //                 .instance
            //                 .collection(snapshot.data!.data()!["Members"][0]["Name"]==usermodel["Name"] ? snapshot.data!.data()!["Members"][1]["Post"] : snapshot.data!.data()!["Members"][0]["Post"])
            //                 .doc(snapshot.data!.data()!["Members"][0]["Name"]==usermodel["Name"] ? snapshot.data!.data()!["Members"][1]["Email"] : snapshot.data!.data()!["Members"][0]["Email"])
            //                 .snapshots(),
            //             builder: (context, snapshot1) {
            //               return snapshot.hasData ?
            //               Row(
            //                 mainAxisAlignment:
            //                 MainAxisAlignment.start,
            //                 children: [
            //                   CircleAvatar(
            //                     radius: size.height * 0.027,
            //                     backgroundColor: Colors.white70,
            //                     backgroundImage: snapshot1.data?.data()!["Profile_URL"] != "null"
            //                         ?
            //                     NetworkImage(snapshot1.data?.data()!["Profile_URL"] ?? "")
            //                         :
            //                     null,
            //
            //                     child: snapshot1.data?.data()!["Profile_URL"] == "null"
            //                         ?
            //                     AutoSizeText(
            //                       widget.channel.substring(0, 1),
            //                       style: GoogleFonts.exo(
            //                           color: Colors.black,
            //                           fontSize: size.height * 0.035,
            //                           fontWeight: FontWeight.w600),
            //                     )
            //                         : null,
            //                   ),
            //                   SizedBox(
            //                     width: size.width * 0.01,
            //                   ),
            //                   TextButton(
            //                     onPressed: () {
            //                       Navigator.push(
            //                         context,
            //                         PageTransition(
            //                             childCurrent: ChatPage(
            //                                 channel: widget.channel),
            //                             child: Chat_Info(
            //                               muted: snapshot.data!.data()?[usermodel["Email"].toString().split("@")[0]]["Mute Notification"] ?? true,
            //                               channel: widget.channel,
            //                               membersCount: snapshot.data!.data()!["Members"].length,
            //                               url: snapshot.data?.data()!["image_URL"] ?? "",
            //                             ),
            //                             type: PageTransitionType
            //                                 .rightToLeftJoined,
            //                             duration:
            //                             const Duration(
            //                                 milliseconds:
            //                                 300)),
            //                       );
            //                     },
            //                     child: Column(
            //                       mainAxisAlignment:
            //                       MainAxisAlignment.center,
            //                       crossAxisAlignment:
            //                       CrossAxisAlignment.start,
            //                       children: [
            //                         SizedBox(
            //                           width: size.width * 0.56,
            //                           child: AutoSizeText(
            //                             snapshot1.data?.data()!["Name"],
            //                             style: GoogleFonts.exo(
            //                                 color: Colors.white,
            //                                 fontSize:
            //                                 size.width *
            //                                     0.045),
            //                             maxLines: 1,
            //                             minFontSize: 1,
            //                           ),
            //                         ),
            //                         activeCount > 0
            //                             ?
            //                         AutoSizeText(
            //                           "$activeCount Online",
            //                           style: GoogleFonts.exo(
            //                               color: Colors
            //                                   .green,
            //                               fontSize:
            //                               size.width *
            //                                   0.028),
            //                           minFontSize: 1,
            //                           maxLines: 1,
            //                         )
            //                             :
            //                         const SizedBox(),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               )
            //                   :
            //               const SizedBox();
            //             },
            //           )
            //               :
            //           Row(
            //             mainAxisAlignment:
            //             MainAxisAlignment.start,
            //             children: [
            //               CircleAvatar(
            //                 radius: size.height * 0.027,
            //                 backgroundColor: Colors.white70,
            //                 backgroundImage: snapshot.data?.data()!["image_URL"] != "null"
            //                     ?
            //                 NetworkImage(snapshot.data?.data()!["image_URL"])
            //                     :
            //                 null,
            //
            //                 child: snapshot.data?.data()!["image_URL"] == "null"
            //                     ?
            //                 AutoSizeText(
            //                   widget.channel.substring(0, 1),
            //                   style: GoogleFonts.exo(
            //                     color: Colors.black,
            //                       fontSize: size.height * 0.035,
            //                       fontWeight: FontWeight.w600),
            //                 )
            //                     : null,
            //               ),
            //               SizedBox(
            //                 width: size.width * 0.01,
            //               ),
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.push(
            //                     context,
            //                     PageTransition(
            //                         childCurrent: ChatPage(
            //                             channel: widget.channel),
            //                         child: Chat_Info(
            //                           muted: snapshot.data!.data()?[usermodel["Email"].toString().split("@")[0]]["Mute Notification"] ?? true,
            //                           channel: widget.channel,
            //                           membersCount: snapshot.data!.data()!["Members"].length,
            //                           url: snapshot.data?.data()!["image_URL"] ?? "",
            //                         ),
            //                         type: PageTransitionType
            //                             .rightToLeftJoined,
            //                         duration:
            //                         const Duration(
            //                             milliseconds:
            //                             300)),
            //                   );
            //                 },
            //                 child: Column(
            //                   mainAxisAlignment:
            //                   MainAxisAlignment.center,
            //                   crossAxisAlignment:
            //                   CrossAxisAlignment.start,
            //                   children: [
            //                     SizedBox(
            //                       width: size.width * 0.56,
            //                       child: AutoSizeText(
            //                         widget.channel,
            //                         style: GoogleFonts.exo(
            //                             color: Colors.white,
            //                             fontSize:
            //                             size.width *
            //                                 0.045),
            //                         maxLines: 1,
            //                         minFontSize: 1,
            //                       ),
            //                     ),
            //                     activeCount > 0
            //                         ? AutoSizeText(
            //                       "$activeCount Online",
            //                       style: GoogleFonts.exo(
            //                           color: Colors
            //                               .green,
            //                           fontSize:
            //                           size.width *
            //                               0.028),
            //                       minFontSize: 1,
            //                       maxLines: 1,
            //                     )
            //                         : const SizedBox(),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //           actions: <Widget>[
            //             PopupMenuButton(
            //               icon: Icon(
            //                 Icons.more_vert,
            //                 size: size.height * 0.04,
            //               ),
            //               itemBuilder: (context) {
            //                 return [
            //                   PopupMenuItem(
            //                       child: TextButton(
            //                           onPressed: () {},
            //                           child: const Text(
            //                             "Search",
            //                             style: TextStyle(
            //                                 color: Colors
            //                                     .black),
            //                           ))),
            //                   PopupMenuItem(
            //                       child: TextButton(
            //                           onPressed: () {},
            //                           child: const Text(
            //                             "Wallpaper",
            //                             style: TextStyle(
            //                                 color: Colors
            //                                     .black),
            //                           ))),
            //                   PopupMenuItem(
            //                       child: TextButton(
            //                           onPressed: () {},
            //                           child: const Text(
            //                             "Setting",
            //                             style: TextStyle(
            //                                 color: Colors
            //                                     .black),
            //                           ))),
            //                   PopupMenuItem(
            //                       child: TextButton(
            //                           onPressed: () {},
            //                           child: const Text(
            //                             "More",
            //                             style: TextStyle(
            //                                 color: Colors
            //                                     .black),
            //                           ))),
            //                 ];
            //               },
            //             )
            //           ],
            //         )
            //             :
            //         AppBar(
            //           elevation: 0,
            //           backgroundColor: Colors.black87,
            //           leading: IconButton(
            //             onPressed: () {
            //               setState(() {
            //                 selected = !selected;
            //               });
            //             },
            //             icon: const Icon(
            //                 Icons.arrow_back_ios_new),
            //           ),
            //           actions: [
            //             IconButton(
            //                 onPressed: () async {
            //                   await FirebaseFirestore
            //                       .instance
            //                       .collection("Messages")
            //                       .doc(widget.channel)
            //                       .update({
            //                     "Messages":
            //                     FieldValue.arrayRemove(
            //                         [message[index1]])
            //                   });
            //                   setState(() {
            //                     index1 = -1;
            //                     selected = !selected;
            //                   });
            //                 },
            //                 icon: const Icon(
            //                     Icons.delete_outline))
            //           ],
            //         ),
            //         body: SizedBox(
            //           height: size.height,
            //           //color: Colors.black26,
            //           child: Column(
            //             children: [
            //               SizedBox(
            //                 height: size.height*0.1,
            //                 child: message.isNotEmpty
            //                     ? ScrollablePositionedList.builder(
            //                   reverse: true,
            //                   scrollDirection: Axis.vertical,
            //                   itemScrollController:
            //                   scrollController,
            //                   itemCount: message.length,
            //                   itemBuilder: (context, index) {
            //                     print(
            //                         "ddddddddddddddddddddddddddddddddddd${message[index]["Stamp"].toString().split(".")[0]}");
            //
            //                     bool Reply = false;
            //                     message[index]["Reply"] == null
            //                         ? Reply = false
            //                         : Reply =
            //                     message[index]["Reply"];
            //
            //                     bool Image = false;
            //                     message[index]["Image_Text"] ==
            //                         null
            //                         ? Image = false
            //                         : Image = message[index]
            //                     ["Image_Text"];
            //
            //                     bool Video = false;
            //                     message[index]["Video_Text"] ==
            //                         null
            //                         ? Video = false
            //                         : Video = message[index]
            //                     ["Video_Text"];
            //
            //                     print(">...UID ${message[index]["Stamp"]}");
            //                     return Column(
            //                       mainAxisAlignment:
            //                       MainAxisAlignment.end,
            //                       children: [
            //                         index != message.length - 1
            //                             ? message[index + 1]
            //                         ["Stamp"]
            //                             .toDate()
            //                             .day ==
            //                             message[index]
            //                             ["Stamp"]
            //                                 .toDate()
            //                                 .day
            //                             ? const SizedBox()
            //                             : date(message[index]
            //                         ["Stamp"]
            //                             .toDate())
            //                             : date(message[index]
            //                         ["Stamp"]
            //                             .toDate()),
            //                         message[index]["UID"] ==
            //                             usermodel["Email"]
            //                             ? SwipeTo(
            //                           onLeftSwipe: () {
            //                             setState(
            //                                   () {
            //                                 replyBoxHeight =
            //                                     size.height *
            //                                         0.17;
            //                                 replyIndex =
            //                                     index;
            //                               },
            //                             );
            //                           },
            //                           child: InkWell(
            //                             onLongPress:
            //                                 () async {
            //                               setState(() {
            //                                 index1 = index;
            //                                 selected =
            //                                 !selected;
            //                               });
            //                             },
            //                             child: bubble(
            //                                 message[index]["UID"],
            //                                 scrollController,
            //                                 "${message[index]["text"]}",
            //                                 "${message[index]["Name"]}",
            //                                 "${message[index]["Image"]}",
            //                                 message[index]
            //                                 ["Stamp"]
            //                                     .toDate(),
            //                                 true,
            //                                 size,
            //                                 index,
            //                                 message.length,
            //                                 Reply,
            //                                 Reply
            //                                     ? message[int
            //                                     .parse(
            //                                     "${message.length - message[index]["Reply_Index"] - 1}")]
            //                                 ["Name"]
            //                                     : "",
            //                                 Reply
            //                                     ? message[int
            //                                     .parse(
            //                                     "${message.length - message[index]["Reply_Index"] - 1}")]
            //                                 ["text"]
            //                                     : "",
            //                                 Reply
            //                                     ? int.parse(
            //                                     "${message.length - message[index]["Reply_Index"] - 1}")
            //                                     : 0,
            //                                 message[index]["Media_Type"].toString()=="Image",
            //
            //                                 message[index]["Media_Type"].toString()=="Image"
            //                                     ?
            //                                 message[index]["Image_Url"]
            //                                     :
            //                                 "",
            //
            //                                 message[index]["Media_Type"].toString()=="Image"
            //                                     ?
            //                                 message[index]["Image_Thumbnail"]
            //                                     :
            //                                 "",
            //
            //                                 message[index]["Media_Type"].toString()=="Video",
            //
            //                                 message[index]["Media_Type"].toString()=="Video"
            //                                     ?
            //                                 message[index]["Video_Url"]
            //                                     : "",
            //                                 message[index]["Media_Type"].toString()=="Video"
            //                                     ?
            //                                 message[index]["Video_Thumbnail"]
            //                                     :
            //                                 "",
            //                                 snapshot2.data?.data()!["${message[index]["UID"].toString().split("@")[0]}_${message[index]["Stamp"].toDate().toString().split('.')[0]}_Delevered"].length == snapshot.data!.data()?["Members"].length,
            //                                 snapshot2.data?.data()!["${message[index]["UID"].toString().split("@")[0]}_${message[index]["Stamp"].toDate().toString().split('.')[0]}_Seened"].length == snapshot.data!.data()?["Members"].length,
            //                                 message[index]["Media_Type"].toString()=="Pdf",
            //
            //                                 message[index]["Media_Type"].toString()=="Pdf"
            //                                     ?
            //                                 message[index]["Pdf_Url_Image"]
            //                                     : "",
            //                                 message[index]["Media_Type"].toString()=="Pdf"
            //                                     ?
            //                                 message[index]["Pdf_Url"]
            //                                     :
            //                                 "",
            //                                 message[index]["Doc_Name"] ?? "",
            //                                 message[index]["Media_Type"].toString()=="Pdf"
            //                                     ?message[index]["Doc_Size"] : 0,
            //                                 snapshot
            //                             ),
            //                           ),
            //                         )
            //                             :
            //                         SwipeTo(
            //                           onRightSwipe: () {
            //                             setState(() {
            //                               replyBoxHeight =
            //                                   size.height *
            //                                       0.17;
            //                               replyIndex =
            //                                   index;
            //                             });
            //                           },
            //                           child: bubble(
            //                               message[index]["UID"],
            //                               scrollController,
            //                               "${message[index]["text"]}",
            //                               "${message[index]["Name"]}",
            //                               "${message[index]["Image"]}",
            //                               message[index]["Stamp"].toDate(),
            //                               false,
            //                               size,
            //                               index,
            //                               message.length,
            //                               Reply,
            //                               Reply
            //                                   ?
            //                               message[int.parse("${message.length - message[index]["Reply_Index"] - 1}")]["Name"]
            //                                   :
            //                               "",
            //                               Reply
            //                                   ?
            //                               message[int.parse("${message.length - message[index]["Reply_Index"] - 1}")]["text"]
            //                                   :
            //                               "",
            //                               Reply
            //                                   ?
            //                               int.parse("${message.length - message[index]["Reply_Index"] - 1}")
            //                                   :
            //                               0,
            //
            //                               message[index]["Media_Type"].toString()=="Image",
            //
            //                               message[index]["Media_Type"].toString()=="Image"
            //                                   ?
            //                               message[index]["Image_Url"]
            //                                   :
            //                               "",
            //
            //                               message[index]["Media_Type"].toString()=="Image"
            //                                   ?
            //                               message[index]["Image_Thumbnail"]
            //                                   :
            //                               "",
            //
            //                               message[index]["Media_Type"].toString()=="Video",
            //
            //                               message[index]["Media_Type"].toString()=="Video"
            //                                   ?
            //                               message[index]["Video_Url"]
            //                                   : "",
            //                               message[index]["Media_Type"].toString()=="Video"
            //                                   ?
            //                               message[index]["Video_Thumbnail"]
            //                                   :
            //                               "",
            //                               snapshot2.data?.data()!["${message[index]["UID"].toString().split("@")[0]}_${message[index]["Stamp"].toDate().toString().split(".")[0]}_Delevered"].length == snapshot.data!.data()?["Members"].length,
            //                               snapshot2.data?.data()!["${message[index]["UID"].toString().split("@")[0]}_${message[index]["Stamp"].toDate().toString().split(".")[0]}_Seened"].length == snapshot.data!.data()?["Members"].length,
            //                               message[index]["Media_Type"].toString()=="Pdf",
            //
            //                               message[index]["Media_Type"].toString()=="Pdf"
            //                                   ?
            //                               message[index]["Pdf_Url_Image"]
            //                                   : "",
            //                               message[index]["Media_Type"].toString()=="Pdf"
            //                                   ?
            //                               message[index]["Pdf_Url"]
            //                                   :
            //                               "",
            //                               message[index]["Doc_Name"] ?? "",
            //                               message[index]["Doc_Size"] ?? 0,
            //                               snapshot
            //                           ),
            //                         )
            //                       ],
            //                     );
            //                   },
            //                 )
            //                     :
            //                 const SizedBox(),
            //               ),
            //               Expanded(
            //                 child: ChatView(
            //                   currentUser: currentUser,
            //                   chatController: chatController,
            //                   onSendTap: onSendTap,
            //                   chatViewState: ChatViewState.hasMessages,
            //                   chatBubbleConfig: const ChatBubbleConfiguration(
            //                       outgoingChatBubbleConfig: ChatBubble( // demonstrates as current user chat bubble
            //                         margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            //                         linkPreviewConfig: LinkPreviewConfiguration(
            //                           proxyUrl: "Proxy URL", // Need for web
            //                           backgroundColor: Color(0xff272336),
            //                           bodyStyle: TextStyle(color: Colors.white),
            //                           titleStyle: TextStyle(color: Colors.white),
            //                         ),
            //                         color: Color(0xff9f85ff),
            //                       )
            //                   ),// Add this state once data is available.
            //                 ),
            //               )
            //             ],
            //           )
            //         ),
            //         bottomNavigationBar: Padding(
            //           padding: EdgeInsets.only(
            //               bottom: MediaQuery.of(context)
            //                   .viewInsets
            //                   .bottom),
            //           child: Container(
            //             width: size.width,
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: size.width * 0.03,
            //                 vertical: size.height * 0.01),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 Stack(
            //                     alignment: Alignment.bottomCenter,
            //                     children: [
            //                       AnimatedContainer(
            //                         height: replyBoxHeight,
            //                         width: size.width * 0.73,
            //                         decoration:
            //                         const BoxDecoration(
            //                           color: Colors.black87,
            //                           borderRadius:
            //                           BorderRadius.only(
            //                             topRight:
            //                             Radius.circular(12),
            //                             topLeft:
            //                             Radius.circular(12),
            //                             bottomRight:
            //                             Radius.circular(30),
            //                             bottomLeft:
            //                             Radius.circular(30),
            //                           ),
            //                         ),
            //                         duration: const Duration(milliseconds: 200),
            //                         child: Stack(
            //                           alignment:
            //                           Alignment.topRight,
            //                           children: [
            //                             Container(
            //                               width: size.width * 0.8,
            //                               margin: EdgeInsets.only(
            //                                 bottom: size.height *
            //                                     0.07,
            //                                 top: size.height *
            //                                     0.01,
            //                                 right: size.height *
            //                                     0.01,
            //                                 left: size.height *
            //                                     0.01,
            //                               ),
            //                               padding: EdgeInsets.all(
            //                                   size.height *
            //                                       0.008),
            //                               decoration: const BoxDecoration(
            //                                   color: Colors.white,
            //                                   borderRadius:
            //                                   BorderRadius
            //                                       .all(Radius
            //                                       .circular(
            //                                       12))),
            //                               child: Column(
            //                                 crossAxisAlignment:
            //                                 CrossAxisAlignment
            //                                     .start,
            //                                 children: [
            //                                   Text(
            //                                     message.isNotEmpty ? message[replyIndex]["Name"] : "",
            //                                     style: GoogleFonts.exo(
            //                                         fontWeight:
            //                                         FontWeight
            //                                             .w600,
            //                                         fontSize: 14),
            //                                   ),
            //                                   Text(
            //                                     message.isNotEmpty ? message[replyIndex]["text"].toString()
            //                                         .substring(0, message[replyIndex]["text"].length <
            //                                             120
            //                                             ? message[replyIndex]["text"]
            //                                             .length
            //                                             : 120) : "",
            //                                     style: GoogleFonts.exo(
            //                                         fontWeight:
            //                                         FontWeight
            //                                             .w500,
            //                                         fontSize: 13),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                             IconButton(
            //                                 onPressed: () {
            //                                   setState(() {
            //                                     replyBoxHeight =
            //                                     0;
            //                                     replyIndex = 0;
            //                                   });
            //                                 },
            //                                 icon: const Icon(
            //                                     Icons.clear))
            //                           ],
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: size.width * 0.75,
            //                         child: TextField(
            //                           enabled: !(snapshot.data!.data()?[usermodel["Email"].toString().split("@")[0]]["Mute"] ?? false),
            //                           cursorColor: Colors.black,
            //                           controller: messageController,
            //                           enableSuggestions: true,
            //                           maxLines: 3,
            //                           minLines: 1,
            //                           autocorrect: true,
            //                           textAlign: TextAlign.start,
            //                           style: TextStyle(
            //                               color: Colors.black,
            //                               fontSize: size.width*0.045),
            //                           decoration: InputDecoration(
            //
            //
            //                             suffix: PopupMenuButton(
            //                               child: const Icon(Icons.attach_file_rounded),
            //
            //                               itemBuilder: (context) {
            //                                 return [
            //                                   PopupMenuItem(child: Transform.rotate(
            //                                     angle: 1.6,
            //                                     child: IconButton(
            //                                         onPressed:
            //                                             () async {
            //                                           await FilePicker
            //                                               .platform
            //                                               .pickFiles(
            //                                               type: FileType.custom,
            //                                               allowedExtensions: ['pdf'],
            //                                               allowMultiple: false)
            //                                               .then(
            //                                                   (value) {
            //                                                 print(
            //                                                     "..............value : $value");
            //                                                 if (value!
            //                                                     .files
            //                                                     .isNotEmpty) {
            //                                                   Navigator.push(
            //                                                       context,
            //                                                       MaterialPageRoute(
            //                                                         builder:
            //                                                             (context) {
            //                                                           return DocumentViewer(
            //                                                             msgLength: message.length,
            //                                                             replyIndex: replyIndex,
            //                                                             channel: widget.channel,
            //                                                             document: value,
            //                                                             replyToName: message[replyIndex]["Name"],
            //                                                             replyToText: message[replyIndex]["text"].toString().substring(0, message[replyIndex]["text"].length > 120 ? 120 : message[replyIndex]["text"].length),
            //                                                             replyBoxHeight: replyBoxHeight,
            //                                                           );
            //                                                         },
            //                                                       ));
            //                                                 }
            //                                               });
            //                                         },
            //                                         icon: const Icon(
            //                                             Icons
            //                                                 .attachment_outlined)),
            //                                   ),),
            //                                   PopupMenuItem(child: Transform.rotate(
            //                                     angle: 1.6,
            //                                     child: IconButton(
            //                                         onPressed:
            //                                             () async {
            //                                           ImagePicker
            //                                           imagePicker =
            //                                           ImagePicker();
            //                                           print(
            //                                               imagePicker);
            //                                           XFile? file = await imagePicker.pickVideo(
            //                                               source: ImageSource
            //                                                   .gallery,
            //                                               maxDuration:
            //                                               const Duration(seconds: 30));
            //                                           file!.path
            //                                               .isNotEmpty
            //                                               ? Navigator
            //                                               .push(
            //                                             context,
            //                                             PageTransition(
            //                                                 childCurrent: ChatPage(channel: widget.channel),
            //                                                 duration: const Duration(milliseconds: 600),
            //                                                 child: SendMedia(
            //                                                   imagePath: file,
            //                                                   channel: widget.channel,
            //                                                   messageLength: message.length,
            //                                                   replyBoxHeight: replyBoxHeight,
            //                                                   replyToName: message[replyIndex]["Name"],
            //                                                   replyToText: message[replyIndex]["text"].toString().substring(0, message[replyIndex]["text"].length > 120 ? 120 : message[replyIndex]["text"].length),
            //                                                   replyIndex: replyIndex,
            //                                                   video: true,
            //                                                 ),
            //                                                 type: PageTransitionType.bottomToTopJoined),
            //                                           )
            //                                               : null;
            //                                         },
            //                                         icon: Icon(
            //                                           Icons
            //                                               .video_collection,
            //                                           color: Colors
            //                                               .black,
            //                                           size: size
            //                                               .height *
            //                                               0.04,
            //                                         )),
            //                                   ),),
            //                                   PopupMenuItem(
            //                                   child: IconButton(
            //                                       onPressed:
            //                                           () async {
            //                                         ImagePicker
            //                                         imagePicker =
            //                                         ImagePicker();
            //                                         print(
            //                                             imagePicker);
            //                                         XFile? file = await imagePicker
            //                                             .pickImage(
            //                                             source: ImageSource.gallery)
            //                                             .then((value) {
            //                                           print(
            //                                               ",,,,,,,,,,,,,${value?.path}");
            //                                           value!.path.isNotEmpty
            //                                               ? Navigator.push(
            //                                             context,
            //                                             PageTransition(
            //                                                 childCurrent: ChatPage(channel: widget.channel),
            //                                                 duration: Duration(milliseconds: 600),
            //                                                 child: SendMedia(
            //                                                   imagePath: value,
            //                                                   channel: widget.channel,
            //                                                   messageLength: message.length,
            //                                                   replyBoxHeight: replyBoxHeight,
            //                                                   replyToName: message[replyIndex]["Name"],
            //                                                   replyToText: message[replyIndex]["text"].toString().substring(0, message[replyIndex]["text"].length > 120 ? 120 : message[replyIndex]["text"].length),
            //                                                   replyIndex: replyIndex,
            //                                                   video: false,
            //                                                 ),
            //                                                 type: PageTransitionType.bottomToTopJoined),
            //                                           )
            //                                               : null;
            //                                         });
            //                                       },
            //                                       icon: Icon(
            //                                         Icons
            //                                             .image,
            //                                         color: Colors
            //                                             .black,
            //                                         size: size
            //                                             .height *
            //                                             0.04,
            //                                       )),)
            //                                 ];
            //                               },
            //                             ),                                        suffixIconColor: Colors.black,
            //                             fillColor: Colors.white70,
            //                             filled: true,
            //                             hintText: "Message",
            //                             hintStyle:
            //                             GoogleFonts.exo(
            //                               color: Colors.black54,
            //                               fontSize: size.width*0.045, //height:size.height*0.0034
            //                             ),
            //                             contentPadding: EdgeInsets.all(size.width * 0.02),
            //                             enabledBorder: const OutlineInputBorder(
            //                                 borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //                                 borderSide:
            //                                 BorderSide(color: Colors.black54, width: 1),
            //                             ),
            //                             focusedBorder: const OutlineInputBorder(
            //                                 borderRadius:
            //                                 BorderRadius.all(
            //                                     Radius
            //                                         .circular(
            //                                         30.0)),
            //                                 borderSide:
            //                                 BorderSide(
            //                                     color: Colors
            //                                         .black54,
            //                                     width: 1)),
            //                             disabledBorder: const OutlineInputBorder(
            //                                 borderRadius:
            //                                 BorderRadius.all(
            //                                     Radius
            //                                         .circular(
            //                                         30.0)),
            //                                 borderSide:
            //                                 BorderSide(
            //                                     color: Colors
            //                                         .black54,
            //                                     width: 1)),
            //                             prefixIcon: Icon(
            //                               Icons
            //                                   .emoji_emotions_outlined,
            //                               size:
            //                               size.height * 0.042,
            //                               color: Colors.black87,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ]),
            //                  InkWell(
            //                   onTap: () async {
            //                     DateTime stamp = DateTime.now();
            //                     //int l=message.length+1;
            //                     final doc=await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").get();
            //
            //                     messageController.text.trim() != ""
            //                         ?
            //                     !doc.exists
            //                         ?
            //                     await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").set({
            //                       "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Delevered" : FieldValue.arrayUnion([{
            //                         "Email" : usermodel["Email"],
            //                         "Stamp" : stamp
            //                       }]),
            //                       "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Seen" : FieldValue.arrayUnion([{
            //                         "Email" : usermodel["Email"],
            //                         "Stamp" : stamp
            //                       }]),
            //                     }).whenComplete(() async {
            //                       await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
            //                         "${usermodel["Email"].toString().split('@')[0]}_${stamp}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),
            //
            //                       });
            //                     })
            //                         :
            //                     await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
            //                       "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Delevered" : FieldValue.arrayUnion([{
            //                         "Email" : usermodel["Email"],
            //                         "Stamp" : stamp
            //                       }]),
            //                       "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Seen" : FieldValue.arrayUnion([{
            //                         "Email" : usermodel["Email"],
            //                         "Stamp" : stamp
            //                       }]),
            //                     }).whenComplete(() async {
            //                       await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
            //                         "${usermodel["Email"].toString().split('@')[0]}_${stamp.toString().split(".")[0]}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),
            //
            //                       });
            //                     })
            //                         :
            //                     null;
            //                     messageController.text.trim() ==
            //                         ""
            //                         ? null
            //                         : await FirebaseFirestore
            //                         .instance
            //                         .collection("Messages")
            //                         .doc(widget.channel)
            //                         .update(
            //                       {
            //                         "Messages": FieldValue
            //                             .arrayUnion([
            //                           {
            //                             "Name": usermodel[
            //                             "Name"]
            //                                 .toString(),
            //                             "UID": usermodel[
            //                             "Email"]
            //                                 .toString(),
            //                             "text":
            //                             messageController
            //                                 .text
            //                                 .trim()
            //                                 .toString(),
            //                             "Stamp": stamp,
            //                             "Reply":
            //                             replyBoxHeight !=
            //                                 0
            //                                 ? true
            //                                 : false,
            //                             "Reply_Index":
            //                             message.length -
            //                                 replyIndex -
            //                                 1,
            //                           }
            //                         ]),
            //
            //                       },
            //                     ).whenComplete(
            //                           () async {
            //                         setState(() {
            //                           replyBoxHeight = 0;
            //                           replyIndex = 0;
            //                         });
            //                         scrollController.scrollTo(
            //                             index: 0,
            //                             duration:
            //                             const Duration(
            //                                 milliseconds:
            //                                 200));
            //                         List<dynamic> members = snapshot.data!.data()!["Members"];
            //                         for (var member in members) {
            //                           print("Sending to element");
            //                           try {
            //                             Map<String,dynamic> user =  snapshot.data!.data()?[member["Email"].toString().split("@")[0]];
            //                             print("............member $user");
            //                             List<dynamic> tokens =  user["Token"];
            //                             print("............error1");
            //                             if(member["Email"]!= usermodel["Email"] && !snapshot.data!.data()?[member["Email"].toString().split("@")[0]]["Active"] && snapshot.data!.data()?[member["Email"].toString().split("@")[0]]["Mute Notification"] != false){
            //                               for (var token in tokens) {
            //                                 print("${member["Email"]}");
            //
            //                                 database().sendPushMessage(
            //                                     token,
            //                                     messageController
            //                                         .text
            //                                         .trim()
            //                                         .toString(),
            //                                     widget
            //                                         .channel,
            //                                     true,
            //                                     widget
            //                                         .channel,
            //                                     stamp);
            //
            //                               }
            //                             }
            //                           } catch (e) {
            //                             print(e);
            //                           }
            //                         }
            //
            //
            //                         setState(() {
            //                           messageController
            //                               .clear();
            //                         });
            //
            //
            //
            //                       },
            //                     );
            //                   },
            //                   child: CircleAvatar(
            //                     backgroundColor: Colors.white,
            //                     radius: size.height * 0.028,
            //                     child: Icon(
            //                       Icons.send,
            //                       size: size.height * 0.03,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //           :
            //       const loading(text: "Please wait Loading chat from the server");
            //     }),
          )
              :
          const loading(text: "Please wait Loading chat from the server");
        });
  }

  // Widget bubble(
  //     String UID,
  //     ItemScrollController controller,
  //     String text,
  //     String name,
  //     String image,
  //     DateTime stamp,
  //     bool sender,
  //     Size size,
  //     int index,
  //     int length,
  //     bool reply,
  //     String replyToName,
  //     String replyToText,
  //     int scrollindex,
  //     bool imageMsg,
  //     String imageURL,
  //     String compressedURL,
  //     bool videoMsg,
  //     String videoURL,
  //     String videoThumbnailURL,
  //     bool isDelevered,
  //     bool isSeen,
  //     bool pdf,
  //     String pdfImageURL,
  //     String pdfUrl,
  //     String pdfName,
  //     int pdfSize,
  //     AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot
  //     ) {
  //   return Align(
  //     alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment:
  //       sender ? MainAxisAlignment.end : MainAxisAlignment.start,
  //       children: [
  //         sender
  //             ?
  //         Container(
  //           decoration: BoxDecoration(
  //               borderRadius: const BorderRadius.all(Radius.circular(15)),
  //               gradient: LinearGradient(colors: [
  //                 Colors.black.withOpacity(0.9),
  //                 Colors.black.withOpacity(0.6)
  //               ])),
  //           padding: EdgeInsets.fromLTRB(
  //               size.width * 0.03,
  //               size.height * 0.01,
  //               size.width * 0.03,
  //               size.height * 0.01),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               AutoSizeText(
  //                 "${stamp.hour}:${stamp.minute < 10 ? "0" : ""}${stamp.minute} ${stamp.hour < 12 ? "am" : "pm"}",
  //                 style: GoogleFonts.poppins(
  //                     color: Colors.white70.withOpacity(0.8),
  //                     fontSize: size.width * 0.022,
  //                     fontWeight: FontWeight.w700),
  //                 textAlign: TextAlign.right,
  //               ),
  //               const SizedBox(
  //                 width: 5,
  //               ),
  //               isSeen
  //                   ? Icon(
  //                 Icons.done_all_outlined,
  //                 color: isSeen
  //                     ? Colors.green
  //                     : Colors.white.withOpacity(0.8),
  //                 size: size.width * 0.04,
  //               )
  //                   : isDelevered
  //                   ? Icon(
  //                 Icons.done_all_outlined,
  //                 color: isSeen
  //                     ? Colors.white
  //                     : Colors.white.withOpacity(0.8),
  //                 size: size.width * 0.04,
  //               )
  //                   : Icon(
  //                 Icons.check,
  //                 color: isSeen
  //                     ? Colors.white
  //                     : Colors.white.withOpacity(0.8),
  //                 size: size.width * 0.04,
  //               )
  //             ],
  //           ),
  //         )
  //             :
  //         SizedBox(
  //           width: size.width * 0.02,
  //         ),
  //
  //         MsgTile(
  //           email: UID,
  //           comressedURL: compressedURL,
  //           image: image,
  //           name: name,
  //           channel: widget.channel,
  //           replyIndex: replyIndex,
  //           imageMsg: imageMsg,
  //           imageURL: imageURL,
  //           reply: reply,
  //           replyToName: replyToName,
  //           ReplyToText: replyToText,
  //           scrollController: controller,
  //           scrollindex: scrollindex,
  //           sender: sender,
  //           stamp: stamp,
  //           text: text,
  //           videoMsg: videoMsg,
  //           videoThumbnailURL: videoThumbnailURL,
  //           videoURL: videoURL,
  //           pdfMsg : pdf,
  //             pdfImageUrl : pdfImageURL,
  //             pdfUrl : pdfUrl,
  //           pdfName : pdfName,
  //           pdfSize: pdfSize,
  //           snapshot: snapshot,
  //         ),
  //
  //         !sender
  //             ?
  //         Container(
  //           decoration: BoxDecoration(
  //               borderRadius: const BorderRadius.all(Radius.circular(15)),
  //               gradient: LinearGradient(colors: [
  //                 Colors.black.withOpacity(0.9),
  //                 Colors.black.withOpacity(0.6)
  //               ])),
  //           padding: EdgeInsets.fromLTRB(
  //               size.width * 0.03,
  //               size.height * 0.01,
  //               size.width * 0.03,
  //               size.height * 0.01),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               AutoSizeText(
  //                 "${stamp.hour}:${stamp.minute < 10 ? "0" : ""}${stamp.minute} ${stamp.hour < 12 ? "am" : "pm"}",
  //                 style: GoogleFonts.poppins(
  //                     color: Colors.white70.withOpacity(0.8),
  //                     fontSize: size.width * 0.022,
  //                     fontWeight: FontWeight.w700),
  //                 textAlign: TextAlign.right,
  //               ),
  //             ],
  //           ),
  //         )
  //             :
  //         SizedBox(width: size.width * 0.02,),
  //       ],
  //     ),
  //   );
  // }

  Widget date(DateTime date) {
    return DateChip(
      date: date,
      color: Colors.white,
    );
  }

  countUpdate(int length) async {
    await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
      "${usermodel["Email"].toString().split("@")[0]}.Read_Count" : length
    });
  }

  int activeStatus(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    int count = 0;
    List<dynamic> memberList = snapshot.data?.data()!["Members"] ?? [];

    for (Map<String, dynamic> email in memberList) {
      print(email);
      if (snapshot.data?.data()![email["Email"].toString().split("@")[0]]
      ["Active"] !=
          null &&
          snapshot.data?.data()![email["Email"].toString().split("@")[0]]
          ["Active"]) {
        count++;
      }
    }
    return count;
  }


  develered(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) async {
    print(" ..............here");
    int lastcount = snapshot.data!.data()?[usermodel["Email"].toString().split("@")[0]]["Read_Count"];
    int len = snapshot.data!.data()?["Messages"].length;

    if (lastcount != len) {
      print("..................if");
      await FirebaseFirestore.instance
          .collection("Messages")
          .doc(widget.channel)
          .update({
        usermodel["Email"].toString().split("@")[0]: {
          "Active": true,
          "Read_Count": len,
          "Last_Active": DateTime.now(),
          "Token" : FieldValue.arrayUnion([usermodel["Token"]])
        }
      });
      for(int i=len;i>lastcount;i--){
        String? stamp= snapshot.data!.data()?["Messages"][i-1]["Stamp"].toDate().toString().split(".")[0];
        String? email= snapshot.data!.data()?["Messages"][i-1]["UID"];

        if(email != usermodel["Email"]){
          final doc= await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").get();
          List<dynamic> list= doc.data()?["${email.toString().split('@')[0]}_${stamp.toString().split(".")[0]}_Seened"];
          if(!list.contains("${usermodel["Email"]}")){
            await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
              "${email.toString().split('@')[0]}_${stamp.toString().split(".")[0]}_Seen": FieldValue.arrayUnion([
                {
                  "Email": usermodel["Email"],
                  "Stamp": DateTime.now(),
                  "From" : "delevered"
                }
              ]),

            });
            await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
              "${email.toString().split('@')[0]}_${stamp}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),

            });
          }

        }
      }
    }
    else{
      print("..................else");
      await FirebaseFirestore.instance
          .collection("Messages")
          .doc(widget.channel)
          .update({
        "${usermodel["Email"].toString().split("@")[0]}.Active": true
      });
    }
  }

  Future<void> onSendTap(String message, ReplyMessage replyMessage,MessageType messageType) async {
    print("..........onsendtap reply : ${replyMessage.messageId}  ....Type: $messageType");
    // chatController.addMessage(message1);
    DateTime stamp = DateTime.now();
                        //int l=message.length+1;
    final channelDoc= await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).get();
    final doc=await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").get();

    !doc.exists
        ?
    await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").set({
                          "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Delevered" : FieldValue.arrayUnion([{
                            "Email" : usermodel["Email"],
                            "Stamp" : stamp
                          }]),
                          "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Seen" : FieldValue.arrayUnion([{
                            "Email" : usermodel["Email"],
                            "Stamp" : stamp
                          }]),
                        }).whenComplete(() async {
                          await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
                            "${usermodel["Email"].toString().split('@')[0]}_${stamp}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),

                          });
                        })
        :
    await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
                          "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Delevered" : FieldValue.arrayUnion([{
                            "Email" : usermodel["Email"],
                            "Stamp" : stamp
                          }]),
                          "${usermodel["Email"].toString().split("@")[0]}_${stamp.toString().split(".")[0]}_Seen" : FieldValue.arrayUnion([{
                            "Email" : usermodel["Email"],
                            "Stamp" : stamp
                          }]),
                        }).whenComplete(() async {
                          await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).collection("Messages_Detail").doc("Messages_Detail").update({
                            "${usermodel["Email"].toString().split('@')[0]}_${stamp.toString().split(".")[0]}_Seened": FieldValue.arrayUnion([usermodel["Email"]]),

                          });
                        });
    await FirebaseFirestore
        .instance
        .collection("Messages")
        .doc(widget.channel)
        .update(
      {
        "Messages": FieldValue
            .arrayUnion([
              {
                "Name": usermodel["Name"].toString(),
                "UID": usermodel["Email"].toString(),
                "text": message,
                "Stamp": stamp,
                "ReplyMessage" : replyMessage.message,
                "ReplyMessageId" : replyMessage.messageId,
                "ReplyMessageType" : replyMessage.messageType.name,
                "ReplyTo" : replyMessage.replyTo,
                "ReplyBy" : replyMessage.replyBy,
                "ReplyVoiceDuration" : replyMessage.voiceMessageDuration,
              }
              ]),
      },
    ).whenComplete(() async {
            List<dynamic> members = channelDoc.data()!["Members"];
            for (var member in members) {
              print("Sending to element");
              try {
                Map<String,dynamic> user =  channelDoc.data()?[member["Email"].toString().split("@")[0]];
                print("............member $user");
                List<dynamic> tokens =  user["Token"];
                print("............error1");
                if(member["Email"]!= usermodel["Email"] && !channelDoc.data()?[member["Email"].toString().split("@")[0]]["Active"] && channelDoc.data()?[member["Email"].toString().split("@")[0]]["Mute Notification"] != false){
                  for (var token in tokens) {
                    print("${member["Email"]}");
                    database().sendPushMessage(
                        token,
                        message,
                        widget.channel,
                        true,
                        widget.channel,
                        stamp);

                  }
                }
              } catch (e) {
                print(e);
              }
            }
            },
    );
  }
}
