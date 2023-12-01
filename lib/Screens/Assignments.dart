import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/upload_assignmentQuestion.dart';
import 'package:campus_link_teachers/Screens/view_assignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Constraints.dart';
import '../push_notification/Storage_permission.dart';
import 'Chat_tiles/Image_viewer.dart';
import 'Chat_tiles/PdfViewer.dart';
import 'Notes/download_tile.dart';

class Assignments_upload extends StatefulWidget {
  const Assignments_upload({Key? key}) : super(key: key);

  @override
  State<Assignments_upload> createState() => _Assignments_uploadState();
}


PageController pageController=PageController();
bool active = false;
int currIndex=0;



class _Assignments_uploadState extends State<Assignments_upload> with TickerProviderStateMixin{


  var checkALLPermissions = CheckPermission();
  Directory? directory;
  String path = "";
  double percent=0.0;
  bool permissionGranted = false;
  bool docExists = false;
  bool fileAlreadyExists = false;
  final dio = Dio();
  List<bool>isExpanded=[];
  late String dir;
  late TabController _tabController;
  int currTab=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
    docexits();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(

        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: size.height*0.07,
          flexibleSpace: SizedBox(
            height: size.height * 0.11,
            width: size.width * 1,
            child: Column(
              children: [
                SizedBox(height: size.height*0.01),
                TabBar(
                  indicatorColor: Colors.black,
                  labelColor: Colors.green,

                  controller: _tabController,
                  onTap: (value) {
                    setState(() {
                      currTab=value;
                    });
                  },
                  tabs: [
                    SizedBox(
                      height: size.height*0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width*0.1,
                            child: Image.asset("assets/images/assignment.png"),
                          ),
                          SizedBox(
                            width: size.width*0.02,
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: AutoSizeText(
                              "Assignments",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width*0.08,
                            child: Image.asset("assets/images/leaderboard.png"),
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: AutoSizeText(
                              "Leaderboard",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    // Container(
                    //   height: size.height * 0.06,
                    //   //width: size.width * 0.38,
                    //   decoration: BoxDecoration(
                    //       gradient: const LinearGradient(
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //         colors: [
                    //           Colors.blue,
                    //           Colors.purpleAccent,
                    //         ],
                    //       ),
                    //       borderRadius: const BorderRadius.all(Radius.circular(20)),
                    //       border: Border.all(color: Colors.black, width: 2)),
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         elevation: 0,
                    //         backgroundColor: Colors.transparent,
                    //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                    //     ),
                    //     onPressed: () {
                    //
                    //
                    //
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         const Icon(Icons.leaderboard_sharp,color: Colors.red),
                    //         FittedBox(
                    //           fit: BoxFit.cover,
                    //           child: AutoSizeText(
                    //             "Leaderboard",
                    //             style: TextStyle(
                    //                 fontSize: size.height * 0.02,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Colors.white70
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   height: size.height * 0.06,
                    //   //width: size.width * 0.38,
                    //   decoration: BoxDecoration(
                    //       gradient: const LinearGradient(
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //         colors: [
                    //           Colors.blue,
                    //           Colors.purpleAccent,
                    //         ],
                    //       ),
                    //       borderRadius: const BorderRadius.all(Radius.circular(20)),
                    //       border: Border.all(color: Colors.black, width: 2)),
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         elevation: 0,
                    //         backgroundColor: Colors.transparent,
                    //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                    //     ),
                    //     onPressed: () {
                    //
                    //
                    //
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: [
                    //         const Icon(Icons.upload_sharp,color: Colors.red),
                    //         FittedBox(
                    //           fit: BoxFit.cover,
                    //           child: AutoSizeText(
                    //             "Upload Notes",
                    //             style: TextStyle(
                    //                 fontSize: size.height * 0.02,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Colors.white70
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SizedBox(
            height: size.height,
            width: size.width,
            child: subject_filter.isEmpty ?
            const Center(
              child: Text("Please Apply filter to see the Assignment"),
            )
                :
            docExists
                ?
            SizedBox(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Assignment").doc(
                      "${university_filter.split(" ")[0]} ${college_filter
                          .split(" ")[0]} ${course_filter.split(
                          " ")[0]} ${branch_filter.split(
                          " ")[0]} $year_filter $section_filter $subject_filter")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    return snapshot.hasData
                    ?
                SizedBox(

                  child: ListView.builder(
                    itemCount: snapshot.data!["Total_Assignment"],
                    itemBuilder: (context, index) {
                      String sysPath= "/storage/emulated/0";
                      String path="/Campus Link/$university_filter $college_filter $course_filter $branch_filter $year_filter $section_filter $subject_filter/Assignments/";
                      String newpath =
                          "$sysPath$path/Assignment-${index + 1}.${snapshot
                          .data!["Assignment-${index + 1}"]["Document-type"]}";

                      return Padding(
                          padding: EdgeInsets.all(size.height*0.021),
                          child: InkWell(
                            onTap: (){
                              print("presseddddddddddddd");
                              if( File(newpath).existsSync()) {
                                if (snapshot.data!["Assignment-${index + 1}"]["Document-type"] == "pdf") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            PdfViewer(
                                              document:
                                              newpath,
                                              name:
                                              "Assignment-${index + 1}",
                                            ),
                                      ));
                                }
                                else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            Image_viewer(path: File(
                                                '${path}Assignment-${index +
                                                    1}.${snapshot
                                                    .data!["Assignment-${index +
                                                    1}"]["Document-type"]}'),

                                            ),
                                      ));
                                }
                              }
                            },

                            child: Container(

                              height: size.height*0.21,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.black,width: 2)
                              ),
                              child: Stack(
                                children: [
                                 Column(
                                   children: [
                                     Container(
                                       height: size.height*0.1,
                                       width: size.width,
                                       decoration: const BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))

                                       ),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
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
                                             "Assignment: ${index + 1}",
                                             style: GoogleFonts.tiltNeon(
                                                 color: Colors.black,
                                                 fontSize: size.height*0.024,
                                                 fontWeight: FontWeight.w400
                                             ),
                                           )
                                         ],
                                       ),
                                     ),
                                     Container(
                                         padding: EdgeInsets.all( size.height*0.008),
                                         height: size.height*0.104,
                                         width: size.width,
                                         decoration: const BoxDecoration(
                                           color:  Color.fromRGBO(60, 99, 100, 1),
                                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),

                                         ),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 AutoSizeText(
                                                   "Assignment: ${index + 1} (${(int.parse(snapshot.data!["Assignment-${index + 1}"]["Size"].toString())/1048576).toStringAsFixed(2)}MB)",
                                                   style: GoogleFonts.tiltNeon(
                                                       color: Colors.black,
                                                       fontSize: size.height*0.019,
                                                       fontWeight: FontWeight.w400
                                                   ),
                                                 ),
                                                 AutoSizeText(
                                                   "Deadline: ${snapshot
                                                       .data!["Assignment-${index +
                                                       1}"]["Last Date"]}",
                                                   style: GoogleFonts.tiltNeon(
                                                       color: Colors.black,
                                                       fontSize: size.height*0.019,
                                                       fontWeight: FontWeight.w400
                                                   ),
                                                 ),
                                                 AutoSizeText(
                                                   "Assign: ${(snapshot
                                                       .data!["Assignment-${index +
                                                       1}"]["Assign-Date"].toDate()).toString().split(" ")[0]}",
                                                   style: GoogleFonts.tiltNeon(
                                                       color: Colors.black,
                                                       fontSize: size.height*0.02,
                                                       fontWeight: FontWeight.w400
                                                   ),
                                                 ),
                                               ],
                                             ),
                                             Container(
                                               height: size.height * 0.045,
                                               width: size.width * 0.27,
                                               decoration: BoxDecoration(
                                                   color: Colors.transparent,
                                                   borderRadius: const BorderRadius.all(
                                                       Radius.circular(20)),
                                                   border: Border.all(
                                                       color: Colors.black, width: 1)
                                               ),
                                               child: ElevatedButton(
                                                   style: ElevatedButton.styleFrom(

                                                       shape: const RoundedRectangleBorder(
                                                           borderRadius: BorderRadius
                                                               .all(
                                                               Radius.circular(20))),
                                                       backgroundColor: Colors
                                                           .transparent
                                                   ),
                                                   onPressed: () {
                                                     if (snapshot.data!
                                                         .data()?["Assignment-${index +
                                                         1}"]["Submitted-by"] != null) {
                                                       Navigator.push(context,
                                                           MaterialPageRoute(
                                                             builder: (context) =>
                                                                 ViewAssignment(
                                                                     selectedindex: index +
                                                                         1),));
                                                     }
                                                   }, child: FittedBox(
                                                   fit: BoxFit.cover,
                                                   child: AutoSizeText("Submission",
                                                     style:TextStyle(
                                                         fontSize: size.height * 0.02,
                                                         fontWeight: FontWeight.w500,
                                                         color: Colors.white
                                                     ),
                                                   ),
                                               ),
                                               ),
                                             )


                                           ],
                                         )
                                     )
                                   ],
                                 ),

