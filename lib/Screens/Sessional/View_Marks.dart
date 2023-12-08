import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class ViewMarks extends StatefulWidget {
  const ViewMarks({super.key});

  @override
  State<ViewMarks> createState() => _ViewMarksState();
}

class _ViewMarksState extends State<ViewMarks> {
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection("Students")
            .where("University",isEqualTo: university_filter)
            .where("College",isEqualTo: college_filter)
            .where("Course",isEqualTo: course_filter)
            .where("Branch",isEqualTo: branch_filter)
            .where("Year",isEqualTo: year_filter)
            .where("Section",isEqualTo: section_filter)
            .where("Subject",arrayContains: subject_filter)
            .snapshots(),
        builder: (context, snapshot) {

          return snapshot.hasData
              ?
          ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {

              return Card(
                elevation: 30,
                child: ExpansionTile(
                  leading: CircleAvatar(
                      radius: size.width * 0.06,
                      backgroundColor: Colors.green[900],
                      child:  snapshot.data?.docs[index].data()["Profile_URL"] !="null" && snapshot.data?.docs[index].data()["Profile_URL"] != null
                          ?
                      CircleAvatar(
                        radius: size.width * 0.055,
                        backgroundImage: NetworkImage(snapshot.data?.docs[index].data()["Profile_URL"]),
                      )
                          :
                      CircleAvatar(
                        radius: size.width * 0.055,
                        backgroundImage: const AssetImage("assets/images/unknown.png"),
                      )
                  ),
                  title: AutoSizeText(
                    snapshot.data?.docs[index].data()["Name"],
                    style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.05,
                        color: Colors.black
                    ),
                  ),
                  subtitle: AutoSizeText(
                    snapshot.data?.docs[index].data()["Rollnumber"],
                    style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.035,
                        color: Colors.black87
                    ),
                  ),
                  children: [
                    Container(
                      height: size.height*0.2,
                      color: Colors.black26,
                      child: ListView.builder(
                        itemCount: snapshot.data?.docs[index].data()["Marks"][subject_filter]["Total"],
                        itemBuilder: (context, index2) {
                          return ListTile(
                            title: AutoSizeText(
                              "Sessional ${index2+1}",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.width*0.05,
                                  color: Colors.black
                              ),
                            ),
                            trailing: AutoSizeText(
                             "${ snapshot.data?.docs[index].data()["Marks"][subject_filter]["Sessional_${index2+1}"]}/${snapshot.data?.docs[index].data()["Marks"][subject_filter]["Sessional_${index2+1}_total"]}",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.width*0.05,
                                  color: Colors.black
                              ),
                            ),
                          );
                      },),
                    )
                  ],
                ),
              );
            },
          )
              :
          const SizedBox();
        },
      ),
    );
  }
}
