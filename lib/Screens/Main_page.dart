import 'dart:async';
import 'package:campus_link_teachers/Registration/Login.dart';
import 'package:campus_link_teachers/Registration/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import '../Constraints.dart';
import 'Navigator.dart';
import 'loadingscreen.dart';




class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {
  bool loaded=false;
  bool docExist=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var temp=FirebaseAuth.instance.currentUser;
    if(temp!=null){
      fetchuser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot)  {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SignInScreen();
        } else if (snapshot.connectionState == ConnectionState.active && !snapshot.hasData) {
          return const SignInScreen();
        } else if (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
        {
          if(FirebaseAuth.instance.currentUser!.emailVerified){


            return
              loaded
                  ?
              docExist
                  ?
              const Nevi()
                  :
              const Details()
                  :
              const loading(text: "Retrieving data from the server please wait",);
          }
          else{
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
            InAppNotifications.instance
              ..titleFontSize = 14.0
              ..descriptionFontSize = 14.0
              ..textColor = Colors.black
              ..backgroundColor =
              const Color.fromRGBO(150, 150, 150, 1)
              ..shadow = true
              ..animationStyle =
                  InAppNotificationsAnimationStyle.scale;
            InAppNotifications.show(
                duration: const Duration(seconds: 2),
                description: "Please verify your email.",
                leading: const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 55,
                ));
            FirebaseAuth.instance.signOut();
            return const SignInScreen();
          }
        }
        else{
          return const SignInScreen();}
      },

    );
  }
  Future<void> fetchuser() async {
  if(!loaded){
    try{
      await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser?.email).collection("Teachings").doc('Teachings')
          .get().then((value) async {
        if(value.data()!.isNotEmpty){
          university_filter = value.data()?['University'][0];
          college_filter = value.data()?['College-0'][0];
          course_filter = value.data()?['Course-00'][0];
          branch_filter = value.data()?['Branch-000'][0];
          year_filter = value.data()?['Year-0000'][0];
          section_filter = value.data()?['Section-00000'][0];
          subject_filter = value.data()?['Subject-000000'][0];
        }
        await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser!.email).get()
            .then((value){
          setState(() {
            usermodel=value.data()!;
          });
        }).whenComplete(() async {
          setState(() {
            if (kDebugMode) {
              print(usermodel);
            }
            docExist=true;
            loaded=true;
          });
          await FirebaseMessaging.instance.getToken().then((token) async {
            await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser!.email).update({
              'Token' : token,
            });
          });
        }
        );
      });
    } catch(e) {
      setState(() {
        loaded=true;
      });
    }

  }
  }
}
