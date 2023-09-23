import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/subject_attendace.dart';
import 'package:campus_link_teachers/push_notification/Storage_permission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

class Download_attendance extends StatefulWidget {
  const Download_attendance({Key? key}) : super(key: key);

  @override
  State<Download_attendance> createState() => _Download_attendanceState();
}

class _Download_attendanceState extends State<Download_attendance> {
  bool isPermission = false;
  var checkALLPermissions = CheckPermission();
  checkPermission() async {
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  var getpathFile = DirectoryPath();
  bool fileExists = false;
  late String filePath;
  String fileName = "";

  var files;

  List<dynamic>curr_filder=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curr_filder.clear();
    fetch_university();
    //checkPermission();
  }
  Future<void> checkFileExist(String path) async {
    bool fileExistCheck = await Directory(path).exists();
    if(fileExistCheck!=true){
      await Directory(path).create(recursive: true);
    }
    print(".......${path}");
  }
  Color headingcolor = Colors.cyan;
  Color optioncolor = Colors.white;
  PageController Page_controller = PageController();
  List<dynamic>? university_list = [];
  List<dynamic>? clg_list = [];
  List<dynamic>? course_list = [];
  List<dynamic>? branch_list = [];
  List<dynamic>? year_list = [];
  List<dynamic>? section_list = [];
  List<dynamic>? subject_list = [];
  var currentuni = "";
  var currentclg = "";
  var currentcourse = "";
  var currentbranch = "";
  var currentyear = "";
  var currentsection = "";
  var currentsubject = "";
  var current_page = 0;
  int uni_index = -1;
  int clgIndex = -1;
  int courseIndex = -1;
  int branchIndex = -1;
  int yearIndex = -1;
  int sectionIndex = -1;
  int subjectIndex = -1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return university_list!.isEmpty
        ? const Center(child: CircularProgressIndicator())
        :
    Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       bottomRight: Radius.circular(30),
        //       bottomLeft: Radius.circular(30),
        //     )
        // ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: AutoSizeText(
          "Download Attendance",
          style: GoogleFonts.gfsDidot(fontSize: size.height*0.03, color: Colors.black),
        ),
      ),
      body:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height*0.07,
                  width: size.width*1,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: (){
                            setState(() {
                              current_page=0;
                              curr_filder.clear();
                            });
                            Page_controller.animateToPage(current_page,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.linear);
                          },
                          icon: const Icon(Icons.folder),color: Colors.amber,iconSize: size.height*0.04),
                      SizedBox(
                        width: size.width*0.84,
                        height: size.height*0.08,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: curr_filder.length,
                          itemBuilder: (context, index) {
                            print(curr_filder[index]+"h");
                            return InkWell(
                                onTap: (){
                              setState(() {
                                current_page=index;
                                curr_filder.removeRange(index,curr_filder.length);
                              });
                              Page_controller.animateToPage(current_page,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.linear);
                            },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      " > ",
                                      style: GoogleFonts.exo(
                                        fontSize: size.width*0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    AutoSizeText(
                                      curr_filder[index].split(" ")[0],
                                      style: GoogleFonts.exo(
                                        fontSize: size.width*0.03,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                      ),
                                      softWrap: true,
                                      maxLines: 1,
                                    ),
                                  ],
                                ));

                        },),
                      )
                    ],
                  ),
                ),
                Container(
                  height: size.height*0.816,
                  decoration: BoxDecoration(

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        // Colors.black,
                        // Colors.deepPurple,
                        // Colors.purpleAccent
                        const Color.fromRGBO(86, 149, 178, 1),

                        const Color.fromRGBO(68, 174, 218, 1),
                        //Color.fromRGBO(118, 78, 232, 1),
                        Colors.deepPurple.shade300
                      ],
                    ),
                    border: const Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),

                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height*0.005),
                    child: PageView(
                      controller: Page_controller,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          current_page = index;
                        });
                      },
                      children: [
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: ListView.builder(
                            itemCount: university_list?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      print("Yess");
                                      setState(() {
                                        uni_index = index;
                                        fetch_college();
                                        current_page = index + 1;
                                        currentuni = university_list?[index];
                                        curr_filder.add(currentuni);
                                      });
                                      Page_controller.animateToPage(current_page,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.linear);
                                    },
                                    child: SizedBox(
                                      width: size.width*1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.05,
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.08,
                                                  width: size.width * 0.1,
                                                  child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                              SizedBox(
                                                width: size.width * 0.05,
                                              ),
                                              AutoSizeText(
                                                university_list?[index],
                                                style: GoogleFonts.exo(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            height: 2,
                                            color: Colors.black87,
                                            indent: 5,
                                            endIndent: 5,
                                            thickness: 2,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height*0.78,
                                child: ListView.builder(
                                  itemCount: clg_list?.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 0,

                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            clgIndex = index;
                                            fetch_course();
                                            current_page += 1;
                                            currentclg = clg_list?[index];
                                            curr_filder.add(currentclg);
                                          });
                                          Page_controller.animateToPage(current_page,
                                              duration: const Duration(milliseconds: 400),
                                              curve: Curves.linear);
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.05,
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.08,
                                                    width: size.width * 0.1,
                                                    child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                                SizedBox(
                                                  width: size.width * 0.05,
                                                ),
                                                AutoSizeText(
                                                  clg_list?[index],
                                                  style: GoogleFonts.exo(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              height: 2,
                                              color: Colors.black87,
                                              indent: 5,
                                              endIndent: 5,
                                              thickness: 2,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: course_list?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        courseIndex = index;
                                        fetch_branch();
                                        currentcourse = course_list?[index];
                                        current_page += 1;
                                        curr_filder.add(currentcourse);
                                      });
                                      Page_controller.animateToPage(current_page,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.linear);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.08,
                                                width: size.width * 0.1,
                                                child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            AutoSizeText(
                                              course_list?[index],
                                              style: GoogleFonts.exo(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: Colors.black87,
                                          indent: 5,
                                          endIndent: 5,
                                          thickness: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: branch_list?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        branchIndex = index;
                                        fetch_year();
                                        currentbranch = branch_list?[index];
                                        current_page += 1;
                                        curr_filder.add(currentbranch);
                                      });
                                      Page_controller.animateToPage(current_page,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.linear);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.08,
                                                width: size.width * 0.1,
                                                child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            AutoSizeText(
                                              branch_list?[index],
                                              style: GoogleFonts.exo(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: Colors.black87,
                                          indent: 5,
                                          endIndent: 5,
                                          thickness: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: year_list?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        yearIndex = index;
                                        fetch_Section();
                                        current_page += 1;
                                        currentyear = year_list?[index];
                                        curr_filder.add(currentyear);
                                      });
                                      Page_controller.animateToPage(current_page,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.linear);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.08,
                                                width: size.width * 0.1,
                                                child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            AutoSizeText(
                                              "Year - ${year_list?[index]}",
                                              style: GoogleFonts.exo(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: Colors.black87,
                                          indent: 5,
                                          endIndent: 5,
                                          thickness: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: section_list?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        sectionIndex = index;
                                        current_page += 1;
                                        fetch_Subjects();
                                        currentsection = section_list?[index];
                                        curr_filder.add(currentsection);
                                      });
                                      Page_controller.animateToPage(current_page,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.linear);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.08,
                                                width: size.width * 0.1,
                                                child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            AutoSizeText(
                                              "Section - ${section_list?[index]}",
                                              style: GoogleFonts.exo(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: Colors.black87,
                                          indent: 5,
                                          endIndent: 5,
                                          thickness: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 1,
                          width: size.width * 1,
                          child: SizedBox(
                            child: ListView.builder(
                              itemCount: subject_list?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {

                                      setState(() {
                                        subjectIndex = index;
                                        currentsubject = subject_list?[index];
                                        curr_filder.add(currentsubject);
                                        curr_filder=curr_filder.toSet().toList();
                                      });
                                      Directory? path = await getExternalStorageDirectory();
                                      print(path?.path);
                                      await checkFileExist("${path?.path}/$currentuni/$currentclg/$currentcourse/$currentbranch/$currentyear/$currentsection/$currentsubject/")
                                          .whenComplete(() => Navigator.push(
                                          context,
                                          PageTransition(
                                              childCurrent: const Download_attendance(),
                                              child: Subject(
                                                uni: currentuni,
                                                clg: currentclg,
                                                course: currentcourse,
                                                branch: currentbranch,
                                                section: currentsection,
                                                subject: currentsubject,
                                                year: currentyear,
                                              ),
                                              type:
                                              PageTransitionType.rightToLeftJoined)));

                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            SizedBox(
                                                height: size.height * 0.08,
                                                width: size.width * 0.1,
                                                child: Icon(Icons.folder,size: size.height*0.05,color: Colors.amber,)),
                                            SizedBox(
                                              width: size.width * 0.05,
                                            ),
                                            AutoSizeText(
                                              subject_list?[index],
                                              style: GoogleFonts.exo(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: Colors.black87,
                                          indent: 5,
                                          endIndent: 5,
                                          thickness: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Future<void> fetch_university() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();
    setState(() {
      university_list = ref.data()?["University"];
    });
  }

  Future<void> fetch_college() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();
    setState(() {
      clg_list = ref.data()?["College-$uni_index"];
    });
  }

  Future<void> fetch_course() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();

    setState(() {
      course_list = ref.data()?["Course-$uni_index$clgIndex"];
    });
  }

  Future<void> fetch_branch() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();

    setState(() {
      branch_list = ref.data()?["Branch-$uni_index$clgIndex$courseIndex"];
    });
    print(branch_list);
    print("Course-$uni_index$clgIndex$courseIndex");
  }

  Future<void> fetch_year() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();

    setState(() {
      year_list =
          ref.data()?["Year-$uni_index$clgIndex$courseIndex$branchIndex"];
    });
    print(year_list);
    print("Course-$uni_index$clgIndex$courseIndex$branchIndex");
  }

  Future<void> fetch_Section() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();

    setState(() {
      section_list = ref.data()?[
          "Section-$uni_index$clgIndex$courseIndex$branchIndex$yearIndex"];
    });
  }

  Future<void> fetch_Subjects() async {
    final ref = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc("arunsaini892307@gmail.com")
        .collection("Teachings")
        .doc("Teachings")
        .get();

    setState(() {
      subject_list = ref.data()?[
          "Subject-$uni_index$clgIndex$courseIndex$branchIndex$yearIndex$sectionIndex"];
    });
  }
}

