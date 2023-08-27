import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameTile extends StatelessWidget {
  const NameTile({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width*0.015,vertical: size.height*0.002),
      child: AutoSizeText(
        name,
        style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
