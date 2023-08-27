import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTile extends StatelessWidget {
  const TextTile({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.002),
      child: SelectableText(
        text,
        style: GoogleFonts.poppins(
            color: Colors.black.withOpacity(0.75),
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
