import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class AlternativeLink extends StatelessWidget {
  AlternativeLink({super.key, required this.notesIndex});
  final int notesIndex;
  TextEditingController linkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: size.height*0.01,
        ),
        AutoSizeText("Video Link",style: GoogleFonts.tiltNeon(
          color: Colors.black,
          fontSize: size.width*0.07
        ),),
        SizedBox(
          height: size.height*0.01,
        ),
        SizedBox(
          width: size.width*0.9,
            height: size.height*0.08,
            child: TextField(
              cursorColor: Colors.black,
              style: GoogleFonts.tiltNeon(
                  color: Colors.black,
                  fontSize: size.width*0.045
              ),
              controller: linkController,
              decoration: InputDecoration(
                hintText: "Video link",
                hintStyle: GoogleFonts.tiltNeon(
                    color: Colors.grey,
                    fontSize: size.width*0.045
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.black
                    )
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.black
                    )
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.black
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Colors.black
                    )
                ),
              ),
            )),
        SizedBox(
          height: size.height*0.01,
        ),
        Center(
          child: Container(
            height: size.height * 0.06,
            width: size.width * 0.466,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.purpleAccent,
                  ],
                ),
                borderRadius:  BorderRadius.all(Radius.circular(size.width*0.033)),
                border: Border.all(color: Colors.black, width: 2)
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent
              ),
              onPressed: () async {
                if(linkController.text.trim().isNotEmpty){
                  await FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").update({
                    "Notes-${notesIndex}.Additional_Link" : FieldValue.arrayUnion([linkController.text.trim()])
                  }).whenComplete(() => Navigator.pop(context));
                }
              },
              child:  AutoSizeText("Upload",
                style: GoogleFonts.openSans(
                    fontSize: size.height * 0.025, color: Colors.black,
                    fontWeight: FontWeight.w700
                ),

              ),
            ),
          ),
        ),
      ],
    );
  }
}
