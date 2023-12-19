import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Download%20Excel%20sheet/quiz_excel_sheet.dart';
import 'package:campus_link_teachers/Screens/Download%20Excel%20sheet/subject_attendace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class DownloadExcelSheet extends StatefulWidget {
  const DownloadExcelSheet({Key? key,required this.uni, required this.clg, required this.course, required this.branch, required this.year, required this.section, required this.subject}) : super(key: key);
  final String uni;
  final String clg;
  final String course;
  final String branch;
  final String year;
  final String section;
  final String subject;

  @override
  State<DownloadExcelSheet> createState() => _DownloadExcelSheetState();
}

class _DownloadExcelSheetState extends State<DownloadExcelSheet> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            // Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: AutoSizeText(
            "Select Option",
            style: GoogleFonts.exo(
                fontSize: size.height*0.022,
                color: Colors.black
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height*0.02,
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        childCurrent:  DownloadExcelSheet(
                          uni: widget.uni,
                        clg: widget.clg,
                        course: widget.course,
                        branch: widget.branch,
                        year: widget.year,
                        section: widget.section,
                        subject: widget.subject,),
                        child: Subject(
                          uni: widget.uni,
                          clg: widget.clg,
                          course: widget.course,
                          branch: widget.branch,
                          year: widget.year,
                          section: widget.section,
                          subject: widget.subject,
                        ),
                        type:
                        PageTransitionType.rightToLeftJoined));
              },
              child: ListTile(
                leading: Icon(Icons.folder,color: Colors.yellow,size: size.height*0.032,),
                title: AutoSizeText(
                  "Attendance Excel Sheet",
                  style: GoogleFonts.exo(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),
              ),
            ),
            Divider(
              height: size.height*0.01,
              color: Colors.black,
              indent: size.height*0.02,
              thickness: 1,
              endIndent: size.height*0.02,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        childCurrent:  DownloadExcelSheet(
                          uni: widget.uni,
                          clg: widget.clg,
                          course: widget.course,
                          branch: widget.branch,
                          year: widget.year,
                          section: widget.section,
                          subject: widget.subject,),
                        child: quizExcelSheet(
                          uni: widget.uni,
                          clg: widget.clg,
                          course: widget.course,
                          branch: widget.branch,
                          year: widget.year,
                          section: widget.section,
                          subject: widget.subject,
                        ),
                        type:
                        PageTransitionType.rightToLeftJoined));
              },
              child: ListTile(
                leading: Icon(Icons.folder,color: Colors.yellow,size: size.height*0.032,),
                title: AutoSizeText(
                  "Quiz Excel Sheet",
                  style: GoogleFonts.exo(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),
              ),
            ),
            Divider(
              height: size.height*0.01,
              color: Colors.black,
              indent: size.height*0.02,
              thickness: 1,
              endIndent: size.height*0.02,
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            ListTile(
              leading: Icon(Icons.folder,color: Colors.yellow,size: size.height*0.032,),
              title: AutoSizeText(
                "Assignment Excel Sheet",
                style: GoogleFonts.exo(
                    fontSize: size.height*0.022,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              ),
            ),
            Divider(
              height: size.height*0.01,
              color: Colors.black,
              indent: size.height*0.02,
              thickness: 1,
              endIndent: size.height*0.02,
            )

          ],
        ),
      ),
    );
  }
}
