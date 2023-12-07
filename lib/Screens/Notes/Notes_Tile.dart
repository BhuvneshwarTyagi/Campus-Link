import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Notes/quizquestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../Constraints.dart';
import '../../Notes_tile.dart';
import '../Chat_tiles/PdfViewer.dart';
import 'QuizScore.dart';
import 'Quiz_response.dart';
import 'download_tile.dart';

class NotesTile extends StatefulWidget {
  const NotesTile({super.key, required this.pdfUrl, required this.pdfName, required this.pdfLocalPath, required this.index, required this.pdfSize, required this.stamp, required this.totalStudents, required this.deadLine, required this.submission, required this.quizCreated, required this.filePath});
  final String pdfUrl;
  final String pdfName;
  final int index;
  final DateTime stamp;
  final int pdfSize;
  final String pdfLocalPath;
  final int totalStudents;
  final Timestamp deadLine;
  final List<dynamic> submission;
  final bool quizCreated;
  final File filePath;

  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  bool isExpanded=false;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    BorderRadiusGeometry radiusGeomentry=BorderRadius.circular(size.width*0.05);
    return InkWell(
        onTap: () async {
          String sysPath="/storage/emulated/0";
          if (File(sysPath+widget.filePath.path).existsSync()) {

            Navigator.push(
              context,
              PageTransition(
                child: PdfViewer(
                    document: sysPath+widget.filePath.path,
                    name: widget.pdfName),
                type: PageTransitionType
                    .bottomToTopJoined,
                duration: const Duration(
                    milliseconds: 200),
                alignment: Alignment.bottomCenter,
                childCurrent: const Notes(),
              ),
            );
          }else{
            InAppNotifications.instance
              ..titleFontSize = 14.0
              ..descriptionFontSize = 14.0
              ..textColor = Colors.black
              ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
              ..shadow = true
              ..animationStyle = InAppNotificationsAnimationStyle.scale;
            InAppNotifications.show(
              // title: '',
              duration: const Duration(seconds: 2),
              description: "Please download notes first before opening.",
              // leading: const Icon(
              //   Icons.error_outline_outlined,
              //   color: Colors.red,
              //   size: 55,
              // )
            );
          }
        },
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.032),
        child: Container(
          width: size.width * 0.95,
          decoration: BoxDecoration(
            //color: const Color.fromRGBO(56, 33, 101,1),
              color: Colors.white,
              borderRadius: radiusGeomentry,
              border: Border.all(color:const Color.fromRGBO(56, 33, 101,1),width: 3)
          ),
          child: Stack(

            children: [

              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.12,
                    width: size.width * 0.93,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01,
                            left: size.height * 0.01,
                            right: size.height * 0.01),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    size.width * 0.05),
                                topRight: Radius.circular(
                                    size.width * 0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height*0.01,
                              ),
                              AutoSizeText(
                                subject_filter,
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.height*0.03,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              AutoSizeText(
                                "Notes : ${widget.index}",
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.height*0.03,
                                    fontWeight: FontWeight.w400
                                ),
                              )
                            ],
                          ),)
                    ),
                  ),
                  ExpansionTile(
                    collapsedBackgroundColor: const Color.fromRGBO(60, 99, 100, 1),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.width*0.05),
                        bottomRight: Radius.circular(size.width*0.05),
                      )
                    ),
                    backgroundColor: const Color.fromRGBO(60, 99, 100, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                                size.width * 0.05),
                            bottomRight: Radius.circular(
                                size.width * 0.05)),),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            widget.pdfName != ""
                                ?
                            widget.pdfName
                                :
                            "",
                            style: GoogleFonts.tiltNeon(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight
                                    .w500),
                            maxLines: 1,

                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          AutoSizeText(
                            "Size: ${(int.parse(widget.pdfSize
                                .toString()) / 1048576)
                                .toStringAsFixed(2)} MB",
                            style: GoogleFonts.tiltNeon(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight
                                    .w500),),
                          SizedBox(
                            width: size.width * 0.005,
                          ),
                          AutoSizeText(
                            "Date: ${widget.stamp.toString().split(" ")[0]}"
                            ,
                            style: GoogleFonts.tiltNeon(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight
                                    .w500),)
                        ],
                      ),
                      leading: Container(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset("assets/icon/pdf.png")

                      ),
                      trailing: SizedBox(
                        height: size.width * 0.12,
                        width: size.width * 0.12,
                        child: FloatingActionButton(
                            backgroundColor:Colors.lightBlueAccent,
                            elevation: 0,
                            onPressed: () {
                              setState(() {
                                isExpanded=!isExpanded;

                              });
                            },
                            child:
                            Image.asset(
                              "assets/icon/speech-bubble.png",
                              width: size.height * 0.045,
                              height: size.height * 0.045,)
                        ),
                      ),
                    children: widget.quizCreated ?
                    [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //SizedBox(width: size.width*0.065,),
                        AutoSizeText("Deadline : ${widget.deadLine.toDate().toString().substring(0,16)}",style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: size.height*0.012
                        ),),
                        AutoSizeText("Submission : ${widget.submission !=  null
                            ?
                        widget.submission.length
                            :
                        0
                        } / ${widget.totalStudents}",
                          style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: size.height*0.012
                          ),),
                      ],
                    ),
                      SizedBox(height: size.width*0.028,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Divider(
                            color: Colors.white70,
                            indent: size.width*0.03,
                            endIndent: size.width*0.03,
                            thickness: 1,
                          ),
                          ListTile(
                            enabled: true,
                            focusColor: Colors.white38,
                            tileColor: Colors.transparent,
                            splashColor: Colors.black87,
                            onTap: () {
                              Navigator.push(context,
                                  PageTransition(
                                      child: responseScreen(
                                        quizId: widget.index,),
                                      type: PageTransitionType
                                          .bottomToTopJoined,
                                      childCurrent: const Notes(),
                                      duration: const Duration(
                                          milliseconds: 300)
                                  )
                              );
                            },
                            leading: Image.asset("assets/images/response.png"),
                            title: AutoSizeText(
                              "See Response",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.022,
                                  color: Colors.white
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.white70,),
                          ),
                          Divider(
                            color: Colors.white70,
                            indent: size.width*0.03,
                            endIndent: size.width*0.03,
                            thickness: 1,
                          ),
                          ListTile(
                            enabled: true,
                            focusColor: Colors.transparent,
                            tileColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            leading: Image.asset("assets/images/leaderboard.png"),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.white70,),
                            onTap: () {
                              if(widget.submission.length>3)
                              {
                                Navigator.push(context,
                                    PageTransition(
                                        child: Quizscore(
                                          quizId: widget.index,),
                                        type: PageTransitionType
                                            .bottomToTopJoined,
                                        childCurrent: const Notes(),
                                        duration: const Duration(
                                            milliseconds: 300)
                                    )
                                );
                              }
                              else{
                                InAppNotifications.instance
                                  ..titleFontSize = 25.0
                                  ..descriptionFontSize = 15.0
                                  ..textColor = Colors.black
                                  ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                  ..shadow = true
                                  ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                InAppNotifications.show(
                                  title: 'Error',
                                  duration: const Duration(seconds: 2),
                                  description: "Submissions are less than three",
                                  leading: const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                );
                              }

                            },
                            title: AutoSizeText(
                              "Leaderboard",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.022,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height*0.01,
                      )
                    ]
                        :
                    [
                      ListTile(
                                enabled: true,
                                focusColor: Colors.white38,
                                tileColor: Colors.transparent,
                                splashColor: Colors.black87,
                                onTap: () {
                                  Navigator.push(context,
                                      PageTransition(
                                          child: QuizQustion(
                                            quizNumber: widget.index,),
                                          type: PageTransitionType
                                              .bottomToTopJoined,
                                          childCurrent: const Notes(),
                                          duration: const Duration(
                                              milliseconds: 300)
                                      )
                                  );
                                },
                                leading: Image.asset("assets/images/response.png"),
                                title: AutoSizeText(
                                  "Create Quiz",
                                  style: GoogleFonts.tiltNeon(
                                      fontSize: size.height * 0.022,
                                      color: Colors.white
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.white70,),
                              ),
                      SizedBox(
                        height: size.height*0.01,
                      )
                    ],
                        ),

                    ]
                  ),
              Positioned(
                top: 10,
                right: size.width*0.055,
                child: DownloadButton(
                  downloadUrl: widget.pdfUrl,
                  pdfName: widget.pdfName,
                  path: widget.pdfLocalPath,
                ),
              ),
                ],
              ),
          ),
        ),
      );
  }
}
