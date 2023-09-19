import 'dart:async';
import 'package:campus_link_teachers/Registration/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Constraints.dart';
import '../Registration/Verify Email.dart';
import 'Navigator.dart';
import 'loadingscreen.dart';




class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {
  bool loaded=false;
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
              loaded ?
            const Nevi()
                :
            const loading(text: "Retrieving data from the server please wait",);
          }
          else{
            FirebaseAuth.instance.currentUser!.sendEmailVerification();
            return const Verify();
          }
        }
        else{
          return const SignInScreen();}
      },

    );
  }
  Future<void> fetchuser() async {
  if(!loaded){
    await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser!.email).get().then((value){
      setState(() {
        usermodel=value.data()!;
      });
    }).whenComplete(() async {
      await FirebaseMessaging.instance.getToken().then((token) async {
        await FirebaseFirestore.instance.collection("Teachers").doc(FirebaseAuth.instance.currentUser!.email).update({
          'Token' : token,
        }).whenComplete(() {
          setState(() {
            if (kDebugMode) {
              print(usermodel);
            }
            loaded=true;
          });
        });

      });

    }
    );
  }
  }
}
