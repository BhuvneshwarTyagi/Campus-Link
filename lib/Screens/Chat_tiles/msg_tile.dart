import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Chat_tiles/Image_Tile.dart';
import 'package:campus_link_teachers/Screens/Chat_tiles/Name_Tile.dart';
import 'package:campus_link_teachers/Screens/Chat_tiles/Reply_Tile.dart';
import 'package:campus_link_teachers/Screens/Chat_tiles/Text_Tile.dart';
import 'package:campus_link_teachers/Screens/Chat_tiles/Video_Tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MsgTile extends StatelessWidget {
  const MsgTile(
      {super.key,
      required this.imageMsg,
      required this.reply,
      required this.name,
      required this.text,
      required this.sender,
      required this.scrollindex,
      required this.replyIndex,
      required this.replyToName,
      required this.ReplyToText,
      required this.scrollController,
      required this.channel,
      required this.imageURL,
      required this.videoURL,
      required this.videoThumbnailURL,
      required this.videoMsg,
      required this.readed,
      required this.stamp,
      required this.comressedURL});
  final bool imageMsg;
  final String comressedURL;
  final bool reply;
  final String name;
  final String text;
  final bool sender;
  final int scrollindex;
  final int replyIndex;
  final String replyToName;
  final String ReplyToText;
  final ItemScrollController scrollController;
  final String channel;
  final String imageURL;
  final String videoURL;
  final String videoThumbnailURL;
  final bool videoMsg;
  final bool readed;
  final DateTime stamp;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: (imageMsg || reply)
          ? size.width * 0.55
          : text.length > 23
              ? size.width * 0.028 * 25
              : name.length >= text.length
                  ? size.width * 0.037 * name.length
                  : size.width * 0.035 * text.length,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.01, vertical: size.height * 0.01),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(15),
            topLeft: const Radius.circular(15),
            bottomLeft:
                sender ? const Radius.circular(15) : const Radius.circular(0),
            bottomRight:
                !sender ? const Radius.circular(15) : const Radius.circular(0),
          )),
      padding: EdgeInsets.symmetric(
          horizontal: size.height * 0.005, vertical: size.height * 0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NameTile(name: name),
          reply
              ? ReplyTile(
                  scrollController: scrollController,
                  replyIndex: replyIndex,
                  scrollindex: scrollindex,
                  replyToName: replyToName,
                  ReplyToText: ReplyToText)
              : const SizedBox(),
          imageMsg
              ? ImageTile(
                  channel: channel,
                  imageURL: imageURL,
                  compressedURL: comressedURL,
                  stamp: stamp,
                )
              : const SizedBox(),
          videoMsg
              ? VideoTile(
                  channel: channel,
                  videoURL: videoURL,
                  videoThumbnailURL: videoThumbnailURL,
            stamp: stamp,
          )
              : const SizedBox(),
          text.isNotEmpty ? TextTile(text: text) : const SizedBox(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      Icons.check,
                      color: readed
                          ? Colors.green
                          : Colors.black.withOpacity(0.8),
                      size: size.width * 0.04,
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
