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



class _Assignments_uploadState extends State<Assignments_upload> {


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docexits();
    checkAndRequestPermissions();

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
                    // if(snapshot.hasData){
                    //   docexits();
                    // }
                    return snapshot.hasData
                    ?
                SizedBox(

                  child: ListView.builder(
                    itemCount: snapshot.data!["Total_Assignment"],
                    itemBuilder: (context, index) {
                      bool isDownloaded=false;
                      String newpath =
                          "${path}Assignment-${index + 1}.${snapshot
                          .data!["Assignment-${index + 1}"]["Document-type"]}";
                      if(File(newpath).existsSync())
                      {
                        isDownloaded=true;
                      }

                      return Padding(
                          padding: EdgeInsets.all(size.height*0.021),
                          child: InkWell(
                            onTap: (){
                              if( File(newpath).existsSync()) {
                                if (snapshot.data!["Assignment-${index +
                                    1}"]["Document-type"] == "pdf") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            PdfViewer(
                                              document:
                                              "${path}Assignment-${index +
                                                  1}.${snapshot
                                                  .data!["Assignment-${index +
                                                  1}"]["Document-type"]}",
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
                                             style: GoogleFonts.courgette(
                                                 color: Colors.black,
                                                 fontSize: size.height*0.02,
                                                 fontWeight: FontWeight.w400
                                             ),
                                           ),
                                           AutoSizeText(
                                             "Assignment : ${index + 1}",
                                             style: GoogleFonts.courgette(
                                                 color: Colors.black,
                                                 fontSize: size.height*0.02,
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
                                                   "Assignment : ${index + 1} (${(int.parse(snapshot.data!["Assignment-${index + 1}"]["Size"].toString())/1048576).toStringAsFixed(2)}MB)",
                                                   style: GoogleFonts.courgette(
                                                       color: Colors.black,
                                                       fontSize: size.height*0.019,
                                                       fontWeight: FontWeight.w400
                                                   ),
                                                 ),
                                                 AutoSizeText(
                                                   "Deadline :${snapshot
                                                       .data!["Assignment-${index +
                                                       1}"]["Last Date"]}",
                                                   style: GoogleFonts.courgette(
                                                       color: Colors.black,
                                                       fontSize: size.height*0.019,
                                                       fontWeight: FontWeight.w400
                                                   ),
                                                 ),
                                                 AutoSizeText(
                                                   "Assign:${(snapshot
                                                       .data!["Assignment-${index +
                                                       1}"]["Assign-Date"].toDate()).toString().split(" ")[0]}",
                                                   style: GoogleFonts.courgette(
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
                                                   ))),
                                             )


                                           ],
                                         )
                                     )
                                   ],
                                 ),
                                  !isDownloaded
                                      ?
                                  Positioned(
                                      top: 8,
                                      right: size.width*0.04,
                                      child: download(downloadUrl:snapshot.data!.data()?["Assignment-${index + 1}"]["Assignment"], pdfName: "Assignment-${index + 1}.${snapshot.data?.data()?["Assignment-${index + 1}"]["Document-type"]}", path:path))
                                      :
                                  const SizedBox()


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


        )
        ,

        floatingActionButton: Container(
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
      ),
    );
  }

  Future<void> checkAndRequestPermissions() async {
    directory = await getExternalStorageDirectory();

    var permission = await checkALLPermissions.isStoragePermission();
    if(!permission){
      if(await Permission.manageExternalStorage.request().isGranted){
        permission=true;
      }else{
        await Permission.manageExternalStorage.request().then((value) {
          bool check=value.isGranted;
          if(check){permission=true;}});
      }

    }
    if (permission) {
      dir = directory!.path.toString().substring(0, 19);
      path =
      "$dir/Campus Link/${university_filter.split(" ")[0]}${college_filter
          .split(" ")[0]}${course_filter.split(" ")[0]}${branch_filter.split(
          " ")[0]}$year_filter$section_filter$subject_filter/Assignment/";
      Directory(path).exists().then((value) async {
        if (!value) {
          await Directory(path)
              .create(recursive: true)
              .whenComplete(() => print(">>>>>created"));
        }
      });
      setState(() {
        permissionGranted = true;
      });
    } else {
      permissionGranted = false;
    }
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


