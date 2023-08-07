import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Screens/All%20Students-attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database/database.dart';
import 'Selected for attendance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);
  @override
  State<Attendance> createState() => _AttendanceState();
}

class countt with ChangeNotifier {
  ValueNotifier<int> count_all = ValueNotifier(5);
  ValueNotifier<int> count_appeared = ValueNotifier(5);
}

class _AttendanceState extends State<Attendance> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    call();
  }

  final list = [const AllStudents(), const SelectedStudents()];
  bool all = true, appeared = false;
  int index = 0;

  countt count = countt();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: index == 0
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue, Colors.purpleAccent],
                            )
                          : const LinearGradient(
                              colors: [Colors.black87, Colors.black45]),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2)),
                  padding: EdgeInsets.all(size.width * 0.01),
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        index = 0;
                        all = true;
                        appeared = false;
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(
                            height: size.height * 0.09,
                            width: size.width * 0.12,
                            child: const Image(
                              image:
                                  AssetImage("assets/images/all_students.png"),
                              fit: BoxFit.contain,
                            )),
                        AutoSizeText(
                            "All Students (${countt().count_all.value})",
                            style: GoogleFonts.exo(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: index == 1
                          ? const LinearGradient(
                              colors: [Colors.blue, Colors.purpleAccent])
                          : const LinearGradient(
                              colors: [Colors.black87, Colors.black45]),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2)),
                  padding: EdgeInsets.all(size.width * 0.01),
                  height: size.height * 0.05,
                  width: size.width * 0.48,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      setState(() {
                        index = 1;
                        all = false;
                        appeared = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.01),
                          //height: size.height*0.8,
                          width: size.width * 0.08,
                          child: const Image(
                            image: AssetImage(
                                "assets/images/appeared_student.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.37,
                          child: AutoSizeText(
                              "Appeared Students (${countt().count_appeared.value})",
                              style: GoogleFonts.exo(color: Colors.white),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: subject_filter.isEmpty
            ? Center(
                child: Text(
                  "Please apply filter to take attendance",
                  style: GoogleFonts.exo(
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              )
            : list[index]);
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
          "android": {"priority": "normal"},
        }),
      );
    } catch (e) {}
  }
}
