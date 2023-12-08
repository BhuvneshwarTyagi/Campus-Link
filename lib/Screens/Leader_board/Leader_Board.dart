import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import '../Assignment/Top3_Leaderboard_tile.dart';

class OverAllLeaderBoard extends StatefulWidget {
  const OverAllLeaderBoard({super.key});

  @override
  State<OverAllLeaderBoard> createState() => _OverAllLeaderBoardState();
}

class _OverAllLeaderBoardState extends State<OverAllLeaderBoard> {

  List<Map<String,dynamic>> result=[];
  double averagePerformance=0;
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateResult();
  }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: load ?
      ListView.builder(
        shrinkWrap: true,
        itemCount: result.length,
        itemBuilder: (context, index) {
          return  Column(
            children: [
              index==0 ?
                  Column(
                    children: [
                      TopThree(
                        data: [
                          {
                            "Name" : result[0]['Name'],
                            "Email" : result[0]['Email'],
                            "Submitted" : result[0]['Score']/100,
                          },
                          {
                            "Name" : result[1]['Name'],
                            "Email" : result[1]['Email'],
                            "Submitted" : result[1]['Score']/100,
                          },
                          {
                            "Name" : result[2]['Name'],
                            "Email" : result[2]['Email'],
                            "Submitted" : result[2]['Score']/100,
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
                              AutoSizeText("Average Performance: ",
                                style: GoogleFonts.tiltNeon(
                                    color: Colors.black,
                                    fontSize: size.width*0.05
                                ),),
                              AutoSizeText("${(averagePerformance).toStringAsFixed(2)}%",
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
                    ],
                  )
              :
                  const SizedBox(),
              Card(
                elevation: 25,
                shape: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  )
                ),
                child: ExpansionTile(
                  title: AutoSizeText("${result[index]["Name"]}",style: GoogleFonts.tiltNeon(
                    color: Colors.black,
                    fontSize: size.width*0.045,

                  ),
                  ),
                  subtitle: AutoSizeText("${result[index]["Rollnumber"]}",style: GoogleFonts.tiltNeon(
                    color: Colors.black45,
                    fontSize: size.width*0.045,

                  ),),
                  leading: SizedBox(
                    width: size.width*0.2,
                    child: Row(
                      children: [
                        AutoSizeText("${index+1}",style: GoogleFonts.tiltNeon(
                          color: Colors.black,
                          fontSize: size.width*0.06,

                        ),),
                        SizedBox(
                          width: size.width*0.02,
                        ),
                        CircleAvatar(
                            radius: size.width * 0.06,
                            backgroundColor: Colors.green[900],
                            child:  result[index]["Profile_URL"] !="null" && result[index]["Profile_URL"] != null
                                ?
                            CircleAvatar(
                              radius: size.width * 0.055,
                              backgroundImage: NetworkImage(result[index]["Profile_URL"]),
                            )
                                :
                            CircleAvatar(
                              radius: size.width * 0.055,
                              backgroundImage: const AssetImage("assets/images/unknown.png"),
                            )
                        ),
                      ],
                    ),
                  ),
                  trailing: SizedBox(
                    width: size.width*0.2,
                    child: Row(
                      children: [
                        AutoSizeText("${(result[index]["Score"]).toStringAsFixed(2)}%",style: GoogleFonts.tiltNeon(
                          color: (result[index]["Score"]) < 40
                              ?
                          Colors.red[600]
                              :
                          (result[index]["Score"])<75
                              ?
                          Colors.yellow[700]
                              :
                          Colors.green[900]
                          ,
                          fontSize: size.width*0.045,

                        ),

                        ),
                      ],
                    ),
                  ),
                  children: [
                    ListTile(
                      title: AutoSizeText("Attendance",style: GoogleFonts.tiltNeon(
                        color: Colors.black54,
                        fontSize: size.width*0.045,

                      ),),
                      trailing: AutoSizeText("${result[index]["AttendanceScore"].toStringAsFixed(2)}%",style: GoogleFonts.tiltNeon(
                        color: (result[index]["AttendanceScore"]) <50
                            ?
                        Colors.red[600]
                            :
                        (result[index]["AttendanceScore"])<75
                            ?
                        Colors.orangeAccent[300]
                            :
                        Colors.green[900]
                        ,
                        fontSize: size.width*0.045,

                      ),),
                    ),
                    ListTile(

                      title: AutoSizeText("Assignment",style: GoogleFonts.tiltNeon(
                        color: Colors.black54,
                        fontSize: size.width*0.045,

                      ),),
                      trailing: AutoSizeText("${result[index]["AssignmentScore"].toStringAsFixed(2)}%",style: GoogleFonts.tiltNeon(
                        color: result[index]["AssignmentScore"] < 50
                            ?
                        Colors.red[600]
                            :
                        result[index]["AssignmentScore"] < 75
                            ?
                        Colors.orangeAccent[300]
                            :
                        Colors.green[900]
                        ,
                        fontSize: size.width*0.045,

                      ),),
                    ),
                    ExpansionTile(

                      title: AutoSizeText("Sessional Marks",style: GoogleFonts.tiltNeon(
                        color: Colors.black54,
                        fontSize: size.width*0.045,

                      ),),
                      trailing: AutoSizeText("${result[index]["MarksScore"].toStringAsFixed(2)}%",style: GoogleFonts.tiltNeon(
                        color: result[index]["MarksScore"] < 50
                            ?
                        Colors.red[600]
                            :
                        result[index]["MarksScore"] < 75
                            ?
                        Colors.orangeAccent[300]
                            :
                        Colors.green[900]
                        ,
                        fontSize: size.width*0.045,

                      ),),
                      children: [
                        SizedBox(
                          height: size.height*0.15,
                          child: ListView.builder(
                            itemCount: result[index]["Sessional_record"].length,
                              itemBuilder: (context, index1) {
                                return ListTile(

                                  title: AutoSizeText(
                                    "Sessional ${index1+1} marks",
                                    style: GoogleFonts.tiltNeon(
                                      color: Colors.black54,
                                      fontSize: size.width*0.045,
                                    ),
                                  ),
                                  trailing: AutoSizeText("${result[index]["Sessional_record"][index1]["obtainedMarks"]}/${result[index]["Sessional_record"][index1]["totalMarks"]}",style: GoogleFonts.tiltNeon(
                                    color: result[index]["AssignmentScore"] < 50
                                        ?
                                    Colors.red[600]
                                        :
                                    result[index]["AssignmentScore"] < 75
                                        ?
                                    Colors.orangeAccent[300]
                                        :
                                    Colors.green[900]
                                    ,
                                    fontSize: size.width*0.045,

                                  ),),
                                );
                              },),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
          },
      )
          :
      const loading(text: "Fetching"),
    );
  }




  calculateResult() async {
    result.clear();
    double allStudentsPerformancesum=0;
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
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance.collection("Assignment").doc(
        "${university_filter.toString().split(" ")[0]} "
            "${college_filter.toString().split(" ")[0]} "
            "${course_filter.toString().split(" ")[0]} "
            "${branch_filter.toString().split(" ")[0]} "
            "${year_filter.toString().split(" ")[0]} "
            "${section_filter.toString().split(" ")[0]} "
            "${subject_filter.toString().split(" ")[0]}"

    ).get();
      for(var email in  allStudentsdata.docs) {
     // print("${email.data()["Email"]}");
      Map<String, dynamic> data = {};
      data["Name"] = email.data()["Name"];
      data["Rollnumber"] = email.data()["Rollnumber"];
      data["Email"] = email.data()["Email"];
      data["Profile_URL"] = email.data()["Profile_URL"];

        await calculateAssignment(email, data,snap).then((data1) async {
          print("Data from Assignement ////////////////////////: $data1");
          await calculateAttendance(email, data1).then((data2) async {
            print("Data from attendance ////////////////////////: $data2");
            await calculateMarks(email, data2).then((value){
              result.add(value);
              allStudentsPerformancesum += value['Score'];
            });

        });
      });
    }
    //print("problem : ${email.data()["Email"]}");
    averagePerformance=allStudentsPerformancesum/allStudentsdata.docs.length;
    sortResult();
  }




  Future<Map<String, dynamic>> calculateAttendance(QueryDocumentSnapshot<Map<String, dynamic>> email,Map<String,dynamic> data) async {
    int totalPresent=0;
    int totalLecture=0;
    await FirebaseFirestore.instance.collection("Students").doc(email.data()["Email"]).collection("Attendance").get().then((value) {

      for(int i=0;i<value.docs.length ;i++){
       // print("doclen : ${value.docs[i].data()}");
        for(int day=0;day<32;day++){
         // print(value.docs[i].data()["$day"]);
          if(value.docs[i].data()["$day"] != null){
            for(int attendance =0; attendance<value.docs[i].data()["$day"].length;attendance++){
              if(value.docs[i].data()["$day"][attendance]["Status"]=="Present"){
                totalPresent++;
              }
              totalLecture++;
            }
          }
        }
      }
    }).whenComplete(() {

      data["AttendanceScore"] = (totalPresent/totalLecture)*100;
      data["Attendance"]=totalPresent;
      data["TotalLecture"] = totalLecture;
      data['Score']+=(totalPresent/totalLecture)*100;
    });
    return data;
  }
  Future<Map<String, dynamic>> calculateMarks(QueryDocumentSnapshot<Map<String, dynamic>> email,Map<String,dynamic> data) async {
    int obtainedMarks=0;
    int totalMarks=0;
    data["Sessional_record"] = [];
    await FirebaseFirestore.instance.collection("Students").doc(email.data()["Email"]).get().then((doc) {
      print(doc.data());
      if(doc.data()?["Marks"] != null && doc.data()?["Marks"][subject_filter] != null){
        for(int i=1;i<=doc.data()!["Marks"][subject_filter]["Total"];i++){
          obtainedMarks = doc.data()?["Marks"][subject_filter]["Sessional_$i"];
          totalMarks = doc.data()?["Marks"][subject_filter]["Sessional_${i}_total"];
          data["Sessional_record"].add({
            "obtainedMarks" : doc.data()?["Marks"][subject_filter]["Sessional_$i"],
            "totalMarks" : doc.data()?["Marks"][subject_filter]["Sessional_${i}_total"],
          });
        }
      }
    }).whenComplete(() {

      data["MarksScore"] = (obtainedMarks/totalMarks)*100;
      data["TotalMarks"]=obtainedMarks;
      data["ObtainedMarks"] = totalMarks;
      data['Score']+=(obtainedMarks/totalMarks)*100;
      data['Score']/=3;
    });
    return data;
  }




  Future<Map<String, dynamic>> calculateAssignment(QueryDocumentSnapshot<Map<String, dynamic>> email,Map<String,dynamic> data, DocumentSnapshot<Map<String, dynamic>> snap) async {
    int totalAssignment=0;
    int assignmentSubmitted=0;


      int stop= snap.data()?["Total_Assignment"] ?? 0;

      for(int i=1;i<= stop;i++){
        print("Ok $i");
        if(snap.data()?["Assignment-$i"]['Submitted-by']!=null && snap.data()?["Assignment-$i"]['Submitted-by'].contains(email.data()["Email"])){
          assignmentSubmitted++;
        }
        totalAssignment++;
      }
      data["AssignmentScore"] = (assignmentSubmitted/totalAssignment)*100;
      data["SubmittedAssignment"]=assignmentSubmitted;
      data["TotalAssignment"] = totalAssignment;
      data['Score']=(assignmentSubmitted/totalAssignment)*100;
    return data;
  }

  sortResult(){
    result.sort((a, b) {
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
    setState(() {

      result;
      load=true;
    });
  }
}