                                  Positioned(
                                      top: 8,
                                      right: size.width*0.04,
                                      child: DownloadButton(
                                          downloadUrl: snapshot.data!.data()?["Assignment-${index + 1}"]["Assignment"],
                                          pdfName: "Assignment-${index + 1}.${snapshot.data?.data()?["Assignment-${index + 1}"]["Document-type"]}",
                                          path: path
                                      ),
                                  )


                                ],
                              ),
                            ),
                          )
                      );
                    },),
                )
                    :
                const SizedBox();
              }
              ),
            )
                :
            SizedBox(
              child: Center(
                child: AutoSizeText(
                  "No Data Found Yet",
                  style: GoogleFonts.openSans(
                      color: Colors.white70,
                      fontSize: size.height*0.04
                  ),
                ),
              ),
            )


        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.purpleAccent],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black, width: 1)
              ),
              width: size.width * 0.36,
              height: size.height * 0.05,
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/upload-icon.png",),
                    // const Icon(
                    //   Icons.upload,
                    //   color: Colors.white70,
                    // ),
                    SizedBox(width: size.width*0.02,),
                    AutoSizeText("Upload File",style: GoogleFonts.tiltNeon(
                        color: Colors.black,
                        //const Color.fromRGBO(150, 150, 150, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: size.width*0.035),
                    ),
                ],
                ),
                onPressed: () {
                  subject_filter.isEmpty
                      ?
                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        AlertDialog(

                          title: const Text("Do You Want to Upload Assignment"),
                          content: const Text("Please Apply Filter First"),
                          actions: <Widget>[
                            TextButton(

                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("okay"),
                            ),
                          ],
                        ),
                  )
                      :
                  Navigator.push(context, PageTransition(
                    child: const AssigmentQuestion(),
                    type: PageTransitionType.bottomToTopJoined,
                    duration: const Duration(milliseconds: 300),
                    childCurrent: const Assignments_upload(),

                  ));
                },
              ),
            ),
            SizedBox(
              height: size.height*0.06,
            )
          ],
        ),
      ),
    );
  }



  Future<void> docexits() async {
    FirebaseFirestore.instance
        .collection("Assignment").doc(
        "${university_filter.split(" ")[0]} ${college_filter.split(
            " ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(
            " ")[0]} $year_filter $section_filter $subject_filter")
        .get().then( (value) {
      if(value.exists){

        print(".......Yes Not Null");
        setState(() {


          docExists=true;
        }
        );

      }
      else{
        setState(() {
          docExists=false;
        });
      }

    });
  }


}


