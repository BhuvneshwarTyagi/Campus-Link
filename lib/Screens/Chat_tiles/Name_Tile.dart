import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameTile extends StatelessWidget {
  const NameTile({super.key, required this.name, required this.sender});
  final bool sender;
  final String name;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return AutoSizeText(
      sender ? "You" :name,
      style: GoogleFonts.poppins(
          color: sender? Colors.white:Colors.black,
          fontSize: size.width*0.034,
          fontWeight: FontWeight.w600),
    );
  }
}
