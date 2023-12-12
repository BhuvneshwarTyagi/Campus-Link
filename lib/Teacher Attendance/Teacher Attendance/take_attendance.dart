import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ML.dart';
import 'attendance_status_widget.dart';

class TeacherAttendance extends StatefulWidget {
  const TeacherAttendance({Key? key,required this.cameras}) : super(key: key);
  final List<CameraDescription>? cameras;
  @override
  State<TeacherAttendance> createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {
  late CameraController _cameraController;
  XFile? pictureFile;
  bool lateForAttendance=false;
  bool isPictureClicked=false;
  bool isUploaded=false;
  @override
  void initState() {
    super.initState();
    print("Available cameras are : ${widget.cameras}");
    _cameraController = CameraController(
      widget.cameras![1],
      ResolutionPreset.high,
    );
    _cameraController.setFlashMode(FlashMode.off);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return  Scaffold(
         appBar: AppBar(
           title: const AutoSizeText(
             "Take Attendance"
           ),
           centerTitle: true,
         ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: size.height * 0.63,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black45,
                            width: 2,
                          )),
                      child:_cameraController.value.isInitialized
                          ?
                          isPictureClicked
                           ?
                          Stack(
                            children: [
                              SizedBox(
                             height: size.height * 0.63,
                              width: size.width * 1,
                                child: Image.file(File(pictureFile!.path),
                                    fit: BoxFit.contain),
                              ),
                              isUploaded
                              ?
                              const loading(text: "Verification Start..")
                                  :
                                  const SizedBox(),
                              !isUploaded
                              ?
                              Positioned(
                                top: 2,
                                right: 1,
                                child: IconButton(onPressed:() {
                                 setState(() {
                                   isPictureClicked=false;
                                 });
                                }, icon: Icon(Icons.delete,color: Colors.red,size:size.height*0.045)),
                              )
                                  :
                                  const SizedBox()
                            ],
                          )
                          :
                          CameraPreview(_cameraController)
                          :
                      const CircularProgressIndicator(
                          color:Colors.black ,backgroundColor: Colors.white70, strokeWidth: 10)
                      ,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height*0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size.width*0.6,
                        height: size.height*0.066,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 2
                          )
                        ),
                        child: ElevatedButton(

                          onPressed: () async {
                            if(!isPictureClicked)
                              {
                           await MlKit().checkDistance().then((value) async {
                             if(value)
                               {
                                 pictureFile = await _cameraController.takePicture();
                                 if(pictureFile!.path.isNotEmpty)
                                   {
                                     setState(() {
                                       isPictureClicked=true;
                                     });
                                   }
                               }
                               else{
                               InAppNotifications.instance
                                 ..titleFontSize = 25.0
                                 ..descriptionFontSize = 15.0
                                 ..textColor = Colors.black
                                 ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                 ..shadow = true
                                 ..animationStyle = InAppNotificationsAnimationStyle.scale;
                               InAppNotifications.show(
                                   title: 'Error',
                                   duration: const Duration(seconds: 2),
                                   description: "You are out of rage",
                                   leading: const Icon(
                                     Icons.error_outline,
                                     color: Colors.red,
                                     size: 40,
                                   ));
                             }
                           });}
                            else{
                              // Write code to match to recognize face frome model
                                     setState(() {
                                       isUploaded=true;
                                     });
                                   await  MlKit().faceRecognize(pictureFile!.path).then((value) async {
                                     if(value==usermodel["Email"].toString().split("@")[0])
                                       {
                                         await FirebaseFirestore.instance.collection("Teachers")
                                             .doc("${usermodel["Email"]}")
                                             .collection("Attendance")
                                             .doc("${DateTime.now().month}")
                                             .get().then((value) async {
                                           if(value.data()==null)
                                             {
                                               await FirebaseFirestore.instance.collection("Teachers")
                                                   .doc("${usermodel["Email"]}")
                                                   .collection("Attendance")
                                                   .doc("${DateTime.now().month}")
                                                   .set({
                                                 "${DateTime.now().day}":{
                                                   if(TimeOfDay.now().hour<12)
                                               {
                                                 "Morning-Attendance":"Present"
                                               } else {
                                                       "Evening-Attendance": "Present"
                                                     }
                                                 }
                                               }).whenComplete(() {
                                                 // Navigate to nex screen
                                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const AttendanceStatus(),));
                                               });
                                             }
                                           else{
                                             await FirebaseFirestore.instance.collection("Teachers")
                                                 .doc("${usermodel["Email"]}")
                                                 .collection("Attendance")
                                                 .doc("${DateTime.now().month}")
                                                 .update({
                                                 TimeOfDay.now().hour<12
                                                   ?
                                                   "${DateTime.now().day}":{"Morning-Attendance":"Present"}
                                                   :
                                                    { "${DateTime
                                                         .now()
                                                         .day}.Evening-Attendance": "Present"}
                                             }).whenComplete(() {
                                               // Navigate to next screen
                                               Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AttendanceStatus(),));
                                             });
                                           }
                                         });

                                       }
                                     else{
                                       // Face not match It may be error
                                        print("Error While using Face Recognize Api : ${value.toString()}");
                                     }
                                   });
                            }
                       },
                          child:isPictureClicked
                             ?
                          const Text('Upload Photo')
                              :
                          const Text('Take Attendance')
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height*0.01,
            ),
            Container(
              height: size.height*0.125,
              width: size.width*0.9,
              decoration:BoxDecoration(
                border: Border.all(
                  color: Colors.black87,
                  width: 2
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText("Attendance Status : ",
                        style:GoogleFonts.exo(
                          color: Colors.black87,
                          fontSize: size.height*0.02,
                        ) ,
                      ),
                      AutoSizeText("Under process",
                        style:GoogleFonts.exo(
                          color: Colors.black87,
                          fontSize: size.height*0.02,
                        ) ,
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height*0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText("Employe Id :",
                        style:GoogleFonts.exo(
                          color: Colors.black87,
                          fontSize: size.height*0.02,
                        ) ,
                      ),
                      AutoSizeText(usermodel["Employee Id"],
                        style:GoogleFonts.exo(
                          color: Colors.black87,
                          fontSize: size.height*0.02,
                        ) ,
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height*0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText("Name : ",
                        style:GoogleFonts.exo(
                          color: Colors.black87,
                          fontSize: size.height*0.02,
                        ) ,
                      ),
                      AutoSizeText(usermodel["Name"],
                        style:GoogleFonts.exo(
                          color: Colors.black87,
                          fontSize: size.height*0.02,
                        ) ,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
