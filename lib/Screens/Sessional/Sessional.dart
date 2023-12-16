import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Screens/Sessional/Upload_Marks.dart';
import 'package:campus_link_teachers/Screens/Sessional/View_Marks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sessional extends StatefulWidget {
  const Sessional({Key? key}) : super(key: key);

  @override
  State<Sessional> createState() => _SessionalState();
}

class _SessionalState extends State<Sessional> with TickerProviderStateMixin{

  late TabController _tabController;
  int currTab=0;
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }
  int selectedUniversity=0;
  int selectedCollege=0;
  int selectedCourse=0;
  int selectedBranch=0;
  int selectedYear=0;
  int selectedSection=0;
  int selectedSubject=0;
  ExpansionTileController universityController = ExpansionTileController();
  ExpansionTileController collegeController = ExpansionTileController();
  ExpansionTileController courseController = ExpansionTileController();
  ExpansionTileController branchController = ExpansionTileController();
  ExpansionTileController yearController = ExpansionTileController();
  ExpansionTileController sectionController = ExpansionTileController();
  ExpansionTileController subjectController = ExpansionTileController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
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
                            width: size.width*0.08,
                            child: Image.asset("assets/images/viewmarks.png"),
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: AutoSizeText(
                              "View Marks",
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
                            child: Image.asset("assets/images/uploadmarks.png"),
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: AutoSizeText(
                              "Upload Marks",
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
                  ],
                ),
              ],
            ),
          ),
        ),

        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Teachers").doc(usermodel["Email"]).collection("Teachings").doc("Teachings").snapshots(),
            builder: (context, snapshot) {
            return snapshot.hasData ?
                snapshot.data!.data()!.isNotEmpty
                    ?
            Stack(
              children: [
                Column(
                    children: [
                      SizedBox(
                        height: size.height*0.08,
                      ),
                      Expanded(
                          child: currTab==0
                              ?
                              ViewMarks(
                                university: snapshot.data!.data()?["University"][selectedUniversity],

                                college: snapshot.data!.data()?["College-$selectedUniversity"][selectedCollege],
                                course: snapshot.data!.data()?["Course-$selectedUniversity$selectedCollege"][selectedCourse],
                                branch: snapshot.data!.data()?["Branch-$selectedUniversity$selectedCollege$selectedCourse"][selectedBranch],
                                year: snapshot.data!.data()?["Year-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch"][selectedYear],
                                section: snapshot.data!.data()?["Section-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear"][selectedSection],
                                subject: snapshot.data!.data()?["Subject-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear$selectedSection"][selectedSubject],
                              )
                              :
                              UploadMarks(
                                university: snapshot.data!.data()?["University"][selectedUniversity],

                                college: snapshot.data!.data()?["College-$selectedUniversity"][selectedCollege],
                                course: snapshot.data!.data()?["Course-$selectedUniversity$selectedCollege"][selectedCourse],
                                branch: snapshot.data!.data()?["Branch-$selectedUniversity$selectedCollege$selectedCourse"][selectedBranch],
                                year: snapshot.data!.data()?["Year-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch"][selectedYear],
                                section: snapshot.data!.data()?["Section-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear"][selectedSection],
                                subject: snapshot.data!.data()?["Subject-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear$selectedSection"][selectedSubject],
                              )
                      )
                    ],
                ),
                SizedBox(
                  width: size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width*0.3,

                          child: Card(
                            color: Colors.white,
                            child: ExpansionTile(
                              controller: subjectController,
                              title: AutoSizeText(
                                snapshot.data!.data()?["Subject-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear$selectedSection"][selectedSubject],
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
                                    itemCount: snapshot.data!.data()?["Subject-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear$selectedSubject"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["Subject-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear$selectedSubject"][index],
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
                                            selectedSubject = index;

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
                              controller: sectionController,
                              title: AutoSizeText(
                                snapshot.data!.data()?["Section-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear"][selectedSection],
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
                                    itemCount: snapshot.data!.data()?["Section-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["Section-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch$selectedYear"][index],
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
                                            selectedSection = index;

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
                                snapshot.data!.data()?["Year-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch"][selectedYear],
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
                                    itemCount: snapshot.data!.data()?["Year-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["Year-$selectedUniversity$selectedCollege$selectedCourse$selectedBranch"][index],
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
                                            selectedYear = index;

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
                          width: size.width*0.3,

                          child: Card(
                            color: Colors.white,
                            child: ExpansionTile(
                              controller: branchController,
                              title: AutoSizeText(
                                snapshot.data!.data()?["Branch-$selectedUniversity$selectedCollege$selectedCourse"][selectedBranch],
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.03,
                                    fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                              ),

                              children: [
                                SizedBox(
                                  width: size.width*0.25,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.data()?["Branch-$selectedUniversity$selectedCollege$selectedCourse"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["Branch-$selectedUniversity$selectedCollege$selectedCourse"][index],
                                          style: GoogleFonts.tiltNeon(
                                              color: Colors.black,
                                              fontSize: size.width*0.03,
                                              fontWeight: FontWeight.w500
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: (){
                                          setState(() {
                                            branchController.collapse();
                                            selectedBranch = index;

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
                          width: size.width*0.3,

                          child: Card(
                            color: Colors.white,
                            child: ExpansionTile(
                              controller: courseController,
                              title: AutoSizeText(
                                snapshot.data!.data()?["Course-$selectedUniversity$selectedCollege"][selectedCourse],
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.03,
                                    fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                              ),

                              children: [
                                SizedBox(
                                  width: size.width*0.25,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.data()?["Course-$selectedUniversity$selectedCollege"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["Course-$selectedUniversity$selectedCollege"][index],
                                          style: GoogleFonts.tiltNeon(
                                              color: Colors.black,
                                              fontSize: size.width*0.03,
                                              fontWeight: FontWeight.w500
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: (){
                                          setState(() {
                                            courseController.collapse();
                                            selectedCourse = index;

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
                          width: size.width*0.3,

                          child: Card(
                            color: Colors.white,
                            child: ExpansionTile(
                              controller: collegeController,
                              title: AutoSizeText(

                                snapshot.data!.data()?["College-$selectedUniversity"][selectedCollege],
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.03,
                                    fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                              ),

                              children: [
                                SizedBox(
                                  width: size.width*0.25,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.data()?["College-$selectedUniversity"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["College-$selectedUniversity"][index],
                                          style: GoogleFonts.tiltNeon(
                                              color: Colors.black,
                                              fontSize: size.width*0.03,
                                              fontWeight: FontWeight.w500
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: (){
                                          setState(() {
                                            collegeController.collapse();
                                            selectedCollege = index;
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
                          width: size.width*0.27,
                          child: Card(
                            color: Colors.white,
                            child: ExpansionTile(
                              controller: universityController,
                              title: AutoSizeText(
                                snapshot.data!.data()?["University"][selectedUniversity],
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.03,
                                    fontWeight: FontWeight.w500
                                ),
                                maxLines: 1,
                              ),
                              children: [
                                SizedBox(
                                  width: size.width*0.25,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.data()?["University"].length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          snapshot.data!.data()?["University"][index],
                                          style: GoogleFonts.tiltNeon(
                                              color: Colors.black,
                                              fontSize: size.width*0.03,
                                              fontWeight: FontWeight.w500
                                          ),
                                          maxLines: 1,
                                        ),
                                        onTap: (){
                                          setState(() {
                                            universityController.collapse();
                                            selectedUniversity = index;

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
                )
              ],
            )
                :
                    const SizedBox()
                :
            const SizedBox();
          }
        )
    );
  }

}
