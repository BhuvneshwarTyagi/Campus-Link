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
    return Container(
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
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Teachers Id")
            .doc("$selectedUniversity $selectedCollege $selectedCourse $selectedBranch")
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.data!=null && snapshot.hasData
              ?
          ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.data()?["Assigned subject"].length,
            itemBuilder: (context, index) {
              print(index);
              return  Card(
                shape: Border.all(
                    color: Colors.black,
                    width: 1
                ),
                child: ExpansionTile(
                  backgroundColor: Colors.white12,
                  collapsedBackgroundColor: Colors.white12,
                  leading: Column(
                    children: [
                      SizedBox(
                        height: size.height*0.013,
                      ),
                      AutoSizeText("${snapshot.data!.data()?["Assigned subject"][index]["Name"]}",style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: size.height*0.02,
                          fontWeight: FontWeight.w500
                      ),),
                      AutoSizeText("${snapshot.data!.data()?["Assigned subject"][index]["Employee Id"]}"),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.041),
                  title: AutoSizeText(""),
                  children: [
                    ListTile(
                      leading: AutoSizeText("Year",
                        style:GoogleFonts.openSans(
                            fontSize: size.height*0.02,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ) ,
                      ),
                      trailing: Container(
                        height: size.height*0.045,
                        width: size.width*0.17,
                        decoration:BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(size.height*0.012)),
                            border: Border.all(
                                color: Colors.black,
                                width: 2
                            )
                        ),
                        child:Center(
                          child: AutoSizeText(
                              "${snapshot.data!.data()?["Assigned subject"][index]["Year"]}"
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: AutoSizeText("Section",
                        style:GoogleFonts.openSans(
                            fontSize: size.height*0.02,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ) ,
                      ),
                      trailing: Container(
                        height: size.height*0.045,
                        width: size.width*0.17,
                        decoration:BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(size.height*0.012)),
                            border: Border.all(
                                color: Colors.black,
                                width: 2
                            )
                        ),
                        child:Center(
                          child: AutoSizeText(
                              "${snapshot.data!.data()?["Assigned subject"][index]["Section"]}"
                          ),
                        ) ,
                      ),
                    ),
                    ListTile(
                      leading: AutoSizeText(
                        "Subject",
                        style:GoogleFonts.openSans(
                            fontSize: size.height*0.02,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ) ,
                      ),
                      trailing: Container(
                        height: size.height*0.045,
                        width: size.width*0.4,
                        decoration:BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(size.height*0.012)),
                            border: Border.all(
                                color: Colors.black,
                                width: 2
                            )
                        ),
                        child:Center(
                          child: AutoSizeText(
                              "${snapshot.data!.data()?["Assigned subject"][index]["Subject"]}"
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    InkWell(
                      onTap: () async {
                        /* await FirebaseFirestore.instance.collection("Subject").doc("${usermodel["HOD Branch"]}").get().then((value) async {
                        value.data()!=null
                        ?
                        await FirebaseFirestore.instance.collection("Subject").doc("${usermodel["HOD Branch"]}").set(
                            {
                              "Subject": FieldValue.arrayUnion([subjectController.text.trim()])
                            })
                        :
                        await FirebaseFirestore.instance.collection("Subject").doc("${usermodel["HOD Branch"]}").update(
                        {
                        "Subject": FieldValue.arrayUnion([subjectController.text.trim()])
                        });
                      });
                    */

                        //......................................

                          await FirebaseFirestore.instance.collection("Teachers Id")
                              .doc("$selectedUniversity $selectedCollege $selectedCourse $selectedBranch")
                              .update({
                            "Teachers":FieldValue.arrayUnion([{
                              "Email":snapshot.data!.data()?["Assigned subject"][index]["Email"],
                              "Name":snapshot.data!.data()?["Assigned subject"][index]["Name"],
                              "Employee Id":snapshot.data!.data()?["Assigned subject"][index]["Employee Id"]
                            }])
                          });

                      },
                      child: Container(
                        height: size.height*0.043,
                        width: size.width*0.22,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(size.height*0.012))
                        ),
                        child: Center(
                          child: AutoSizeText(
                            "Edit",style: GoogleFonts.openSans(
                              color: Colors.red,
                              fontSize: size.height*0.022
                          ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                  ],
                ),
              );
            },)
              :
          const SizedBox();
        },
      ),
    );

    /*SizedBox(
      width: size.width,
      height: size.height*0.5,
      child: Stack(
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
                      .where("Year",isEqualTo: selectedYear.toString())
                      .where("Subject", arrayContains: selectedSubject)
                      .where("Section",isEqualTo: selectedSection)
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
    );*/
  }
}
