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
                duration: const Duration(seconds: 4),
                description: "Please verify your email.",);
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
       print("Before Entering.........");
      await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser?.email).get().then((value) async {
       print("Inside query..........");
       print("....${value.data()!=null}");


        if(value.data() !=null){
          usermodel = value.data()!;
          print("Data is not Empty.......");

         /* await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser?.email).collection("Teachings").doc('Teachings')
              .get().then((value1) async {
                print(" Data is : ${value1.data().toString()}");
            if(value1.data() != null ){
              university_filter = value1.data()?['University'][0];
              college_filter = value1.data()?['College-0'][0];
              course_filter = value1.data()?['Course-00'][0];
              branch_filter = value1.data()?['Branch-000'][0];
            }
            setState(() {
              if (kDebugMode) {
                print(usermodel);
              }
              docExist=true;
              loaded=true;
            });


          });*/
          setState(() {
            if (kDebugMode) {
              print(usermodel);
            }
            docExist=true;
            loaded=true;
          });
        }
        else{
          setState(() {
            loaded=true;
          });
        }
      });
    }

  }
  }
