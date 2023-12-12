import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceStatus extends StatefulWidget {
  const AttendanceStatus({super.key});

  @override
  State<AttendanceStatus> createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatus> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height*0.05,),
           Image.asset("assets/icon/green_double_circle_check_mark.jpg",width: size.width*0.2,height: size.height*0.1,),
            SizedBox(height: size.height*0.02,),
            AutoSizeText("Congrats!",style: GoogleFonts.exo(fontSize: size.height*0.03,fontWeight: FontWeight.w600,color: Colors.green)),
            SizedBox(height: size.height*0.02,),
            AutoSizeText("The biometric data of your selfie match with your UVC picture",style: GoogleFonts.exo(fontSize: size.height*0.018),textAlign: TextAlign.center,),
            SizedBox(height: size.height*0.07,),
            Container(
              height: size.height*0.2,
              width: size.width*0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image:DecorationImage(image: AssetImage(""),


                ),
              ),
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
                      AutoSizeText("ID TRTR436",style: GoogleFonts.exo(fontSize: size.height*0.02,color: Colors.blue),),
                      SizedBox(height: size.height*0.03,),
                          AutoSizeText("Location",style: GoogleFonts.exo(fontSize: size.height*0.018),),
                          SizedBox(height: size.height*0.01,),
                      AutoSizeText("Office location,Gulshan 1",style: GoogleFonts.exo(fontSize: size.height*0.018,color: Colors.blue),),
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
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            },style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent,),
              child: SizedBox(
                height:size.height*0.02,width:size.width*0.2,
                child: const Text("Exit",textAlign: TextAlign.center,),)
            ,
            )

          ],
        ),
      ),
    );
  }
}
