import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Screens/Assignment/Top3_Leaderboard_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentsOverAllLeaderBoard extends StatefulWidget {
  const AssignmentsOverAllLeaderBoard({super.key, required this.university, required this.college, required this.course, required this.branch, required this.year, required this.section, required this.subject});
  final String university;
  final String college;
  final String course;
  final String branch;
  final String year;
  final String section;
  final String subject;
  @override
  State<AssignmentsOverAllLeaderBoard> createState() => _AssignmentsOverAllLeaderBoardState();
}

class _AssignmentsOverAllLeaderBoardState extends State<AssignmentsOverAllLeaderBoard> {
  List<Map<String,dynamic>>result=[];
  int averageSubmission=0;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore
          .instance
          .collection("Assignment")
          .doc(
          "${widget.university.split(" ")[0]} ${widget.college.split(" ")[0]} ${widget.course.split(" ")[0]} ${widget.branch.split(" ")[0]} ${widget.year} ${widget.section} ${widget.subject}"
      )
          .snapshots(),
      builder: (context, snapshot) {
       if(snapshot.hasData && !load){
           calculateResult(snapshot);
           load=false;
       }

        return snapshot.hasData && load
            ?
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TopThree(
                data: [
                  {
                    "Name" : result[0]['Name'],
                    "Email" : result[0]['Email'],
                    "Submitted" : result[0]['Score'],
                  },
                  {
                    "Name" : result[1]['Name'],
                    "Email" : result[1]['Email'],
                    "Submitted" : result[1]['Score'],
                  },
                  {
                    "Name" : result[2]['Name'],
                    "Email" : result[2]['Email'],
                    "Submitted" : result[2]['Score'],
                  }
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText("Average Submission/Assignment: ",
                        style: GoogleFonts.tiltNeon(
                            color: Colors.black,
                            fontSize: size.width*0.05
                        ),),
                      AutoSizeText("$averageSubmission",
                        style: GoogleFonts.tiltNeon(
                            color: Colors.green[900],
                            fontSize: size.width*0.06
                        ),),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.022,
              ),
              Column(
                  children: [
                    SizedBox(
                        height: size.height * 0.095*(result.length),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(size.height * 0.008),
                              child: SizedBox(
                                height: size.height * 0.08,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.1,
                                      child: Center(
                                          child: AutoSizeText(
                                              "${index+1}",
                                              style: GoogleFonts.tiltNeon(
                                                  fontSize: size.height*0.03,
                                                  color: Colors.black
                                              )
                                          )),
                                    ),
                                    Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(size.width * 0.08)),
                                        color: result[index]["Score"]*2 < snapshot.data!.data()?["Total_Assignment"] ? Colors.red[400] : Colors.green,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(size.height * 0.006),
                                            child: StreamBuilder(
                                              stream: FirebaseFirestore.instance.collection("Students").doc(result[index]["Email"]).snapshots(),
                                              builder: (context, studentsnapshot) {
                                                return studentsnapshot.hasData
                                                    ?
                                                CircleAvatar(
                                                    radius: size.width * 0.06,
                                                    backgroundColor: Colors.green[900],
                                                    child:  studentsnapshot.data!.data()?["Profile_URL"] !="null" && studentsnapshot.data!.data()?["Profile_URL"] != null
                                                        ?
                                                    CircleAvatar(
                                                      radius: size.width * 0.055,
                                                      backgroundImage: NetworkImage(studentsnapshot.data!.data()?["Profile_URL"]),
                                                    )
                                                        :
                                                    CircleAvatar(
                                                      radius: size.width * 0.055,
                                                      backgroundImage: const AssetImage("assets/images/unknown.png"),
                                                    )
                                                )
                                                    :
                                                const SizedBox();
                                              }
                                            ),
                                          ),
                                          Expanded(
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    result[index]["Name"],
                                                    style: GoogleFonts.tiltNeon(
                                                        color: Colors.black,
                                                        fontSize: size.width * 0.045),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  AutoSizeText(
                                                    result[index]["Rollnumber"],
                                                    style: GoogleFonts.tiltNeon(
                                                        color: Colors.black,
                                                        fontSize: size.width * 0.036),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              )
                                          ),
                                          AutoSizeText(
                                            "${result[index]["Score"]} / ${snapshot.data!.data()?["Total_Assignment"]}",
                                            style: const TextStyle(
                                              color:Color.fromARGB(255, 10, 52, 84),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width*0.04,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                        )
                    ),
                  ])
            ],
          ),
        )
            :
        SizedBox(
          height: size.height,
          width: size.width,
          child: Center(
            child: AutoSizeText(
              "You did not uploaded a single assignment till now.\nPlease upload the assignment.",
              style: GoogleFonts.tiltNeon(
                  fontSize: 20,
                  color: Colors.black
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      );
  }
  calculateResult(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) async {
    result.clear();
    int submitted=0;
    final allStudentsdata = await FirebaseFirestore.
    instance.
    collection("Students").
    where("Subject", arrayContains: subject_filter).
    where("University",isEqualTo: university_filter).
    where("Year",isEqualTo: year_filter).
    where("Branch",isEqualTo: branch_filter).
    where("College",isEqualTo: college_filter).
    where("Section",isEqualTo: section_filter).
    where("Course",isEqualTo: course_filter).
    get();
    for(var email in  allStudentsdata.docs)
    {
        Map<String,dynamic>data={};
        data["Name"]=email.data()["Name"];
        data["Rollnumber"]=email.data()["Rollnumber"];
        data["Score"]=0;
        int stop= snap.data!.data()?["Total_Assignment"] ?? 0;
        for(int i=1;i<= stop;i++){
          if(snap.data!.data()?["Assignment-$i"]['Submitted-by']!=null && snap.data!.data()?["Assignment-$i"]['Submitted-by'].contains(email.data()["Email"])){
            data["Score"]++;
            submitted++;
          }

        }
        data["Quiz-Time"]=
        data["Email"]=email.data()["Email"];
        result.add(data);
    }
    sortResult();
    setState(() {
      load=true;
      print(submitted/snap.data!.data()?["Total_Assignment"]);
      averageSubmission = (submitted/snap.data!.data()?["Total_Assignment"]).round();
    });
  }
  sortResult(){
    print("before: $result");
    result.sort((a, b) {
      print("a,b : $a $b");
      print("Compared ${a["Score"].compareTo(b["Score"])}");
        return a["Score"].compareTo(b["Score"]);
      },
    );
    result=result.reversed.toList();
    result.sort((a,b) {
      if(a["Score"]==b["Score"])
      {
        return int.parse(a["Rollnumber"]).compareTo(int.parse(b["Rollnumber"]));
      }
      else{
        return 0;
      }
    });

    print(result);
  }
}
