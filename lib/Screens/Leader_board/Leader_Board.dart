import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Constraints.dart';
import '../Assignment/Top3_Leaderboard_tile.dart';

class OverAllLeaderBoard extends StatefulWidget {
  const OverAllLeaderBoard({super.key});

  @override
  State<OverAllLeaderBoard> createState() => _OverAllLeaderBoardState();
}

class _OverAllLeaderBoardState extends State<OverAllLeaderBoard> {
  List<Map<String,dynamic>>result=[];
  double averagePerformance=0;
  bool load = false;
  int total=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateResult();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: load ?
      Column(
        children: [
          TopThree(
            data: [
              {
                "Name" : result[0]['Name'],
                "Email" : result[0]['Email'],
                "Submitted" : result[0]['Score'],
                "outOf" : 1,

              },
              {
                "Name" : result[1]['Name'],
                "Email" : result[1]['Email'],
                "Submitted" : result[1]['Score'],
                "outOf" : 1,

              },
              {
                "Name" : result[2]['Name'],
                "Email" : result[2]['Email'],
                "Submitted" : result[2]['Score'],
                "outOf" : 1,

              }
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                return  ListTile(
                  title: AutoSizeText("${result[index]["Name"]}",),
                );
                },
            ),
          )
        ],
      )
          :
          const loading(text: "Fetching"),
    );
  }
  calculateResult() async {
    result.clear();
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
      int totalAssignment=0;
      Map<String,dynamic>data={};
      double gainedPercent=0;
     
      
      double totalpercent=0;
      int assignmentSubmitted=0;

        final snap = await FirebaseFirestore.instance.collection("Assignment").doc(
          "${university_filter.toString().split(" ")[0]} "
          "${college_filter.toString().split(" ")[0]} "
          "${course_filter.toString().split(" ")[0]} "
          "${branch_filter.toString().split(" ")[0]} "
          "${year_filter.toString().split(" ")[0]} "
          "${section_filter.toString().split(" ")[0]} "
          "${subject_filter.toString().split(" ")[0]}"

        ).get();
        int stop= snap.data()?["Total_Assignment"] ?? 0;
        for(int i=1;i<= stop;i++){
          if(snap.data()?["Assignment-$i"]['Submitted-by']!=null && snap.data()?["Assignment-$i"]['Submitted-by'].contains(email.data()["Email"])){
            assignmentSubmitted++;
          }
          totalAssignment++;
        }

      gainedPercent +=assignmentSubmitted/totalAssignment;
        print("Assignmetn : $gainedPercent");
      totalpercent++;
      ///for attendance 
      int totalPresent=0;
      int totalLecture=0;
      print(email.data()["Email"]);
      await FirebaseFirestore.instance.collection("Students").doc(email.data()["Email"]).collection("Attendance").get().then((value) {

        for(int i=0;i<value.docs.length ;i++){
          print("doclen : ${value.docs[i].data()}");
          for(int day=0;day<32;day++){
            print(value.docs[i].data()["$day"]);
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
        gainedPercent+= totalPresent/totalLecture;
        print("Attendance: $gainedPercent");
        totalpercent++;


        data["Score"]=gainedPercent/totalpercent;
        data["Name"]=email.data()["Name"];
        data["Rollnumber"]=email.data()["Rollnumber"];
        data["Email"]=email.data()["Email"];
        result.add(data);
      });

    }
    sortResult();
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
