import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:campus_link_teachers/Screens/Feedback.dart';
import 'package:campus_link_teachers/Screens/Leader_board/Leader_Board.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:campus_link_teachers/push_notification/helper_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Achievements/achievement_page.dart';
import '../Database/database.dart';
import '../Registration/Basic.dart';
import 'Assignment/Assignments.dart';
import 'Attendance.dart';
import 'Download Excel sheet/excel_sheet_fliter.dart';
import 'Filters.dart';
import 'Notes/Notes.dart';
import 'Sessional/Sessional.dart';
import 'Chat_tiles/chat_list.dart';
import 'Teacher Attendance/take_attendance.dart';
import 'Teacher Attendance/take_sample.dart';


class Nevi extends StatefulWidget {
  const Nevi({Key? key}) : super(key: key);

  @override
  State<Nevi> createState() => _NeviState();
}

class _NeviState extends State<Nevi>  {
  int index = 0;
  late var mtoken;
  final screens = [
    const AssignmentsUpload(),
    const Notes(),
    const Attendance(),
    const OverAllLeaderBoard(),
    const NewPost(),
  ];
  double leftpos = 26;
  double assigmentSize = 35;
  double noteSize = 25;
  double attendenceSize = 25;
  double performanceSize = 25;
  double markSize = 25;
  double slider= 33;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<void> call() async {
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
          sendPushMessage(element.data()['Token'], "Attendance Initialized",
              subject_filter);
        });
      });
    });
  }
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
              UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.black,
                        Colors.blueAccent,
                        Colors.purple,
                      ],
                    ),
                  ),
                  accountName: AutoSizeText(
                    usermodel["Name"],
                    style: GoogleFonts.exo(
                        fontSize: size.height * 0.022,
                        fontWeight: FontWeight.w600),
                  ),
                  accountEmail: AutoSizeText(
                    usermodel["Email"],
                    style: GoogleFonts.exo(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w600),
                  ),
                  currentAccountPicture:Stack(
                    children: [
                      CircleAvatar(
                        radius: size.height*0.2,

                        backgroundImage:usermodel["Profile_URL"]!=null?

                        NetworkImage(usermodel["Profile_URL"])
                            :
                        null,
                        // backgroundColor: Colors.teal.shade300,
                        child: usermodel["Profile_URL"]==null?
                        AutoSizeText(
                          usermodel["Name"].toString().substring(0,1),
                          style: GoogleFonts.exo(
                              fontSize: size.height * 0.05,
                              fontWeight: FontWeight.w600),
                        )
                            :
                        null,
                      ),
                      Positioned(
                        bottom: -5,
                        left: 35,
                        child: IconButton(
                          icon: Icon(Icons.camera_enhance,size:size.height*0.03 ,color: Colors.black,),
                          onPressed: (){} ,
                        ),
                      )
                    ],
                  )
              ),
              ListTile(
                leading: const Icon(Icons.home,color: Colors.black,),
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.home,color: Colors.black,),
                title: const Text("Notification"),
                onTap: () {
                  NotificationServices.display(
                      const RemoteMessage(
                        data:{
                          'title': "Test",
                          'body': "Testing",
                          'route': ""
                        },
                      ),
                      '404'
                  );
                },
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
                leading: const Icon(Icons.upload_file,color: Colors.black,),
                title: const Text('Sessional Marks'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const Sessional(),
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
                leading: const Icon(Icons.feedback_outlined,color: Colors.black,),
                title: const Text('Check Feedbacks'),
                onTap: () {
                  Navigator.push(context, PageTransition(
                    child: const FeedBack(),
                    type: PageTransitionType.bottomToTopJoined,
                    duration: const Duration(milliseconds: 400),
                    alignment: Alignment.bottomCenter,
                    childCurrent: const Nevi(),
                  ),);
                },
              ),
              ListTile(
                leading: const Icon(Icons.task,color: Colors.black),
                title: const Text("Take Teacher Attendance"),
                onTap: () async {
                  await availableCameras().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  TeacherAttendance(cameras: value,),));
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_enhance,color: Colors.black),
                title: const Text("Testing Sample"),
                onTap: () async {

                  await availableCameras().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  TakeSampleImage(cameras: value,),));
                  });

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
              StreamBuilder(

                stream: FirebaseFirestore.instance.collection("Messages").where(usermodel["Email"].toString().split("@")[0],isNull: false).snapshots(),

                builder: (context, snapshot) {
                  int count=0;


                  int end=snapshot.hasData  ?  snapshot.data!.docs.length : 0;
                  if (kDebugMode) {
                    print(" ///////////..............$end");
                  }
                  for(int i=0;i<end; i++){
                    int read=snapshot.data?.docs[i].data()[usermodel["Email"].toString().split("@")[0]]["Read_Count"];
                    int len=snapshot.data?.docs[i].data()["Messages"].length;
                    if (kDebugMode) {
                      print("${read-len}");
                    }
                    count+=len-read;
                  }

                  return snapshot.hasData
                      ?
                  Stack(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const chatsystem(),
                              type: PageTransitionType.bottomToTopJoined,
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.bottomCenter,
                              childCurrent: const Nevi(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.send_outlined),
                      ),
                      count>0
                          ?
                      Positioned(
                        right: size.width*0.006,
                        child: Container(
                          width: size.width*0.05,
                          height: size.width*0.05,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            shape:BoxShape.circle,
                          ),

                          child: Center(
                            child: SizedBox(
                              width: size.width*0.04,
                              child: AutoSizeText(
                                '$count',
                                style: GoogleFonts.exo(
                                    color: Colors.black,
                                    fontSize: size.height*0.04,
                                    fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
                                minFontSize: 8,
                                textAlign: TextAlign.center,

                              ),
                            ),
                          ),
                        ),
                      )
                          :
                      const SizedBox()
                    ],
                  )
                      :
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const chatsystem(),
                          type: PageTransitionType.bottomToTopJoined,
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.bottomCenter,
                          childCurrent: const Nevi(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_outlined),
                  );
                },),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const Filters(),
                      type: PageTransitionType.bottomToTopJoined,
                      duration: const Duration(milliseconds: 200),
                      childCurrent: const Attendance(),
                    ),
                  );
                },
                icon: const Icon(Icons.filter_list_alt),
              )
            ],
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.black38,
            title: SizedBox(
              width: size.width*0.9,
              height: size.height*0.055,
              child: AutoSizeText('Campus Link',style: GoogleFonts.tiltNeon(
                  color: Colors.black,
                  //const Color.fromRGBO(150, 150, 150, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.04),),
            )
        ),
        body: screens[index],
        bottomNavigationBar: Container(
          height: size.height * 0.055,
          margin: EdgeInsets.fromLTRB(size.width*0.04,5,size.width*0.04,size.height*0.01),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(15),),
          ),
          child: Stack(
            children: [
              Container(
                height: size.height * 0.055,
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          index = 0;
                          slider= size.width*0.08;
                        });
                      },
                      child: Container(

                        width: size.width*0.1,
                        height: size.height*0.045,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/assignment.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          index = 1;
                          slider= size.width*0.25;
                        });
                      },
                      child: Container(
                        width: size.width*0.08,
                        height: size.height*0.04,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/notes_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                width: size.width*0.7,
                                height: subject_filter.isEmpty?
                                size.height*0.2
                                    :
                                size.height*0.65,
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
                                          university_filter,
                                          style: GoogleFonts.exo(color: Colors.white),
                                        ),
                                        const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                        AutoSizeText(
                                          college_filter,
                                          style: GoogleFonts.exo(color: Colors.white),
                                        ),
                                        const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                        AutoSizeText(
                                          course_filter,
                                          style: GoogleFonts.exo(color: Colors.white),
                                        ),
                                        const Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
                                        AutoSizeText(
                                          branch_filter,
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
                                          subject_filter,
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
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                child: const loading(text: "Loading Students data from the server Please wait for a while"),
                                                type: PageTransitionType.bottomToTopJoined,
                                                duration: const Duration(milliseconds: 200),
                                                alignment: Alignment.bottomCenter,
                                                childCurrent: const Nevi(),
                                              ),
                                            );

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
                                            await call().whenComplete(() async {
                                              await database().getloc().whenComplete(() => setState(()  {
                                                index = 2;
                                                slider= size.width*0.41;
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }));

                                            }
                                            );


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
                      child: Container(
                        width: size.width*0.06,
                        height: size.height*0.03,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image:
                            AssetImage("assets/images/attendance_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {

                        setState(() {
                          index=4;
                          slider= size.width*0.565;
                        });


                      },
                      child: Container(
                        width: size.width*0.08,
                        height: size.height*0.03,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/mark_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          index = 3;
                          slider= size.width*0.73;
                        });
                      },
                      child: Container(
                        width: size.width*0.08,
                        height: size.height*0.03,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/performance_icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                height: size.height*0.055,
                left: slider,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width*0.12,
                      height: size.height*0.0055,
                      decoration: const BoxDecoration(

                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(89, 193, 115, 1),
                                Color.fromRGBO(161, 127, 224, 1),
                                // Color.fromRGBO(93, 38, 193, 1),
                              ])
                      ),
                    ),
                    Container(
                      width: size.width*0.12,
                      height: size.height*0.0055,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(89, 193, 115, 1),
                                Color.fromRGBO(161, 127, 224, 1),
                                // Color.fromRGBO(93, 38, 193, 1),
                              ]),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      if (kDebugMode) {
        print("Send $token");
      }
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
 /* Future<void> uploadImage(String imageFilePath) async {
    var url = Uri.parse('https://facerecognizeapi.onrender.com/predict');

    var request = http.MultipartRequest('POST', url)..files.add(await http.MultipartFile.fromPath('file', imageFilePath));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Response: ${await response.stream.bytesToString()}');
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<void> uploadImageTGitHub(String owner,String repo,String filePath,String accesstoken) async {
    final fileContent = base64Encode(File(filePath).readAsBytesSync());
    const fileName = 'your_image.jpg';  // Set the desired filename
    const commitMessage = 'Upload image';

    final url = Uri.parse('https://api.github.com/repos/$owner/$repo/contents/Train/$fileName');
    final headers = {
      'Authorization': 'Bearer $accesstoken',
      'Accept': 'application/vnd.github.v3+json',
    };

    final data = {
      'message': commitMessage,
      'content': fileContent,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print('Image uploaded to GitHub successfully');
    } else {
      print('Failed to upload image to GitHub: ${response.statusCode}');
    }
  }
*/
// Future<void> downloadAndSaveImage(String owner, String repo, String filePath, String localPath, String accessToken) async {
//   try {
//     final url = Uri.parse('https://raw.githubusercontent.com/$owner/$repo/main/train/bhanu/image.jpg');
//     final headers = {'Authorization': 'Bearer $accessToken'};
//
//     final response = await http.get(
//       url,
//       headers: headers,
//     );
//
//     if (response.statusCode == 200) {
//       print(response.bodyBytes);
//       final file = File('$localPath/$filePath');
//       await file.create(recursive: true);
//       await file.writeAsBytes(response.bodyBytes).whenComplete(() async {
//         await uploadImage(file.path);
//       });
//
//       print('Image downloaded and saved: $filePath');
//     } else {
//       print('Error downloading image $filePath: ${response.statusCode}');
//       print(response.body);
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }
// Future<void> uploadFileToGitHub(String owner, String repo, String filePath, String targetDirectory, String accessToken) async {
//   var fileContent = await File(filePath).readAsString();
//
//   var relativePath = '$targetDirectory/${filePath.split('/').last}'; // add the target directory
//
//   var url = Uri.parse('https://api.github.com/repos/$owner/$repo/contents/$relativePath');
//   var headers = {'Authorization': 'Bearer $accessToken', 'Accept': 'application/vnd.github.v3+json'};
//   var body = {
//     'message': 'Upload from Flutter app',
//     'content': base64Encode(utf8.encode(fileContent)),
//   };
//
//   var response = await http.put(
//     url,
//     headers: headers,
//     body: jsonEncode(body),
//   );
//
//   if (response.statusCode == 201) {
//     print('File uploaded successfully to $relativePath');
//   } else {
//     print('Error uploading file to $relativePath: ${response.statusCode}');
//     print(response.body);
//   }
// }
// Future<void> uploadImageToGitHub(String owner, String repo, String localImagePath, String targetDirectory, String accessToken) async {
//   var fileBytes = await File(localImagePath).readAsBytes();
//   var fileContent = base64Encode(fileBytes);
//
//   var imageName = localImagePath.split('/').last; // Extract the image file name
//   var relativePath = '$targetDirectory/$imageName'; // Combine with the target directory
//
//   var url = Uri.parse('https://api.github.com/repos/$owner/$repo/contents/$relativePath');
//   var headers = {'Authorization': 'Bearer $accessToken', 'Accept': 'application/vnd.github.v3+json'};
//   var body = {
//     'message': 'Upload image from Flutter app',
//     'content': fileContent,
//     'encoding': 'base64',
//   };
//
//   var response = await http.put(
//     url,
//     headers: headers,
//     body: jsonEncode(body),
//   );
//
//   if (response.statusCode == 201) {
//     print('Image uploaded successfully to $relativePath');
//   } else {
//     print('Error uploading image to $relativePath: ${response.statusCode}');
//     print(response.body);
//   }
// }
//
//
// Future<void> uploadFolderToGitHub(String owner, String repo, String localFolderPath, String targetDirectory, String accessToken) async {
//   try {
//     final folder = Directory(localFolderPath);
//
//     final commitMessage = 'Upload folder from Flutter app';
//     final baseBranch = 'main'; // Change this to your repository's main branch name
//
//     // Fetch the latest commit SHA of the base branch
//     final baseCommitSHA = await _getLatestCommitSHA(owner, repo, baseBranch, accessToken);
//
//     // Create a new tree with the folder content
//     final newTreeSHA = await _createTree(owner, repo, baseCommitSHA, folder, targetDirectory, accessToken);
//
//     // Create a new commit with the new tree
//     final newCommitSHA = await _createCommit(owner, repo, baseCommitSHA, newTreeSHA, commitMessage, accessToken);
//
//     // Update the branch reference to point to the new commit
//     await _updateBranchReference(owner, repo, baseBranch, newCommitSHA, accessToken);
//
//     print('Folder uploaded successfully to $targetDirectory');
//   } catch (e) {
//     print('Error: $e');
//   }
// }
//
// Future<String> _getLatestCommitSHA(String owner, String repo, String branch, String accessToken) async {
//   try {
//     final url = Uri.parse('https://api.github.com/repos/$owner/$repo/commits/$branch');
//     final headers = {'Authorization': 'Bearer $accessToken', 'Accept': 'application/vnd.github.v3+json'};
//
//     final response = await http.get(
//       url,
//       headers: headers,
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       return jsonResponse['sha'];
//     } else {
//       throw Exception('Failed to get latest commit SHA: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//     return '';
//   }
// }
//
// Future<String> _createTree(String owner, String repo, String baseCommitSHA, Directory folder, String targetDirectory, String accessToken) async {
//   //final newfolder= await createFolderOnGitHub(owner,repo,"bhanu",accessToken);
//   final url = Uri.parse('https://api.github.com/repos/$owner/$repo/git/trees');
//   final headers = {'Authorization': 'Bearer $accessToken', 'Accept': 'application/vnd.github.v3+json'};
//
//   // Create a list of tree entries for each file in the folder
//   final treeEntries = <Map<String, dynamic>>[];
//   await for (final entity in folder.list(recursive: true)) {
//     if (entity is File) {
//       final filePath = entity.path;
//       final fileName = filePath.substring(folder.path.length + 1); // Remove the common prefix
//       final fileContent = base64Encode(await entity.readAsBytes());
//       treeEntries.add({
//         'path': '$targetDirectory/bhanu/$fileName',
//         'mode': '100644',
//         'type': 'blob',
//         'content': fileContent,
//       });
//     }
//   }
//
//   // Create a tree with the tree entries
//   final treeData = {'base_tree': baseCommitSHA, 'tree': treeEntries};
//   final response = await http.post(
//     url,
//     headers: headers,
//     body: jsonEncode(treeData),
//   );
//
//   if (response.statusCode == 201) {
//     final jsonResponse = jsonDecode(response.body);
//     return jsonResponse['sha'];
//   } else {
//     throw Exception('Failed to create tree: ${response.statusCode}');
//   }
// }
//
// Future<String> _createCommit(String owner, String repo, String baseCommitSHA, String newTreeSHA, String commitMessage, String accessToken) async {
//   final url = Uri.parse('https://api.github.com/repos/$owner/$repo/git/commits');
//   final headers = {'Authorization': 'Bearer $accessToken', 'Accept': 'application/vnd.github.v3+json'};
//
//   // Create a commit with the new tree
//   final commitData = {'message': commitMessage, 'parents': [baseCommitSHA], 'tree': newTreeSHA};
//   final response = await http.post(
//     url,
//     headers: headers,
//     body: jsonEncode(commitData),
//   );
//
//   if (response.statusCode == 201) {
//     final jsonResponse = jsonDecode(response.body);
//     return jsonResponse['sha'];
//   } else {
//     throw Exception('Failed to create commit: ${response.statusCode}');
//   }
// }
//
// Future<void> _updateBranchReference(String owner, String repo, String branch, String newCommitSHA, String accessToken) async {
//   final url = Uri.parse('https://api.github.com/repos/$owner/$repo/git/refs/heads/$branch');
//   final headers = {'Authorization': 'Bearer $accessToken', 'Accept': 'application/vnd.github.v3+json'};
//
//   // Update the branch reference to point to the new commit
//   final refData = {'sha': newCommitSHA};
//   final response = await http.patch(
//     url,
//     headers: headers,
//     body: jsonEncode(refData),
//   );
//
//   if (response.statusCode != 200 && response.statusCode != 201) {
//     throw Exception('Failed to update branch reference: ${response.statusCode}');
//   }
// }
}
