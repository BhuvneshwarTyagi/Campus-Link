import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../Constraints.dart';
import '../Database/database.dart';

class SendImage extends StatefulWidget {
  const SendImage({super.key, required this.imagePath, required this.channel, required this.messageLength, required this.replyBoxHeight, required this.replyToName, required this.replyToText, required this.replyIndex, required this.video});
  final XFile imagePath;
  final String channel;
  final int messageLength;
  final double replyBoxHeight;
  final String replyToName;
  final String replyToText;
  final int replyIndex;
  final bool video;
  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  TextEditingController messageController = TextEditingController();
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController=  VideoPlayerController.file(File(widget.imagePath.path),);
    videoPlayerController.initialize().then((value){setState(() {
      print("Initialized");
    });});
    videoPlayerController.setLooping(true);
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return widget.video ?
    Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          color: Colors.black,
          height: 500,
          width: 500,
          child: videoPlayerController.value.isInitialized
              ?
              AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoPlayerController),
              )
              :
          Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      appBar: AppBar(
        actions: [
          IconButton(

            onPressed: () {
              setState(() {

                if(videoPlayerController.value.duration == videoPlayerController.value.position){
                  videoPlayerController.initialize();
                }
                videoPlayerController.value.isPlaying
                    ? videoPlayerController.pause()
                    : videoPlayerController.play();
              });
            },
            icon: Icon(
              videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03,vertical: size.height*0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      height: widget.replyBoxHeight,
                      width: size.width * 0.78,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(12),
                          topLeft:Radius.circular(12),
                          bottomRight:Radius.circular(30),
                          bottomLeft:Radius.circular(30),

                        ),
                      ),
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
                                  widget.replyToName,
                                  style: GoogleFonts.exo(
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 14),
                                ),
                                Text(
                                  widget.replyToText,
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

                                });
                              },
                              icon: const Icon(Icons.clear))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.062,
                      width: size.width * 0.78,
                      child: TextField(
                        controller: messageController,
                        enableSuggestions: true,
                        maxLines: 5,
                        minLines: 1,
                        autocorrect: true,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                // ImagePicker imagePicker=ImagePicker();
                                // print(imagePicker);
                                // XFile? file=await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                              },
                              icon: Icon(Icons.image,color: Colors.black,size: size.height*0.04,)),
                          suffixIconColor: Colors.black,
                          fillColor: Colors.white70,
                          filled: true,
                          hintText: "Message",
                          hintStyle: GoogleFonts.exo(
                            color: Colors.black54,
                            fontSize: 19, //height:size.height*0.0034
                          ),
                          contentPadding: EdgeInsets.only(
                              left: size.width * 0),
                          enabledBorder:
                          const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      30.0)),
                              borderSide: BorderSide(
                                  color: Colors.black54,
                                  width: 1)),
                          focusedBorder:
                          const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(
                                      30.0)),
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
                  Reference reference=FirebaseStorage.instance.ref();

                  // Create Directory into Firebase Storage

                  Reference image_directory=reference.child("Message_Images");


                  Reference image_folder=image_directory.child(widget.channel);

                  Reference channel=image_folder.child("${DateTime.now()}");


                  TaskSnapshot snap= await channel.putFile(File(widget.imagePath.path));
                  String URL=await snap.ref.getDownloadURL();
                  String path = await VideoThumbnail.thumbnailFile(video: URL,imageFormat: ImageFormat.PNG,quality: 75,maxHeight: 400,maxWidth: 400,thumbnailPath: (await getApplicationCacheDirectory()).path) ?? "";
                  reference=FirebaseStorage.instance.ref();

                  // Create Directory into Firebase Storage

                  image_directory=reference.child("Message_Images");


                  image_folder=image_directory.child("${usermodel[widget.channel]}");

                  channel=image_directory.child("${DateTime.now()}");

                  snap= await channel.putFile(File(path));
                  String thumbURL=await snap.ref.getDownloadURL();
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
                          "Reply": widget.replyBoxHeight != 0
                              ? true
                              : false,
                          "Reply_Index": widget.messageLength -
                              widget.replyIndex -
                              1,
                          "Image_Text": false,
                          "Image_Url" : "",
                          "Video_Text" : true,
                          "Video_Url" :URL,
                          "Video_ThumbNail": thumbURL
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
    )
        :
    Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(image: FileImage(File(widget.imagePath.path)),fit: BoxFit.contain)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: CircleAvatar(
          radius: size.width*0.05,
          backgroundColor: Colors.black.withOpacity(0.5),
          child: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: const Icon(Icons.clear),
          ),
        ),
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

                Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        height: widget.replyBoxHeight,
                        width: size.width * 0.78,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.only(
                            topRight:Radius.circular(12),
                            topLeft:Radius.circular(12),
                            bottomRight:Radius.circular(30),
                            bottomLeft:Radius.circular(30),

                          ),
                        ),
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
                                    widget.replyToName,
                                    style: GoogleFonts.exo(
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    widget.replyToText,
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

                                  });
                                },
                                icon: const Icon(Icons.clear))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.062,
                        width: size.width * 0.78,
                        child: TextField(
                          controller: messageController,
                          enableSuggestions: true,
                          maxLines: 5,
                          minLines: 1,
                          autocorrect: true,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  // ImagePicker imagePicker=ImagePicker();
                                  // print(imagePicker);
                                  // XFile? file=await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                },
                                icon: Icon(Icons.image,color: Colors.black,size: size.height*0.04,)),
                            suffixIconColor: Colors.black,
                            fillColor: Colors.white70,
                            filled: true,
                            hintText: "Message",
                            hintStyle: GoogleFonts.exo(
                              color: Colors.black54,
                              fontSize: 19, //height:size.height*0.0034
                            ),
                            contentPadding: EdgeInsets.only(
                                left: size.width * 0),
                            enabledBorder:
                            const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        30.0)),
                                borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 1)),
                            focusedBorder:
                            const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(
                                        30.0)),
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
                    Reference reference=FirebaseStorage.instance.ref();

                    // Create Directory into Firebase Storage

                    Reference image_directory=reference.child("Message_Images");


                    Reference image_folder=image_directory.child("${usermodel[widget.channel]}");

                    Reference channel=image_folder.child("${DateTime.now()}");


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
                            "Reply": widget.replyBoxHeight != 0
                                ? true
                                : false,
                            "Reply_Index": widget.messageLength -
                                widget.replyIndex -
                                1,
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
    );
  }
}
