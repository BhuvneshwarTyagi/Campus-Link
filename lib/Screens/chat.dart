

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:campus_link_teachers/Screens/Sending_Image.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swipe_to/swipe_to.dart';
import 'chat_info.dart';

class chat_page extends StatefulWidget {
  const chat_page({Key? key, required this.channel}) : super(key: key);
  final String channel;
  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  TextEditingController messageController = TextEditingController();
  final ItemScrollController scrollController = ItemScrollController();

  List<int> tick = [];
  bool selected = false;
  int index1 = -1;
  int replyIndex = 0;
  double replyBoxHeight = 0;
  var imagePath;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .doc(widget.channel)
            .snapshots(),
        builder: (context, snapshot) {
          List<dynamic> message = snapshot.data?.data()!["Messages"] == null
              ? []
              : snapshot.data?.data()!["Messages"].reversed.toList();
          int activeCount = activeStatus(snapshot);
          return snapshot.hasData
              ? WillPopScope(
                  onWillPop: () async {
                    await FirebaseFirestore.instance
                        .collection("Messages")
                        .doc(widget.channel)
                        .update({
                      usermodel["Email"].toString().split("@")[0]: {
                        "Last_Active": DateTime.now(),
                        "Read_Count": message.length - 1,
                        "Active": false,
                      }
                    });
                    return true;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/${usermodel["bg"]}"),
                            fit: BoxFit.fill)),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: !selected
                          ? AppBar(
                              elevation: 0,
                              backgroundColor: Colors.black54,
                              leadingWidth: size.width * 0.09,
                              leading: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("Messages")
                                        .doc(widget.channel)
                                        .update({
                                      usermodel["Email"]
                                          .toString()
                                          .split("@")[0]: {
                                        "Last_Active": DateTime.now(),
                                        "Read_Count": message.length - 1,
                                        "Active": false,
                                      }
                                    }).whenComplete(() => Navigator.pop(context));
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_new)),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: size.height * 0.03,
                                    backgroundColor: Colors.white70,
                                    backgroundImage: NetworkImage(
                                        snapshot.data?.data()!["image_URL"]),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.01,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            childCurrent: chat_page(
                                                channel: widget.channel),
                                            child: Chat_Info(
                                              channel: widget.channel,
                                              membersCount: snapshot.data!
                                                  .data()!["Members"]
                                                  .length,
                                              url: snapshot.data
                                                  ?.data()!["image_URL"],
                                            ),
                                            type: PageTransitionType
                                                .rightToLeftJoined,
                                            duration: const Duration(
                                                milliseconds: 300)),
                                      );
                                    },
                                    child: SizedBox(
                                      width: size.width * 0.55,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            widget.channel,
                                            style: GoogleFonts.exo(
                                                color: Colors.white,
                                                fontSize: size.width * 0.045),
                                            maxLines: 1,
                                            minFontSize: 1,
                                          ),
                                          AutoSizeText(
                                            "$activeCount Online",
                                            style: GoogleFonts.exo(
                                                color: Colors.green,
                                                fontSize: size.width * 0.028),
                                            minFontSize: 1,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: size.height * 0.04,
                                  ),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Search",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))),
                                      PopupMenuItem(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Wallpaper",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))),
                                      PopupMenuItem(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Setting",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))),
                                      PopupMenuItem(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "More",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))),
                                    ];
                                  },
                                )
                              ],
                            )
                          : AppBar(
                              elevation: 0,
                              backgroundColor: Colors.black54,
                              leadingWidth: size.width * 0.09,
                              leading: IconButton(
                                onPressed: () {
                                  setState(() {
                                    selected = !selected;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_ios_new),
                              ),
                              actions: [
                                IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("Messages")
                                          .doc(widget.channel)
                                          .update({
                                        "Messages": FieldValue.arrayRemove(
                                            [message[index1]])
                                      });
                                      setState(() {
                                        index1 = -1;
                                        selected = !selected;
                                      });
                                    },
                                    icon: const Icon(Icons.delete_outline))
                              ],
                            ),
                      body: SizedBox(
                        height: size.height,
                        //color: Colors.black26,
                        child: message.isNotEmpty
                            ?
                        ScrollablePositionedList.builder(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                          itemScrollController: scrollController,
                                itemCount: message.length,
                                itemBuilder: (context, index) {
                                  bool read = updateReadedCount(snapshot, index);
                                  bool Reply = false;
                                  message[index]["Reply"] == null
                                      ? Reply = false
                                      : Reply = message[index]["Reply"];
                                  bool Image = false;
                                  message[index]["Image_Text"] == null
                                      ? Image = false
                                      : Image = message[index]["Image_Text"];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      index != message.length - 1
                                          ? message[index + 1]["Stamp"]
                                                      .toDate()
                                                      .day ==
                                                  message[index]["Stamp"]
                                                      .toDate()
                                                      .day
                                              ? const SizedBox()
                                              : date(message[index]["Stamp"]
                                                  .toDate())
                                          : date(
                                              message[index]["Stamp"].toDate()),
                                      message[index]["UID"] ==
                                              usermodel["Email"]
                                          ? SwipeTo(
                                              onLeftSwipe: () {
                                                setState(() {
                                                  replyBoxHeight =
                                                      size.height * 0.17;
                                                  replyIndex = index;
                                                });
                                              },
                                              child: InkWell(
                                                onLongPress: () async {
                                                  setState(() {
                                                    index1 = index;
                                                    selected = !selected;
                                                  });
                                                },
                                                child: bubble(
                                                  scrollController,
                                                    "${message[index]["text"]}",
                                                    "${message[index]["Name"]}",
                                                    "${message[index]["Image"]}",
                                                    message[index]["Stamp"]
                                                        .toDate(),
                                                    true,
                                                    size,
                                                    index,
                                                    message.length,
                                                    Reply,
                                                    Reply
                                                        ? message[int.parse(
                                                                "${message.length - message[index]["Reply_Index"] - 1}")]
                                                            ["Name"]
                                                        : "",
                                                    Reply
                                                        ? message[int.parse(
                                                                "${message.length - message[index]["Reply_Index"] - 1}")]
                                                            ["text"]
                                                        : "",
                                                    read,
                                                    Reply
                                                        ?
                                                    int.parse("${message.length - message[index]["Reply_Index"] - 1}")
                                                        :
                                                    0,
                                                    Image,
                                                    Image? message[index]["Image_Url"]:""
                                                ),
                                              ),
                                            )
                                          : SwipeTo(
                                              onRightSwipe: () {
                                                setState(() {
                                                  replyBoxHeight =
                                                      size.height * 0.17;
                                                  replyIndex = index;
                                                });
                                              },
                                              child: bubble(
                                                  scrollController,
                                                  "${message[index]["text"]}",
                                                  "${message[index]["Name"]}",
                                                  "${message[index]["Image"]}",
                                                  message[index]["Stamp"]
                                                      .toDate(),
                                                  false,
                                                  size,
                                                  index,
                                                  message.length,
                                                  Reply,
                                                  Reply
                                                      ? message[int.parse(
                                                              "${message.length - message[index]["Reply_Index"] - 1}")]
                                                          ["Name"]
                                                      : "",
                                                  Reply
                                                      ? message[int.parse(
                                                              "${message.length - message[index]["Reply_Index"] - 1}")]
                                                          ["text"]
                                                      : "",
                                                  false,
                                  Reply
                                      ?
                                  int.parse("${message.length - message[index]["Reply_Index"] - 1}")
                                      :
                                  0,
                                                  Image,
                                                Image? message[index]["Image_Url"]:""
                                            ),
                                      )
                                    ],
                                  );
                                },
                              )
                            : const SizedBox(),
                      ),
                      bottomNavigationBar: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          width: size.width,
                          //color: Colors.black26,
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,vertical: size.height*0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    ImagePicker imagePicker=ImagePicker();
                                    print(imagePicker);
                                    XFile? file=await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                    file!.path.isNotEmpty
                                        ?
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SendImage(imagePath: file,channel: widget.channel),))
                                        :
                                        null;
                                  },
                                  icon: Icon(Icons.image,color: Colors.white,size: size.height*0.04,)),
                              Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AnimatedContainer(
                                      height: replyBoxHeight,
                                      width: size.width * 0.66,
                                      decoration: const BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      duration: const Duration(milliseconds: 100),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            width: size.width * 0.8,
                                            margin: EdgeInsets.only(
                                              bottom: size.height * 0.07,
                                              top: size.height * 0.01,
                                              right: size.height * 0.01,
                                              left: size.height * 0.01,
                                            ),
                                            padding: EdgeInsets.all(
                                                size.height * 0.008),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  message[replyIndex]["Name"],
                                                  style: GoogleFonts.exo(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  message[replyIndex]["text"]
                                                      .toString()
                                                      .substring(
                                                          0,
                                                          message[replyIndex][
                                                                          "text"]
                                                                      .length <
                                                                  120
                                                              ? message[replyIndex]
                                                                      ["text"]
                                                                  .length
                                                              : 120),
                                                  style: GoogleFonts.exo(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  replyBoxHeight = 0;
                                                  replyIndex = 0;
                                                });
                                              },
                                              icon: const Icon(Icons.clear))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.062,
                                      width: size.width * 0.66,
                                      child: TextField(
                                        controller: messageController,
                                        enableSuggestions: true,
                                        onTapOutside: (event) async {
                                          await FirebaseFirestore.instance
                                              .collection("Messages")
                                              .doc(widget.channel)
                                              .update({
                                            usermodel["Email"]
                                                .toString()
                                                .split("@")[0]: {
                                              "Last_Active": DateTime.now(),
                                              "Read_Count": message.length - 1,
                                              "Active": true,
                                            }
                                          });
                                        },
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
                                  ]),
                              TextButton(
                                onPressed: () async {
                                  messageController.text.trim() == ""
                                      ? null
                                      : await FirebaseFirestore.instance
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
                                                "Reply": replyBoxHeight != 0
                                                    ? true
                                                    : false,
                                                "Reply_Index": message.length -
                                                    replyIndex -
                                                    1,
                                              }
                                            ])
                                          },
                                        ).whenComplete(
                                          () async {
                                            setState(() {
                                              replyBoxHeight = 0;
                                              replyIndex = 0;
                                            });
                                            scrollController.scrollTo(index: 0, duration: Duration(milliseconds: 200));
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
                                                      messageController.text.trim().toString(),
                                                      widget.channel,
                                                      )
                                                  : null;
                                            }
                                            setState(() {
                                              messageController.clear();
                                            });
                                          },
                                        );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: size.height * 0.025,
                                  child: Icon(
                                    Icons.send,
                                    size: size.height * 0.03,
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
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }



  Widget bubble(
      ItemScrollController controller,
      String text,
      String name,
      String image,
      DateTime stamp,
      bool sender,
      Size size,
      int index,
      int length,
      bool reply,
      String replyToName,
      String ReplyToText,
      bool readed,
      int scrollindex,
      bool imageMsg,
      String imageURL
      ) {
    return Align(
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            sender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          sender
              ? const SizedBox()
              : Row(
                  children: [
                    SizedBox(width: size.width * 0.02),
                    CircleAvatar(
                      radius: size.width * 0.045,
                      backgroundImage:
                          image != "null" ? NetworkImage(image) : null,
                      // backgroundColor: Colors.teal.shade300,
                      child: image == "null"
                          ? AutoSizeText(
                              name.substring(0, 1),
                              style: GoogleFonts.exo(
                                  fontSize: size.height * 0.01,
                                  fontWeight: FontWeight.w600),
                            )
                          : null,
                    ),
                  ],
                ),
          Container(
            width: text.length > 23
                ? size.width * 0.028 * 25
                : name.length >= text.length
                    ? size.width * 0.037 * name.length
                    : size.width * 0.035 * text.length,
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.01, vertical: size.height * 0.01),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: sender
                      ? const Radius.circular(15)
                      : const Radius.circular(15),
                  topLeft: !sender
                      ? const Radius.circular(15)
                      : const Radius.circular(15),
                  bottomLeft: sender
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: !sender
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                )),
            padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.02, vertical: size.height * 0.003),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.008,vertical: size.height*0.002),
                  child: AutoSizeText(
                    name,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                reply
                    ?
              InkWell(
                  onTap: () {
                    print("..........${replyIndex}");
                    scrollController.scrollTo(index: scrollindex, duration: const Duration(seconds: 1));
                  },
                      child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(
                            bottom: size.height * 0.01,
                            top: size.height * 0.01,
                          ),
                          padding: EdgeInsets.all(size.height * 0.008),
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                replyToName,
                                style: GoogleFonts.exo(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              Text(
                                ReplyToText.toString().substring(
                                    0,
                                    ReplyToText.length < 120
                                        ? ReplyToText.length
                                        : 120),
                                style: GoogleFonts.exo(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                    )
                    : const SizedBox(),


                imageMsg ?
                Container(
                  width: double.maxFinite,
                  height: size.height*0.25,
                  margin: EdgeInsets.only(
                    bottom: size.height * 0.01,
                    top: size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(imageURL),fit: BoxFit.fill),
                      color: Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: Colors.black,width: 2)
                  ),
                )
                    :
                const SizedBox(),
                text.isNotEmpty?
                SizedBox(
                  width: size.width * 0.92,
                  child: AutoSizeText(
                    text,
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.75),
                        fontSize: size.width * 0.037,
                        fontWeight: FontWeight.w400),
                  ),
                )
                :
                const SizedBox(),
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
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      sender
                          ? Icon(
                              Icons.check_circle_outline,
                              color: readed
                                  ? Colors.green
                                  : Colors.black.withOpacity(0.8),
                              size: size.width * 0.05,
                            )
                          : const SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ),
          !sender
              ? const SizedBox()
              : Row(
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.045,
                      backgroundImage:
                          image != "null" ? NetworkImage(image) : null,
                      // backgroundColor: Colors.teal.shade300,
                      child: image == "null"
                          ? AutoSizeText(
                              name.substring(0, 1),
                              style: GoogleFonts.exo(
                                  fontSize: size.height * 0.01,
                                  fontWeight: FontWeight.w600),
                            )
                          : null,
                    ),
                    SizedBox(width: size.width * 0.02),
                  ],
                ),
        ],
      ),
    );
  }

  Widget date(DateTime date) {
    return DateChip(
      date: date,
      color: Colors.white,
    );
  }

  Future<void> readTick() async {
    await FirebaseFirestore.instance
        .collection("Messages")
        .doc(widget.channel)
        .get()
        .then((value) {
      value.data()!["Members"].forEach((email) async {
        await FirebaseFirestore.instance
            .collection("Messages")
            .doc(widget.channel)
            .get()
            .then((value2) {
          tick.add(
              value2.data()![email.toString().split("@")[0]]["Readed_count"]);
        });
      });
    }).whenComplete(() => setState(() {}));
  }

  bool updateReadedCount(
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      int messageIndex) {
    bool out = true;
    List<dynamic> member_list = snapshot.data?.data()!["Members"];
    DateTime msg_stamp = snapshot.data!
        .data()!["Messages"]
            [snapshot.data!.data()!["Messages"].length - messageIndex - 1]
            ["Stamp"]
        .toDate();
    for (var email in member_list) {
      DateTime user_stamp = snapshot.data!
          .data()![email["Email"].toString().split("@")[0]]["Last_Active"]
          .toDate();
      print(user_stamp.hour);
      print(msg_stamp.hour);
      if (msg_stamp.year >= user_stamp.year &&
          msg_stamp.month >= user_stamp.month &&
          msg_stamp.day >= user_stamp.day &&
          msg_stamp.hour >= user_stamp.hour &&
          msg_stamp.minute > user_stamp.minute) {
        print(email);
        out = false;
        break;
      } else {
        if (msg_stamp.day > user_stamp.day) {
          out = false;
          break;
        } else {
          out = true;
        }
        //break;
      }
    }

    return out;
  }

  int activeStatus(
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    int count = 0;
    List<dynamic> member_list = snapshot.data?.data()!["Members"];
    for (var email in member_list) {
      if (snapshot.data!.data()![email["Email"].toString().split("@")[0]]
                  ["Active"] !=
              null &&
          snapshot.data!.data()![email["Email"].toString().split("@")[0]]
              ["Active"]) {
        count++;
      }
    }
    return count;
  }
}
