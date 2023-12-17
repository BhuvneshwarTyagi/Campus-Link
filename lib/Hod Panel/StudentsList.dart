import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({super.key});

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  String selectedUniversity=usermodel["HOD University"];
  String selectedCollege=usermodel["HOD College"];
  String selectedCourse= usermodel["HOD Course"];
  String selectedBranch= usermodel["HOD Branch"];
  int selectedYear=1;
  String selectedSection="A";
  String selectedSubject="";
  ExpansionTileController universityController = ExpansionTileController();
  ExpansionTileController collegeController = ExpansionTileController();
  ExpansionTileController courseController = ExpansionTileController();
  ExpansionTileController branchController = ExpansionTileController();
  ExpansionTileController yearController = ExpansionTileController();
  ExpansionTileController sectionController = ExpansionTileController();
  ExpansionTileController subjectController = ExpansionTileController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height*0.08,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Students")
                        .where("University",isEqualTo: selectedUniversity)
                        .where("College",isEqualTo: selectedCollege)
                        .where("Course",isEqualTo: selectedCourse)
                        .where("Branch",isEqualTo: selectedBranch)
                        .where("Year",isEqualTo: selectedYear)
                        .where("Section",isEqualTo: selectedSection)
                        .where("Subject", arrayContains: selectedSubject)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print("$selectedUniversity $selectedCollege $selectedCourse $selectedBranch $selectedYear $selectedSection $selectedSubject");
                      return snapshot.hasData
                          ?
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          print(index);
                        return Card(
                          child: ListTile(
                            title: AutoSizeText(snapshot.data?.docs[index].data()["Name"]),
                          ),
                        );
                      },)
                      :
                      const SizedBox();
                      },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Subject").doc(selectedBranch).snapshots(),
                      builder: (context, snapshot) {
                        print("here");
                        return snapshot.hasData ?
                        SizedBox(
                          width: size.width*0.3,

                          child: Card(
                            color: Colors.white,
                            child: ExpansionTile(
                              controller: subjectController,
                              title: AutoSizeText(
                                selectedSubject,
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.03,
                                    fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                              ),

                              children: [
                                SizedBox(
                                  width: size.width*0.3,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.data()?["Subject"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["Subject"][index],
                                          style: GoogleFonts.tiltNeon(
                                              color: Colors.black,
                                              fontSize: size.width*0.03,
                                              fontWeight: FontWeight.w500
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: (){
                                          setState(() {
                                            subjectController.collapse();
                                            selectedSubject = snapshot.data!.data()?["Subject"][index];

                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )
                            :
                        SizedBox();
                      }
                  ),
                  SizedBox(
                    width: size.width*0.2,

                    child: Card(
                      color: Colors.white,
                      child: ExpansionTile(
                        controller: sectionController,
                        title: AutoSizeText(
                          selectedSection,
                          style: GoogleFonts.tiltNeon(
                              color: Colors.black,
                              fontSize: size.width*0.03,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                        ),

                        children: [
                          SizedBox(
                            width: size.width*0.15,
                            height: size.height*0.2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: alphabet.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: AutoSizeText(
                                    alphabet[index],
                                    style: GoogleFonts.tiltNeon(
                                        color: Colors.black,
                                        fontSize: size.width*0.03,
                                        fontWeight: FontWeight.w500
                                    ),
                                    maxLines: 1,
                                  ),
                                  onTap: (){
                                    setState(() {
                                      sectionController.collapse();
                                      selectedSection = alphabet[index];

                                    });
                                  },
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width*0.2,

                    child: Card(
                      color: Colors.white,
                      child: ExpansionTile(
                        controller: yearController,
                        title: AutoSizeText(
                          "$selectedYear",
                          style: GoogleFonts.tiltNeon(
                              color: Colors.black,
                              fontSize: size.width*0.03,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                        ),

                        children: [
                          SizedBox(
                            width: size.width*0.15,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: AutoSizeText(
                                    "${index+1}",
                                    style: GoogleFonts.tiltNeon(
                                        color: Colors.black,
                                        fontSize: size.width*0.03,
                                        fontWeight: FontWeight.w500
                                    ),
                                    maxLines: 1,
                                  ),
                                  onTap: (){
                                    setState(() {
                                      yearController.collapse();
                                      selectedYear = index+1;

                                    });
                                  },
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
