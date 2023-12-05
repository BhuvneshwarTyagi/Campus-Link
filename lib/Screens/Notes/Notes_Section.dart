import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Notes/Notes_Tile.dart';
import 'package:campus_link_teachers/Screens/Notes/Upload_Bottom_Sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constraints.dart';
import '../../push_notification/Storage_permission.dart';

class NotesSection extends StatefulWidget {
  const NotesSection({super.key});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {

  bool docExists=false;
  Directory? directory;
  bool permissionGranted=false;
  int currIndex=-1;
  late int totalStudents;
  var checkALLPermissions = CheckPermission();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countStudents();

  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
        width: size.width * 0.4,
        height: size.height * 0.05,
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/upload-icon.png",),
              SizedBox(width: size.width*0.02,),
              AutoSizeText("Upload Notes",style: GoogleFonts.tiltNeon(
                  color: Colors.black,
                  //const Color.fromRGBO(150, 150, 150, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: size.width*0.035),
              ),
            ],
          ),
          onPressed: () async {
            await showModalBottomSheet(
              backgroundColor: Colors.black,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  )
              ),
              context: context,
              builder: (context) {
                return const UploadBottomSheet();
              },);
          },
        ),
      ),
      body: docExists
          ?
      SizedBox(
        height:size.height*0.99,
        width:size.width*0.98,
        child: StreamBuilder
          (
          stream: FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
          {
            return  snapshot.hasData
                ?
            ListView.builder(
                itemCount: snapshot.data["Total_Notes"],
                itemBuilder: (context, index) {
                  Timestamp deadline=snapshot.data["Notes-${index+1}"]["Deadline"] ?? Timestamp(0, 0);
                  bool quizCreated = snapshot.data["Notes-${index+1}"]["Quiz_Created"];
                  String path = "/Campus Link/$university_filter $college_filter $course_filter $branch_filter $year_filter $section_filter $subject_filter/Notes/";
                  File filePath = File("$path${snapshot.data["Notes-${index + 1}"]["File_Name"]}");

                  return NotesTile(
                    pdfUrl: snapshot.data["Notes-${index+1}"]["Pdf_URL"],
                    pdfName: snapshot.data["Notes-${index+1}"]["File_Name"],
                    pdfLocalPath: path,
                    index: index+1,
                    pdfSize: snapshot.data["Notes-${index + 1}"]["File_Size"],
                    stamp: snapshot.data["Notes-${index + 1}"]["Stamp"].toDate(),
                    totalStudents: totalStudents,
                    deadLine: deadline,
                    submission: snapshot.data["Notes-${index+1}"]["Submitted by"]??[],
                    quizCreated: quizCreated,
                    filePath: filePath,
                  );

                })
                :
            const SizedBox(
              child: Center(child: Text("No Data Found")),
            );
          },),
      )
          :
      Center(
        child: AutoSizeText("No data Found Yet",
          style: GoogleFonts.poppins(
              color: Colors.black26,
              fontSize: size.height*0.03
          ),),
      ),
    );
  }
  Future<void>checkExists() async {
    await FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
        .get().then((value) {
      setState(() {
        docExists=true;
      });

    });
  }

  Future<void> countStudents() async {
    await FirebaseFirestore.instance.collection("Students")
        .where("University",isEqualTo: university_filter)
        .where("College",isEqualTo: college_filter)
        .where("Branch",isEqualTo: branch_filter)
        .where("Course",isEqualTo: course_filter)
        .where("Year",isEqualTo: year_filter)
        .where("Section",isEqualTo: section_filter)
        .where("Subject",arrayContains: subject_filter)
        .get().then((value) {
       totalStudents=value.docs.length;
       checkExists();
    });
  }
}
