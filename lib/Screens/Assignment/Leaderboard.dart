import 'package:auto_size_text/auto_size_text.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    call();
  }
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
        if(!load){
          calculateResult();
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


  call() async {
    await calculateResult().whenComplete((){
      setState(() {
        load=true;
      });
    });
  }
  Future<void> calculateResult() async {
    result=[];
    int submitted=0;
    final snap = await FirebaseFirestore
        .instance
        .collection("Assignment")
        .doc(
        "${widget.university.split(" ")[0]} ${widget.college.split(" ")[0]} ${widget.course.split(" ")[0]} ${widget.branch.split(" ")[0]} ${widget.year} ${widget.section} ${widget.subject}"
    )
        .get();
    final allStudentsdata = await FirebaseFirestore.
    instance.
    collection("Students").
    where("Subject", arrayContains: widget.subject).
    where("University",isEqualTo: widget.university).
    where("Year",isEqualTo: widget.year).
    where("Branch",isEqualTo: widget.branch).
    where("College",isEqualTo: widget.college).
    where("Section",isEqualTo: widget.section).
    where("Course",isEqualTo: widget.course).
    get();
    int lop=1;
    for(var email in  allStudentsdata.docs)
    {
      print(lop++);
        Map<String,dynamic>data={};
        data["Name"]=email.data()["Name"];
        data["Rollnumber"]=email.data()["Rollnumber"];
        data["Score"]=0;
        data["Quiz-Time"]= Timestamp(0,0);
        data["Email"]=email.data()["Email"];
        int stop= snap.data()?["Total_Assignment"] ?? 0;
        for(int i=1;i<= stop;i++){
          if(snap.data()?["Assignment-$i"]['Submitted-by']!=null && snap.data()?["Assignment-$i"]['Submitted-by'].contains(email.data()["Email"]) ){
            if(snap.data()?["Assignment-$i"]['submitted-Assignment'][email.data()['Email'].toString().split('@')[0]]['Status']=="Accepted"){
              data["Score"]++;
              submitted++;
              data["Quiz-Time"]=snap.data()?["Assignment-$i"]['submitted-Assignment'][email.data()['Email'].toString().split('@')[0]]['Time'];
            }
          }

        }
        result.add(data);
    }
    sortResult();
      averageSubmission = (submitted/snap.data()?["Total_Assignment"]).round();
  }
  sortResult(){
    result.sort((a, b) {
        return a["Score"].compareTo(b["Score"]);
      },
    );

    result.sort((a,b) {
      if(a["Score"]==b["Score"])
      {
        return int.parse(a["Rollnumber"]).compareTo(int.parse(b["Rollnumber"]));
      }
      else{
        return 0;
      }
    });
  }
}
