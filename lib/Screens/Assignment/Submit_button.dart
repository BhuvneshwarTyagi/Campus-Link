import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_assignment.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.snapshot, required this.index, required this.count});
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot;
  final int index;
  final count;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(

      onTap: () {
        if (snapshot.data!
            .data()?["Assignment-${index +
            1}"]["Submitted-by"] != null) {
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewAssignment(
                        selectedindex: index +
                            1),));
        }
        else{
          InAppNotifications.instance
            ..titleFontSize = 14.0
            ..descriptionFontSize = 14.0
            ..textColor = Colors.black
            ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
            ..shadow = true
            ..animationStyle = InAppNotificationsAnimationStyle.scale;
          InAppNotifications.show(
            // title: '',
            duration: const Duration(seconds: 2),
            description: "No assignment submitted till now.",
            // leading: const Icon(
            //   Icons.error_outline_outlined,
            //   color: Colors.red,
            //   size: 55,
            // )
          );
        }
      },
      title: AutoSizeText("Submission",
        style:GoogleFonts.tiltNeon(
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.w500,
            color: Colors.black
        ),
      ),
      leading: SizedBox(
        width: size.width*0.08,
        child: Image.asset("assets/images/response.png"),
      ),
      trailing: AutoSizeText(count == null ? "0" :"${count.length}",
      style:GoogleFonts.tiltNeon(
          fontSize: size.width * 0.045,
          fontWeight: FontWeight.w500,
          color: Colors.black
      ),
    ),
    );
  }
}
