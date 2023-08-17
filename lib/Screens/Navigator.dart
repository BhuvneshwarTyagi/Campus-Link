import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Database/database.dart';
import '../Registration/Basic.dart';
import 'Assignments.dart';
import 'Attendance.dart';
import 'Filters.dart';
import 'Notes.dart';
import 'Performance.dart';
import 'Sessional.dart';
import 'download_attendance.dart';

class Nevi extends StatefulWidget {
  const Nevi({Key? key}) : super(key: key);

  @override
  State<Nevi> createState() => _NeviState();
}

class _NeviState extends State<Nevi> {
  int index = 0;
  var mtoken;
  final screens = [
    const Assignments_upload(),
    const Notes(),
    const Attendance(),
    const Performance(),
    const Sessional(),
  ];
  double leftpos = 26;
  double assigment_size = 35;
  double note_size = 25;
  double attendence_size = 25;
  double performance_size = 25;
  double mark_size = 25;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }
  call() async {
    await database().getloc().whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("Students")
          .where("University", isEqualTo: university_filter)
          .where("College", isEqualTo: college_filter)
          .where("Course", isEqualTo: course_filter)
          .where("Branch", isEqualTo: branch_filter)
          .where("Year", isEqualTo: year_filter)
          .where("Section", isEqualTo: section_filter)
          .where("Subject", arrayContains: subject_filter)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          sendPushMessage(element.data()['token'], "Attendance Initialized",
              subject_filter);
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color navHeading = Colors.white;
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Colors.black,
            // Colors.deepPurple,
            // Colors.purpleAccent
            const Color.fromRGBO(86, 149, 178, 1),

            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          //width: size.width*0.8,
          backgroundColor: Colors.blueGrey,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                leading: const Icon(Icons.add,color: Colors.black,),
                title: const Text('Add Subject'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const basicDetails(),
                      type: PageTransitionType.rightToLeftJoined,
                      duration: const Duration(milliseconds: 350),
                      childCurrent: const Nevi(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.download,color: Colors.black,),
                title: const Text('Download Attendance'),
                onTap: () {
                  Navigator.push(context, PageTransition(
                    child: const Download_attendance(),
                    type: PageTransitionType.bottomToTopJoined,
                    duration: const Duration(milliseconds: 400),
                    alignment: Alignment.bottomCenter,
                    childCurrent: const Nevi(),
                  ),);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined,color: Colors.black,),
                title: const Text('Logout'),
                onTap: () {
                  database().signOut();
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const Filters(),
                    type: PageTransitionType.bottomToTopJoined,
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.bottomCenter,
                    childCurrent: const Attendance(),
                  ),
                );
              },
              icon: const Icon(Icons.filter_list_alt),
            )
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black38,
          titleTextStyle: GoogleFonts.gfsDidot(
              color: Colors.white,
              //const Color.fromRGBO(150, 150, 150, 1),
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height * 0.03),
          title: const Text('Campus Link'),
        ),
        bottomNavigationBar: Container(
          height: size.height * 0.08,
          padding: EdgeInsets.only(top: size.height * 0.01),
          decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    index = 0;
                    assigment_size = size.width * 0.10;
                    mark_size = size.width * 0.07;
                    attendence_size = size.width * 0.07;
                    performance_size = size.width * 0.07;
                    note_size = size.width * 0.07;
                  });
                },
                child: SizedBox(
                  width: assigment_size + size.width * 0.11,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        width: assigment_size,
                        height: assigment_size,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/assignment.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),

                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    index = 1;
                    note_size = size.width * 0.10;
                    mark_size = size.width * 0.07;
                    attendence_size = size.width * 0.07;
                    performance_size = size.width * 0.07;
                    assigment_size = size.width * 0.07;
                  });
                },
                child: SizedBox(
                  width: note_size + size.width * 0.11,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        width: note_size,
                        height: note_size,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/notes_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    index = 2;
                    note_size = size.width * 0.07;
                    mark_size = size.width * 0.07;
                    attendence_size = size.width * 0.10;
                    performance_size = size.width * 0.07;
                    assigment_size = size.width * 0.07;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          width: size.width*0.7,
                          height: subject_filter.isEmpty?
                              size.height*0.2
                              :
                          size.height*0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black,
                            border: Border.all(color: Colors.white,width: 2)
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               SizedBox(
                                height: size.height*0.02,
                              ),
                              AutoSizeText(
                                "Do you want to take attendance?",
                                style: GoogleFonts.exo(color: Colors.white),
                              ),
                              SizedBox(
                                height: size.height*0.01,
                              ),

                              subject_filter.isEmpty?
                                   SizedBox(
                                    height: size.height*0,
                                  ):
                                  Column(
                                    children: [
                                      AutoSizeText(
                                        "Please check your filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: size.height*0.01,
                                      ),
                                      AutoSizeText(
                                      "$university_filter",
                                      style: GoogleFonts.exo(color: Colors.white),
                                    ),
                                      const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                      AutoSizeText(
                                        "$college_filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),
                                      const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                      AutoSizeText(
                                        "$course_filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),
                                      const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                      AutoSizeText(
                                        "$branch_filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),
                                      const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                      AutoSizeText(
                                        "Year: $year_filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),
                                      const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                      AutoSizeText(
                                        "Section: $section_filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),
                                      const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                      AutoSizeText(
                                        "$subject_filter",
                                        style: GoogleFonts.exo(color: Colors.white),
                                      ),],
                                  ),
                               SizedBox(
                                height: size.height*0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 20,
                                        backgroundColor: Colors.white10),
                                    onPressed: () {
                                      setState(() {
                                         subject_filter = '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "No",
                                      style: GoogleFonts.exo(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 20,
                                        backgroundColor: Colors.white10),
                                    onPressed: () async {
                                      subject_filter.isEmpty
                                          ?
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: const Filters(),
                                          type: PageTransitionType.bottomToTopJoined,
                                          duration: const Duration(milliseconds: 200),
                                          alignment: Alignment.bottomCenter,
                                          childCurrent: const Attendance(),
                                        ),
                                      )
                                          :
                                      await database().getloc().whenComplete(() => setState(()  {
                                        index = 2;
                                        attendence_size = size.width * 0.10;
                                        mark_size = size.width * 0.07;
                                        assigment_size = size.width * 0.07;
                                        performance_size = size.width * 0.07;
                                        note_size = size.width * 0.07;
                                        Navigator.pop(context);
                                      }));

                                      subject_filter.isEmpty
                                          ?
                                          null
                                          :
                                          call();


                                    },
                                    child: Text(
                                      "Yes",
                                      style: GoogleFonts.exo(color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: attendence_size + size.width * 0.11,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        width: attendence_size,
                        height: attendence_size,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/attendance_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),

                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    index = 4;
                    mark_size = size.width * 0.10;
                    assigment_size = size.width * 0.07;
                    attendence_size = size.width * 0.07;
                    performance_size = size.width * 0.07;
                    note_size = size.width * 0.07;
                  });
                },
                child: SizedBox(
                  width: mark_size + size.width * 0.11,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        width: mark_size,
                        height: mark_size,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/mark_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),

                    ],
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    index = 3;
                    performance_size = size.width * 0.10;
                    mark_size = size.width * 0.07;
                    attendence_size = size.width * 0.07;
                    assigment_size = size.width * 0.07;
                    note_size = size.width * 0.07;
                  });
                },
                child: SizedBox(
                  width: performance_size + size.width * 0.12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        width: performance_size,
                        height: performance_size,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/performance_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),

                    ],
                  ),
                ),
              ),

              // IconButton(
              //     onPressed: (){
              //   setState(() {
              //     index=1;
              //     leftpos=size.width*0.25;
              //     assigment_size=size.width*0.07;
              //   });
              // },
              //     icon:  Icon(Icons.notes,
              //         color: index==1 ? Colors.amber :Colors.white,)),
              //
              // TextButton(
              //   onPressed: (){
              //     setState(() {
              //       index=2;
              //       leftpos=size.width*0.44;
              //     });
              //   },
              //   child: Container(
              //     width: size.width*0.07,
              //     height: size.height*0.07,
              //     decoration: const BoxDecoration(
              //       color: Colors.transparent,
              //       image: DecorationImage(image: AssetImage("assets/images/attendance_icon.png"),fit: BoxFit.contain,
              //     ),
              //     ),
              //   ),
              // ),
              //
              //
              // IconButton(onPressed: (){
              //   setState(() {
              //     index=3;
              //     leftpos=size.width*0.6358;
              //   });
              // }, icon: Icon(Icons.pie_chart,color: index==3 ? Colors.amber :Colors.white,)),
              // IconButton(
              //     onPressed: (){
              //       setState(() {
              //         index=4;
              //         leftpos=size.width*0.82;
              //       }
              //       );
              //       },
              //     icon: Icon(Icons.grading,color: index==4 ? Colors.amber :Colors.white,),
              // ),
            ],
          ),
        ),
        body: screens[index],
      ),
    );
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      print("Send $token");
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': "application/json",
          "Authorization":
          "key=AAAAIV7WaYA:APA91bFtEFPpqZBF3z1FeRD6CmhYYrtA2EX7Y7oGCf2qjAHLKcyi15Dbd7e3Cjo3WS1rKeHCzS_07fUfUsV6jnTJ7uZiHy2z8h-CIRW9jjO2jxycobLjgrI7nVT76-mUt8Dd41psJ_oI"
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          "data": <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': "done",
            'body': body,
            'title': title,
          },
          "apns": {
            "headers": {"apns-priority": "5"},
          },
          "notification": <String, dynamic>{
            'body': body,
            'title': title,
            'android_channel_id': "campuslink"
          },
          "to": token,
          "android": {"priority": "high"},
        }),
      );
    } catch (e) {}
  }
  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("Teachers")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      'Token': token,
    });
  }
}
