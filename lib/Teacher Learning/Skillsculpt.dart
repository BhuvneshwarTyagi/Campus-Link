import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class SkillSculpt extends StatelessWidget {
  const SkillSculpt({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "SkillSculpt",style: GoogleFonts.tiltNeon(
          color: Colors.black,
          fontSize: size.width*0.06,
          fontWeight: FontWeight.w500
        ),
        ),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,),
      ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width*0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: size.width*0.05,
                  backgroundColor: Colors.green,

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText("Professor",style: GoogleFonts.tiltNeon(
                      fontSize: size.width*0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),),
                    SizedBox(
                      width: size.width*0.75,
                      child: const Divider(
                        thickness: 3,
                        height: 5,
                        endIndent: 5,
                        indent: 5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: size.width*0.7,
                      child: AutoSizeText("This designation requires P.hd + 13 years Experience in teaching/research",style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    usermodel["Designation"] == "Professor"
                        ?
                    SizedBox(
                      width: size.width*0.7,
                      child: AutoSizeText("You are here at present",style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade600,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    )
                        :
                    SizedBox(),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width*0.05),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height*0.15,
                    child: const VerticalDivider(
                      width: 3,
                      thickness: 3,
                      color: Colors.black,
                      indent: 4,
                      endIndent: 4,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: size.width*0.05,
                  backgroundColor: Colors.green,

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText("Associate Professor",style: GoogleFonts.tiltNeon(
                      fontSize: size.width*0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),),
                    SizedBox(
                      width: size.width*0.75,
                      child: const Divider(
                        thickness: 3,
                        height: 5,
                        endIndent: 5,
                        indent: 5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: size.width*0.7,
                      child: AutoSizeText("This designation requires P.hd + 5 years Experience in teaching/research",style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    usermodel["Designation"] == "Associate Professor"
                        ?
                    SizedBox(
                      width: size.width*0.7,
                      child: AutoSizeText("You are here at present",style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade600,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    )
                        :
                    SizedBox(),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width*0.05),
              child: SizedBox(
                height: size.height*0.15,
                child: const VerticalDivider(
                  width: 3,
                  thickness: 3,
                  color: Colors.black,
                  indent: 4,
                  endIndent: 4,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: size.width*0.05,
                  backgroundColor: Colors.green,

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText("Assistant Professor",style: GoogleFonts.tiltNeon(
                      fontSize: size.width*0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),),
                    SizedBox(
                      width: size.width*0.75,
                      child: const Divider(
                        thickness: 3,
                        height: 5,
                        endIndent: 5,
                        indent: 5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: size.width*0.7,
                      child: AutoSizeText("This designation requires B.Tech + M.Tech",style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    usermodel["Designation"] == "Assistant Professor"
                        ?
                    SizedBox(
                      width: size.width*0.7,
                      child: AutoSizeText("You are here at present",style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade600,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    )
                    :
                    SizedBox(),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
