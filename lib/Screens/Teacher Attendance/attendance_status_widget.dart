import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Screens/Teacher%20Attendance/take_attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceStatus extends StatefulWidget {
   AttendanceStatus({super.key,required this.error,required this.mark});
  String error;
  bool mark;
  @override
  State<AttendanceStatus> createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatus> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height*0.05,),
         widget.mark
          ?
         Image.asset("assets/icon/green_double_circle_check_mark.jpg",width: size.width*0.2,height: size.height*0.1,)
         :
         Image.asset("assets/icon/remove.png",width: size.width*0.2,height: size.height*0.1,),
          SizedBox(height: size.height*0.02,),
          widget.mark
          ?
          AutoSizeText("Congrats!",style: GoogleFonts.exo(fontSize: size.height*0.03,fontWeight: FontWeight.w600,color: Colors.green))
          :
          AutoSizeText("Error!",style: GoogleFonts.exo(fontSize: size.height*0.03,fontWeight: FontWeight.w600,color: Colors.red))
          ,
          SizedBox(height: size.height*0.02,),
          widget.mark
          ?
          AutoSizeText("The biometric data of your selfie match with your UVC picture",style: GoogleFonts.exo(fontSize: size.height*0.018),textAlign: TextAlign.center,)
          :
          AutoSizeText(widget.error.toString(),style: GoogleFonts.exo(color: Colors.red,fontSize: size.height*0.018),textAlign: TextAlign.center,),
          SizedBox(
            height: size.height*0.02,
          ),
          Container(
            height: size.width*0.35,
            width: size.width*0.35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: usermodel["Profile_URL"]==null
                ?
            Center(
              child: AutoSizeText(
                usermodel["Name"].toString().substring(0,1),
                style: GoogleFonts.exo(
                    fontSize: size.height * 0.05,
                    fontWeight: FontWeight.w600),
              ),
            )
                :
            Image.network(usermodel["Profile_URL"],fit: BoxFit.cover),
          ),
          SizedBox(height: size.height*0.02,),
           AutoSizeText(usermodel["Name"].toString()),
          SizedBox(height: size.height*0.07,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              SizedBox(width: size.width*0.05,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText("Employee ID",style: GoogleFonts.exo(fontSize: size.height*0.018),),
                    SizedBox(height: size.height*0.01,),
                    AutoSizeText(usermodel["Employee Id"],style: GoogleFonts.exo(fontSize: size.height*0.02,color: Colors.blue),),
                    SizedBox(height: size.height*0.03,),
                        AutoSizeText("Location",style: GoogleFonts.exo(fontSize: size.height*0.018),),
                        SizedBox(height: size.height*0.01,),
                    AutoSizeText("IIMT Enggi. Colllege,Meerut",style: GoogleFonts.exo(fontSize: size.height*0.018,color: Colors.blue),),
                  ],
                ),
              SizedBox(width: size.width*0.25,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText("Enter",style: GoogleFonts.exo(fontSize: size.height*0.018),),
                  SizedBox(height: size.height*0.01,),
                  AutoSizeText("10:00 AM",style: GoogleFonts.exo(fontSize: size.height*0.018,color: Colors.blue),),
                  SizedBox(height: size.height*0.03,),
                  AutoSizeText("Exit",style: GoogleFonts.exo(fontSize: size.height*0.018),),
                  SizedBox(height: size.height*0.01,),
                  AutoSizeText("06:20 PM",style: GoogleFonts.exo(fontSize: size.height*0.018,color: Colors.blue),),

                ],
              ),

            ],
          ),
          SizedBox(height: size.height*0.05,),
          ElevatedButton(onPressed: () async {
            if(widget.mark)
              {
                Navigator.pop(context);
                Navigator.pop(context);

              }
            else{
              await availableCameras().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  TeacherAttendance(cameras: value,),));
              });

            }
          },style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent,),
            child: SizedBox(
              height:size.height*0.02,width:size.width*0.2,
              child:
              widget.mark
              ?
              const Text("Exit",textAlign: TextAlign.center,)
            :
              const Text("Try Again",textAlign: TextAlign.center,)
            )
          )

        ],
      ),
    );
  }
}
