import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({super.key, required this.scrollController, required this.replyIndex, required this.scrollindex, required this.replyToName, required this.ReplyToText});
  final ItemScrollController scrollController;
  final int replyIndex;
  final int scrollindex;
  final String replyToName;
  final String ReplyToText;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        print("..........${replyIndex}");
        scrollController.scrollTo(index: scrollindex, duration: const Duration(seconds: 1));
      },
      child: Column(
        children: [
          SizedBox(height: size.height*0.01,),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(size.height * 0.01),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(85, 184, 205, 1),
                  Color.fromRGBO(199, 84, 205, 1),

                ]),
               // borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  "Replyed To: $replyToName",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black),
                  maxLines: 1,
                ),
                AutoSizeText(
                  ReplyToText.toString().substring(
                      0,
                      ReplyToText.length < 120
                          ? ReplyToText.length
                          : 120),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
