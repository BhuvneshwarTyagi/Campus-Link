import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Attendance.dart';


class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(

        stream: FirebaseFirestore
            .instance
            .collection("Students")
            .where("University", isEqualTo: university_filter)
            .where("College",isEqualTo: college_filter)
            .where("Course",isEqualTo: course_filter)
            .where("Branch",isEqualTo: branch_filter)
            .where("Year",isEqualTo: year_filter)
            .where("Section",isEqualTo: section_filter)
            .where("Subject",arrayContains: subject_filter).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          return snapshot.hasData
              ?
          ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index)  {

              return Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    //color: const Color.fromRGBO(12, 12, 12, 1).withOpacity(0.6),
                    border: Border.all(color: Colors.black,width: 1.5),
                    gradient: const LinearGradient(colors: [
                      Colors.black87,
                      Colors.black45
                    ]),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        blurStyle: BlurStyle.outer,
                        color: Colors.white.withOpacity(0.6),
                        offset: Offset(0, 0),
                      )
                    ]
                ),
                margin: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        Text(snapshot.data.docs[index]["Name"],style: GoogleFonts.exo(color: Colors.white)),
                        SizedBox(
                          height: size.height*0.01,
                        ),
                        Text(snapshot.data.docs[index]["Rollnumber"],style: GoogleFonts.exo(color: Colors.white)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () async{
                              await FirebaseFirestore.instance.collection("Students").doc(snapshot.data.docs[index]["Email"]).update(
                                  {"Active" : true,
                                    "Location": GeoPoint(tecloc.latitude, tecloc.longitude)
                                  },
                              );
                            },
                            icon: Icon(Icons.check,color: !snapshot.data.docs[index]["Active"]
                                ?
                            const Color.fromRGBO(150, 150, 150, 1)
                                :
                            Colors.green,size: 28),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.03,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          )
              :
          const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
        },
      ),
    );
  }
}
