import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import '../../Database/database.dart';
import '../Screens/loadingscreen.dart';

class Discussion extends StatefulWidget {
  const Discussion({Key? key, required this.channel}) : super(key: key);
  final String channel;
  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  final chatController = ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    chatUsers: [],
  );
  final currentUser = ChatUser(
    id: '${usermodel["Email"]}',
    name: '${usermodel["Name"]}',
    profilePhoto: usermodel["Profile_URL"] ?? ""
  );
  bool loadChat=true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Discussion")
                .doc(widget.channel)
                .snapshots(),
            builder: (context, snapshot) {


              if(snapshot.hasData){
                if(!loadChat && snapshot.data!.data()!["Messages"].length != snapshot.data!.data()![usermodel["Email"].toString().split("@")[0]]["Count"]){
                  print("..........inside");
                  chatController.chatUsers.clear();
                  for (var member in snapshot.data!.data()!["Members"]) {
                    chatController.chatUsers.add(
                      ChatUser(
                        id: '$member',
                        name: snapshot.data!.data()![ member.toString().split("@")[0]]['Name'],
                        profilePhoto: snapshot.data!.data()![member.toString().split("@")[0]]["Profile_URL"] ?? "",
                      ),
                    );

                  }
                  int start = snapshot.data?.data()![usermodel["Email"].toString().split("@")[0]]["Count"];
                  for (int i=start; i< snapshot.data!.data()!["Messages"].length ; i++) {
                    var msg = snapshot.data!.data()!["Messages"][i];


                    final message1 = Message (
                        id: msg['Stamp'].toDate().toString(),
                        message: msg['text'],
                        createdAt: msg['Stamp'].toDate(),
                        sendBy: msg["UID"],
                        reaction: Reaction(reactions: [], reactedUserIds: []),

                        replyMessage: ReplyMessage(
                          message: msg['ReplyMessage'],
                          messageId: msg["ReplyMessageId"],
                          messageType: MessageType.text,
                          replyTo: msg['ReplyTo'],
                          replyBy: msg['ReplyBy'],
                          voiceMessageDuration: msg['ReplyVoiceDuration'],
                        )
                    );
                    chatController.initialMessageList.add(message1);
                  }
                  countUpdate(snapshot.data!.data()!["Messages"].length);
                }

                if(loadChat){
                  for (var member in snapshot.data!.data()!["Members"]) {
                    chatController.chatUsers.add(
                      ChatUser(
                        id: '$member',
                        name: snapshot.data!.data()![ member.toString().split("@")[0]]['Name'] ?? "Unknown",
                        profilePhoto: "",
                      ),
                    );

                  }

                  for (var msg in snapshot.data!.data()!["Messages"]) {

                    final message1 = Message(

                        id: msg['Stamp'].toDate().toString(),
                        message: msg['text'],
                        createdAt: msg['Stamp'].toDate(),
                        sendBy: msg['UID'],
                        messageType: MessageType.text,
                        reaction: Reaction(reactions: [], reactedUserIds: []),
                        replyMessage: ReplyMessage(
                          message: msg['ReplyMessage'],
                          messageId: msg["ReplyMessageId"],
                          messageType: MessageType.text,
                          replyTo: msg['ReplyTo'],
                          replyBy: msg['ReplyBy'],
                          voiceMessageDuration: Duration(seconds: msg['ReplyVoiceDuration'] ?? 0),
                        )
                    );
                    chatController.initialMessageList.add(message1);
                  }

                  loadChat=false;
                }

                if(snapshot.data!.data()!["Messages"].length != snapshot.data!.data()?[usermodel["Email"].toString().split("@")[0]]["Count"]){
                  countUpdate(snapshot.data!.data()!["Messages"].length);
                }

              }

              return snapshot.hasData
                  ?
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                        AssetImage("assets/images/bg-1.jpg"),
                        fit: BoxFit.fill)),
                width: size.width,
                child: ChatView(

                  appBar: AppBar(
                    backgroundColor: Colors.black87,

                    titleSpacing: 0,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(3, 178, 183, 1).withOpacity(0.5),
                          child: Text(widget.channel.substring(0,1),
                            style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: size.width*0.045,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(width: size.width*0.02,),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                widget.channel,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: size.width*0.04,
                                  color: const Color.fromRGBO(3, 178, 183, 1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    elevation: 0,
                    leading: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  chatBackgroundConfig: ChatBackgroundConfiguration(
                      backgroundColor: Colors.black38,
                      messageTimeIconColor: const Color.fromRGBO(3, 178, 183, 1),
                      messageTimeTextStyle: GoogleFonts.tiltNeon(
                        color: const Color.fromRGBO(3, 178, 183, 1),
                      ),
                      defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
                          textStyle: GoogleFonts.tiltNeon(
                            color: const Color.fromRGBO(211, 211, 211, 1),
                            //const Color.fromRGBO(150, 150, 150, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: size.width*0.035,
                          )
                      )
                  ),
                  currentUser: currentUser,
                  chatController: chatController,
                  onSendTap: onSendTap,
                  featureActiveConfig: const FeatureActiveConfig(
                      lastSeenAgoBuilderVisibility: true,
                      enableOtherUserProfileAvatar: true,
                      enablePagination: true,
                      enableSwipeToSeeTime: true,
                      enableCurrentUserProfileAvatar: true,
                      enableDoubleTapToLike: true,
                      receiptsBuilderVisibility: true,
                      enableChatSeparator: true,
                      enableReactionPopup: true,
                      enableReplySnackBar: true,
                      enableTextField: true
                  ),
                  loadingWidget:  const loading(text: "Syncronizing with the server please wait..."),
                  reactionPopupConfig: ReactionPopupConfiguration(
                    backgroundColor: Colors.black54,
                    showGlassMorphismEffect: true,
                    glassMorphismConfig: const GlassMorphismConfiguration(
                      borderColor: Color.fromRGBO(3, 178, 183, 1),
                      backgroundColor: Colors.black54,
                      strokeWidth: 4,
                    ),
                    userReactionCallback: (message, emoji) {
                      // reaction(message,emoji);
                    },
                  ),
                  sendMessageConfig: SendMessageConfiguration(
                      closeIconColor: const Color.fromRGBO(3, 178, 183, 1),
                      imagePickerConfiguration: ImagePickerConfiguration(),
                      imagePickerIconsConfig: const ImagePickerIconsConfiguration(
                        cameraIconColor: Color.fromRGBO(3, 178, 183, 1),
                        galleryIconColor: Color.fromRGBO(3, 178, 183, 1),
                      ),
                      enableGalleryImagePicker: false,
                      enableCameraImagePicker: false,
                      allowRecordingVoice: false,
                      defaultSendButtonColor: const Color.fromRGBO(3, 178, 183, 1),
                      textFieldConfig: TextFieldConfiguration(
                        textStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        contentPadding: EdgeInsets.all(size.width*0.04),

                      )
                  ),
                  chatViewState: ChatViewState.hasMessages,
                  chatBubbleConfig:  ChatBubbleConfiguration(
                    maxWidth: size.width*0.6,
                    receiptsWidgetConfig: const ReceiptsWidgetConfig(
                      showReceiptsIn: ShowReceiptsIn.all,

                    ),
                    outgoingChatBubbleConfig: ChatBubble(
                        senderNameTextStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.04,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),// demonstrates as current user chat bubble
                        margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
                        linkPreviewConfig: LinkPreviewConfiguration(
                          loadingColor: Colors.grey,
                          linkStyle: GoogleFonts.exo(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                          //proxyUrl: "Proxy URL", // Need for web
                          backgroundColor: Color(0xff272336),
                          bodyStyle: TextStyle(color: Colors.white),
                          titleStyle: TextStyle(color: Colors.white),
                        ),
                        color: const Color.fromRGBO(3, 178, 183, 1),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(3),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        textStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.035,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    inComingChatBubbleConfig: ChatBubble(// demonstrates as current user chat bubble
                        margin: EdgeInsets.symmetric(horizontal: size.width*0.02, vertical: size.height*0.005),
                        linkPreviewConfig: LinkPreviewConfiguration(
                          loadingColor: Colors.grey,
                          linkStyle: GoogleFonts.exo(
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                          proxyUrl: "Proxy URL", // Need for web
                          backgroundColor: Color(0xff272336),
                          bodyStyle: TextStyle(color: Colors.white),
                          titleStyle: TextStyle(color: Colors.white),
                        ),
                        color: const Color.fromRGBO(221, 227, 239, 1),
                        senderNameTextStyle: GoogleFonts.aBeeZee(
                            color: const Color.fromRGBO(3, 178, 183, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: size.width*0.03
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(3),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        textStyle: GoogleFonts.aBeeZee(
                          fontSize: size.width*0.035,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  ),
                  // Add this state once data is available.
                  replyPopupConfig: ReplyPopupConfiguration(
                    onUnsendTap: (message) {
                      deleteMSG(message);
                    },
                    topBorderColor: Colors.green,
                    backgroundColor: Colors.transparent,
                    replyPopupBuilder: (message, sendByCurrentUser) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(size.width*0.1)
                            )
                        ),
                        child: Column(
                          children: [
                            snapshot.data!.data()!["Admins"].contains(usermodel["Email"])
                                ?
                            snapshot.data!.data()!["Admins"].contains(message.sendBy)
                                ?
                            snapshot.data!.data()!["Admins"].length>1
                                ?
                            ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                    "Admins" : FieldValue.arrayRemove([message.sendBy])
                                  });
                                },
                                child: Text("Remove ${snapshot.data!.data()![message.sendBy.split("@")[0]]['Name']} from admin"))
                                :
                            const SizedBox()
                                :
                            ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                    "Admins" : FieldValue.arrayUnion([message.sendBy])
                                  });
                                },
                                child: Text("Make ${snapshot.data!.data()![message.sendBy.split("@")[0]]['Name']} admin"))
                                :
                            const SizedBox(),
                            snapshot.data!.data()!["Admins"].contains(usermodel["Email"])
                                ?
                            snapshot.data!.data()![message.sendBy.split("@")[0]]['Muted'] != true
                                ?
                            ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                    "${message.sendBy.split("@")[0]}.Muted" : true
                                  });
                                },
                                child: Text("Mute ${snapshot.data!.data()![message.sendBy.split("@")[0]]['Name']}"))
                                :
                            ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
                                    "${message.sendBy.split("@")[0]}.Muted" : false
                                  });
                                },
                                child: Text("Unmute ${snapshot.data!.data()![message.sendBy.split("@")[0]]['Name']}"))
                                :
                            const SizedBox(),

                            ElevatedButton(
                                onPressed: () async {
                                  if( !(usermodel["Message_channels"].contains("${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}") ||
                                      usermodel["Message_channels"].contains("${message.sendBy.split("@")[0]}_${usermodel["Email"].toString().split("@")[0]}"))){
                                    Map<String,dynamic> map1 = {
                                      "Active": false,
                                      "Read_Count": 0,
                                      "Last_Active" : DateTime.now(),
                                      "Token": FieldValue.arrayUnion([usermodel["Token"]]),
                                      "Profile_URL" : usermodel["Profile_URL"],
                                      "Name" : usermodel["Name"],
                                      "Post" : "Teachers",
                                      "Muted" : false,
                                      "Type" : "Personal"
                                    };
                                    Map<String,dynamic> map2 = {
                                      "Active": false,
                                      "Read_Count": 0,
                                      "Last_Active" : DateTime.now(),
                                      "Token": snapshot.data!.data()![message.sendBy.split("@")[0]]["Token"],
                                      "Profile_URL" : snapshot.data!.data()![message.sendBy.split("@")[0]]["Profile_URL"],
                                      "Name" : snapshot.data!.data()![message.sendBy.split("@")[0]]["Name"],
                                      "Post" : snapshot.data!.data()![message.sendBy.split("@")[0]]["Post"],
                                      "Muted" : false,
                                      "Type" : "Personal"
                                    };
                                    DateTime stamp=DateTime.now();

                                    await FirebaseFirestore.instance.collection("Messages").doc(
                                        "${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}"
                                    ).set({
                                      "Type" : "Personal",
                                      "Messages" : [],
                                      "Admins" : FieldValue.arrayUnion(["${usermodel["Email"]}"]),
                                      "Members" : FieldValue.arrayUnion(["${usermodel["Email"]}",message.sendBy]),
                                      usermodel["Email"].toString().split("@")[0] : map1,
                                      message.sendBy.split("@")[0] : map2,
                                      "CreatedOn": {"Date" : stamp, "Name": usermodel["Name"]}});


                                    await FirebaseFirestore.instance.collection("Chat_Channels").doc("Channels").update({
                                      "Channels": FieldValue.arrayUnion([
                                        "${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}"
                                      ])
                                    });

                                    await FirebaseFirestore.instance.collection("Teachers").doc(usermodel["Email"]).update({
                                      "Message_channels" : FieldValue.arrayUnion([
                                        "${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}"
                                      ])
                                    });

                                    await FirebaseFirestore
                                        .instance
                                        .collection(snapshot.data!.data()![message.sendBy.split("@")[0]]['Post'])
                                        .doc(message.sendBy)
                                        .update(
                                        {
                                          "Message_channels" : FieldValue.arrayUnion(["${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}"
                                          ])
                                        });
                                    await database().fetchuser().whenComplete((){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                          (context) {
                                        return Discussion(channel: "${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}",);
                                      },
                                      ));
                                    });
                                  }
                                  else{
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder:
                                        (context) {
                                      return Discussion(channel: "${usermodel["Email"].toString().split("@")[0]}_${message.sendBy.split("@")[0]}",);
                                    },
                                    ));
                                  }
                                },
                                child: Text("Chat with ${snapshot.data!.data()![message.sendBy.split("@")[0]]['Name']} in private"))

                          ],
                        ),
                      );
                    },
                  ),
                  messageConfig:  MessageConfiguration(
                    messageReactionConfig: MessageReactionConfiguration(
                        backgroundColor: Colors.black54,

                        borderColor: const Color.fromRGBO(3, 178, 183, 1),
                        borderWidth: 1.5,
                        reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
                            backgroundColor: Colors.black87,
                            reactedUserTextStyle: GoogleFonts.tiltNeon(
                              color: Colors.black,
                              //const Color.fromRGBO(150, 150, 150, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: size.width*0.04,
                            ),
                            reactionWidgetDecoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            reactionSize: size.width*0.06
                        ),
                        margin: EdgeInsets.only(top: size.height*0.01,left: size.width*0.04)
                    ),
                  ),
                  repliedMessageConfig: RepliedMessageConfiguration(
                    repliedMsgAutoScrollConfig: const RepliedMsgAutoScrollConfig(
                      enableHighlightRepliedMsg: true,
                      enableScrollToRepliedMsg: true,
                      highlightScrollCurve: accelerateEasing,
                      highlightColor: Colors.green,
                      highlightScrollDuration: Duration(milliseconds: 100),
                    ),
                    textStyle: GoogleFonts.aBeeZee(
                      fontSize: size.width*0.03,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    verticalBarColor: const Color.fromRGBO(3, 178, 183, 1).withOpacity(0.5),
                    backgroundColor: const Color.fromRGBO(3, 178, 183, 1).withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    replyTitleTextStyle: GoogleFonts.aBeeZee(
                      fontSize: size.width*0.032,
                      color: const Color.fromRGBO(3, 178, 183, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  :
              const loading(text: "Please wait Loading chat from the server");
            }),
      ),
    );
  }


  countUpdate(int length) async {
    print("updating count");
    await FirebaseFirestore.instance.collection("Discussion").doc(widget.channel).update({
      "${usermodel["Email"].toString().split("@")[0]}.Count" : length
    });
  }



  deleteMSG(Message msg) async {
    print("deleting msg");
    print(".................<<<<<<${msg.sendBy}");
    try{
      await FirebaseFirestore.instance.collection("Messages").doc(widget.channel).update({
        "Messages" : FieldValue.arrayRemove([{
          "ReplyBy": msg.replyMessage.replyBy,
          "ReplyTo": msg.replyMessage.replyTo,
          "ReplyMessage": msg.replyMessage.message,
          "ReplyMessageId": msg.replyMessage.messageId,
          "ReplyMessageType": msg.replyMessage.messageType.name,
          "ReplyVoiceDuration": msg.replyMessage.voiceMessageDuration,
          "Stamp" : DateTime.parse(msg.id),
          'UID' : msg.sendBy,
          'text' : msg.message


        }])
      });
    }on FirebaseException catch(e){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$e");
    }
    //chatController.initialMessageList.remove(msg);
  }
  Future<void> onSendTap(String message, ReplyMessage replyMessage,MessageType messageType) async {
    await FirebaseFirestore
        .instance
        .collection("Discussion")
        .doc(widget.channel)
        .update(
      {
        "Messages": FieldValue
            .arrayUnion([
          {
            "UID": usermodel["Email"].toString(),
            "text": message,
            "Stamp": DateTime.now(),
            "Type": messageType.name,
            "ReplyMessage" : replyMessage.message,
            "ReplyMessageId" : replyMessage.messageId,
            "ReplyMessageType" : replyMessage.messageType.name,
            "ReplyTo" : replyMessage.replyTo,
            "ReplyBy" : replyMessage.replyBy,
            "ReplyVoiceDuration" : replyMessage.voiceMessageDuration?.inSeconds,
          }
        ]),
      },
    );
  }
}
