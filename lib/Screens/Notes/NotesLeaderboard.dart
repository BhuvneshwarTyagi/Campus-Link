import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';

class SubjectQuizScore extends StatefulWidget {
  const SubjectQuizScore({Key? key,required this.subject}) : super(key: key);
  final String subject;

  @override
  State<SubjectQuizScore> createState() => _SubjectQuizScoreState();
}

class _SubjectQuizScoreState extends State<SubjectQuizScore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/celebration.gif"),fit: BoxFit.fill)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          body: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").snapshots(),
                builder: (context, snapshot) {
                  print("${snapshot.data?.data()?["${usermodel["Email"]}"]}");
                  return  snapshot.hasData
                     ?
                     NotesLeaderBoard(snap: snapshot, subject: widget.subject,)
                      :
                      const SizedBox(
                        child: Center(child: Text("No Data Found")),
                      );
                },
              )),
    );
  }
}





class NotesLeaderBoard extends StatefulWidget {
   const NotesLeaderBoard({super.key,required this.snap,required this.subject});
   final String subject;
   final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap;
  @override
  State<NotesLeaderBoard> createState() => _NotesLeaderBoardState();
}

class _NotesLeaderBoardState extends State<NotesLeaderBoard> {
  List<Map<String,dynamic>>result=[];
  List<Map<String,dynamic>>unattemptedStudents=[];
  late DocumentSnapshot<Map<String, dynamic>>? snapshot;
  bool load=false;
  Map<String,dynamic>allEmailsWithLink={};
  late QuerySnapshot<Map<String, dynamic>> allStudentsData;
  List<Map<String,dynamic>>allEmail=[];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setState(() {
      snapshot=widget.snap.data;
    });
    fetchEmail().whenComplete(() {
      calculateResult().whenComplete(() {
        setState(() {
          load=true;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    print("load: $load && result: $result");
    return load && result.isNotEmpty
            ?
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
              height: size.height * 0.32,
              child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.07,
                    ),
                    SizedBox(
                        width: size.width * 0.214,
                        child: Column(children: [
                          SizedBox(
                              height: ((size.height * 0.12) + (size.width * 0.214)),
                              child: Stack(children: [
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: size.width * 0.107,
                                      child: allEmailsWithLink[
                                        result.length>1 ?
                                        result[1]["Email"] : ""]!="null" && allEmailsWithLink[
                                      result.length>1 ?
                                      result[1]["Email"] : ""] != null
                                          ?
                                      CircleAvatar(
                                        backgroundColor: Colors.green[600],
                                        radius: size.width * 0.1,
                                        backgroundImage: NetworkImage("${allEmailsWithLink[result[1]["Email"]]}")
                                      )
                                          :
                                      CircleAvatar(
                                        backgroundColor: Colors.green[600],
                                        radius: size.width * 0.1,
                                        backgroundImage: const AssetImage("assets/images/unknown.png"),
                                      )

                                    ),
                                ),
                                Positioned(
                                    top: ((size.height * 0.12) - (size.width * 0.03)),
                                    left: ((size.width * 0.107) - (size.width * 0.03)),
                                    child: CircleAvatar(
                                        radius: size.width * 0.03,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                            radius: size.width * 0.026,
                                            child: const SizedBox(
                                                child: AutoSizeText(
                                                  '2',
                                                  textAlign: TextAlign.center,
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                              ],
                              ),
                          ),
                          SizedBox(
                            height: size.height*0.01,
                          ),
                          Center(
                              child: SizedBox(
                                  width: size.width * 0.2,
                                  child: AutoSizeText(
                                    result.length>1
                                        ?
                                    "${result[1]["Name"]}\n ${result[1]["Rollnumber"]}"
                                        :
                                    "Unknown"
                                    ,
                                    style: GoogleFonts.tiltNeon(
                                        fontSize: size.width*0.04,
                                      color: Colors.black
                                  ),

                                    textAlign: TextAlign.center,
                                  ),
                              ),
                          ),
                          AutoSizeText(
                              result.length >1
                                  ?
                              "${result[1]["Score"].toString()} / 10"
                                  :
                              "0 / 10",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 10, 52, 84),
                                  fontWeight: FontWeight.w500,
                              ),
                          ),
                        ],
                        ),
                    ),
                    SizedBox(
                      width: size.width * 0.069,
                    ),
                    SizedBox(
                        width: size.width * 0.294,
                        child: Column(
                            children: [
                              SizedBox(
                                  height: ((size.height * 0.05) + (size.width * 0.294)),
                                  child: Stack(
                                      children: [
                                        Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: CircleAvatar(
                                              radius: size.width * 0.147,
                                              backgroundColor: Colors.black,
                                              child:  allEmailsWithLink[result.isNotEmpty ? result[0]["Email"] : ""]!="null" && allEmailsWithLink[result.isNotEmpty ? result[0]["Email"] : ""]!= null
                                                  ?
                                              CircleAvatar(
                                                backgroundColor: Colors.green[600],
                                                radius: size.width * 0.14,
                                                backgroundImage: NetworkImage("${allEmailsWithLink[result[0]["Email"]]}")

                                              ,
                                              )
                                              :
                                              CircleAvatar(
                                                backgroundColor: Colors.green[600],
                                                radius: size.width * 0.14,
                                                backgroundImage: const AssetImage("assets/images/unknown.png"),
                                              )
                                            ),
                                        ),
                                        Positioned(
                                            top: ((size.height * 0.05) - (size.width * 0.03)),
                                            left: ((size.width * 0.147) - (size.width * 0.03)),
                                            child: CircleAvatar(
                                                radius: size.width * 0.03,
                                                backgroundColor: Colors.black,
                                                child: CircleAvatar(
                                                    radius: size.width * 0.026,
                                                    child: const SizedBox(
                                                        child: AutoSizeText(
                                                          '1',
                                                          textAlign: TextAlign.center,
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ),
                                      ],
                                  ),
                              ),
                              SizedBox(
                                height: size.height*0.01,
                              ),
                              Center(
                                  child: SizedBox(
                                      width: size.width * 0.24,
                                      child: AutoSizeText(
                                        result.isNotEmpty ? "${result[0]["Name"]}\n ${result[0]["Rollnumber"]}" : "Unknown",
                                        style: GoogleFonts.tiltNeon(
                                          color: Colors.black,
                                            fontSize: size.width * 0.05,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                  ),
                              ),
                              AutoSizeText("${result[0]["Score"].toString()} / 10",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 10, 52, 84),
                                      fontWeight: FontWeight.w500,
                                  ),
                              ),
                            ],
                        ),
                    ),
                    SizedBox(
                      width: size.width * 0.069,
                    ),
                    SizedBox(
                        width: size.width * 0.214,
                        child: Column(
                            children: [
                              SizedBox(
                                height: ((size.height * 0.12) + (size.width * 0.214)),
                                child: Stack(
                                    children: [
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: size.width * 0.107,
                                            child:  allEmailsWithLink[result.length>2 ? result[2]["Email"] : ""]!="null" && allEmailsWithLink[result.length>2 ? result[2]["Email"] : ""]!= null
                                                ?
                                            CircleAvatar(
                                              radius: size.width * 0.1,
                                              backgroundColor: Colors.green[600],
                                              backgroundImage: NetworkImage("${allEmailsWithLink[result[2]["Email"]]}")

                                            )
                                                :
                                            CircleAvatar(
                                              radius: size.width * 0.1,
                                              backgroundColor: Colors.green[600],
                                              backgroundImage: const AssetImage("assets/images/unknown.png")

                                            )
                                          ),
                                      ),

                                      Positioned(
                                          top: ((size.height * 0.12) - (size.width * 0.03)),
                                          left: ((size.width * 0.107) - (size.width * 0.03)),
                                          child: CircleAvatar(
                                              radius: size.width * 0.03,
                                              backgroundColor: Colors.black,
                                              child: CircleAvatar(
                                                  radius: size.width * 0.026,
                                                  child: const SizedBox(
                                                      child: AutoSizeText(
                                                        '3',
                                                        textAlign: TextAlign.center,
                                                      ),
                                                  ),
                                              ),
                                          ),
                                      ),
                                    ],
                                ),
                              ),
                              SizedBox(
                                height: size.height*0.01,
                              ),
                              SizedBox(
                                  width: size.width * 0.2,
                                  child: AutoSizeText(
                                    result.length > 2
                                        ?
                                    "${result[2]["Name"]}\n ${result[2]["Rollnumber"]}"
                                        :
                                    "Unknown"
                                    ,
                                    style: GoogleFonts.tiltNeon(
                                      color: Colors.black,
                                        fontSize: size.width * 0.04,
                                        ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                              ),
                              AutoSizeText(
                                  result.length>2
                                      ?
                                  "${result[2]["Score"].toString()} / 10"
                                      :
                                  "0 / 10",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 10, 52, 84),
                                      fontWeight: FontWeight.w500))
                            ],
                        ),
                    ),
                  ],
              ),
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
                  AutoSizeText("Attempted Students: ",
                    style: GoogleFonts.tiltNeon(
                        color: Colors.black,
                        fontSize: size.width*0.05
                    ),),
                  AutoSizeText("${result.length}/${allStudentsData.docs.length}",
                    style: GoogleFonts.poppins(
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
                                      color: const Color.fromARGB(255, 228, 243, 247),
                                    ),
                                    child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(size.height * 0.006),
                                            child: CircleAvatar(
                                              radius: size.width * 0.06,
                                              backgroundColor: Colors.green[900],
                                              child:  allEmailsWithLink[result[index]["Email"]]!="null"
                                                  ?
                                              CircleAvatar(
                                                radius: size.width * 0.055,
                                                backgroundImage: NetworkImage("${allEmailsWithLink[result[index]["Email"]]}"),
                                              ):
                                              AutoSizeText(
                                                result[index]["Name"].toString().substring(0,1),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.tiltNeon(
                                                  color: Colors.white,
                                                  fontSize: size.width*0.07
                                                ),
                                              ),),
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
                                            "${result[index]["Score"].toString()} / 10",
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
                unattemptedStudents.isNotEmpty
                    ?
                Column(
                  children: [
                    Divider(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height * 0.03,
                      thickness: MediaQuery.of(context).size.height * 0.003,
                      endIndent: 8,
                      indent: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            AutoSizeText("Unattempted Students : ",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: size.width*0.05
                              ),
                            ),
                            AutoSizeText("${unattemptedStudents.length}/${allStudentsData.docs.length}",
                              style: GoogleFonts.poppins(
                                  color: Colors.red[900],
                                  fontSize: size.width*0.06
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        height: size.height * 0.096*(unattemptedStudents.length),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:unattemptedStudents.length,
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
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height: size.height * 0.07,
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.5,
                                            color: Colors.black
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(size.width * 0.08)),
                                        color: const Color.fromARGB(255, 228, 243, 247),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(size.height * 0.006),
                                            child: CircleAvatar(
                                              radius: size.width * 0.06,
                                              backgroundColor: Colors.red[200],
                                              child:  allEmailsWithLink[unattemptedStudents[index]["Email"]]!="null"
                                                  ?
                                              CircleAvatar(
                                                radius: size.width * 0.055,
                                                backgroundImage: NetworkImage("${allEmailsWithLink[unattemptedStudents[index]["Email"]]}"),
                                              ):
                                              AutoSizeText(
                                                unattemptedStudents[index]["Name"][0],
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.tiltNeon(
                                                    color: Colors.black,
                                                    fontSize: size.width*0.08
                                                ),
                                              ),),
                                          ),
                                          Expanded(
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    unattemptedStudents[index]["Name"],
                                                    style: GoogleFonts.tiltNeon(
                                                        color: Colors.black,
                                                        fontSize: size.width * 0.045),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  AutoSizeText(
                                                    unattemptedStudents[index]["Roll-number"],
                                                    style: GoogleFonts.tiltNeon(
                                                        color: Colors.black,
                                                        fontSize: size.width * 0.036),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.left,
                                                  )
                                                ],
                                              )
                                          ),

                                          const AutoSizeText("UA",
                                            style: TextStyle(
                                              color:Colors.red,
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
                    )
                  ],
                )
                    :
                    const SizedBox()
              ])
        ],
      ),
    )
        :
        SizedBox(
          height: size.height,
            width: size.width,
            // decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [
            //         Colors.blue,
            //         Colors.purpleAccent,
            //       ],
            //     )
            // ),
            child: Center(
                child: AutoSizeText(
                    "You did not uploaded a single quiz till now.\nPlease upload the quiz.",
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
  Future<void> calculateResult() async {
    result.clear();
    for(var email in  allEmail)
    {
      print("Email is present : $email");
      if(snapshot?.data()?[email["Email"].toString().split("@")[0]] != null)
      {
        Map<String,dynamic>data={};
        data["Name"]=email["Name"];
        data["Rollnumber"]=email["Roll-number"];
        data["Score"]=snapshot?.data()?[email["Email"].toString().split("@")[0]]["Score"];
        data["Quiz-Time"]=snapshot?.data()?[email["Email"].toString().split("@")[0]]["Time"];
        data["Email"]=email["Email"];
        result.add(data);
        unattemptedStudents.removeWhere((element) => element["Email"]==email["Email"]);
      }
      else{

      }
    }


    // Sort the map based on timeStamp and Quiz Sore ....

    print("....................Before$result");

    result.sort((a, b) {
      if(a["Score"]==b["Score"])
      {
        return a["Quiz-Time"].compareTo(b["Quiz-Time"]);
      }
      else{
        return a["Score"].compareTo(b["Score"]);
      }
    },);
    int s=0;
    int e=result.length-1;
    while(s<e)
    {
      var temp =result[s];
      result[s]=result[e];
      result[e]=temp;
      s++;
      e--;
    }



  }

  Future<void> fetchEmail() async {
    await FirebaseFirestore.instance.collection("Students")
        .where("University",isEqualTo: university_filter)
        .where("College",isEqualTo: college_filter)
        .where("Branch",isEqualTo: branch_filter)
        .where("Course",isEqualTo: course_filter)
        .where("Year",isEqualTo: year_filter)
        .where("Section",isEqualTo: section_filter)
        .where("Subject",arrayContains: subject_filter).get().then((value) {

      setState(() {
        allStudentsData=value;
      });
    }).whenComplete(() {
      setState(() {


        for(int i=0;i<allStudentsData.docs.length;i++)
        {

          allEmailsWithLink["${allStudentsData.docs[i]["Email"]}"] =
          allStudentsData.docs[i]["Profile_URL"]!=null
              ?
          "${allStudentsData.docs[i]["Profile_URL"]}"
              :
          "null";

          unattemptedStudents.add(
              {
                "Name":allStudentsData.docs[i]["Name"],
                "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                "Email":allStudentsData.docs[i]["Email"]
              });

          allEmail.add(
              {
                "Name":allStudentsData.docs[i]["Name"],
                "Roll-number":allStudentsData.docs[i]["Rollnumber"],
                "Email":allStudentsData.docs[i]["Email"]
              });

        }

      });
    });

  }


}

