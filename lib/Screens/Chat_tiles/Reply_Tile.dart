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
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
          bottom: size.height * 0.005,
          top: size.height * 0.005,
        ),
        padding: EdgeInsets.all(size.height * 0.01),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius:
            BorderRadius.all(Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Replyed To: $replyToName",
              style: GoogleFonts.exo(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.white),
            ),
            Text(
              ReplyToText.toString().substring(
                  0,
                  ReplyToText.length < 120
                      ? ReplyToText.length
                      : 120),
              style: GoogleFonts.exo(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
