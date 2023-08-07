import 'dart:async';
import 'package:campus_link_teachers/push_notification/helper_notification.dart';
import 'package:campus_link_teachers/push_notification/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'Connection.dart';

// void callbackDispatcher(){
//   Workmanager().executeTask((taskName, inputData) async {
//     print("\n\n\n working");
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//    await FirebaseFirestore.instance.collection("testing").doc("${DateTime.now().minute}").set({
//      "Success":true
//    });
//
//     return Future.value(true);
//   });
// }
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  NotificationServices.display(message);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().whenComplete(() async {
    await FirebaseFirestore.instance.collection("Students").doc('bhanu68tyagi@gmail.com').update({
      "Name":"${TimeOfDay.now().minute}"
    });
  });
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // var cron = Cron();
  // try{
  //   cron.schedule(Schedule.parse("* * * * *"),() async {
  //   print("\n\n\n working");
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //  await FirebaseFirestore.instance.collection("testing").doc("${DateTime.now().minute}").set({
  //    "Success":true
  //  });
  // });
  // }catch(e){
  //   print(e);
  // }
  //Workmanager().initialize(callbackDispatcher);
  // await FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
//   print(message.data);
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   if(message.data['body']=='attendance'){
//     await FirebaseFirestore.instance
//         .collection("testing")
//         .doc(message.data['body'])
//         .update({"worked": FieldValue.arrayUnion([true])});
//   }
//   else{
//     await FirebaseFirestore.instance
//         .collection("testing")
//         .doc(message.data['body'])
//         .set({"worked": FieldValue.arrayUnion([true])});
//   }
//   print(".............");
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();



    //WidgetsBinding.instance.addObserver(WidgetsBindingObserver);

    // if (Platform.isIOS) {
    //   print('platform is IOS');
    //   FirebaseMessaging.instance
    //       .requestPermission(sound: true, badge: true, alert: true);
    // }

    NotificationServices.initialize(context);

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   // if (message != null) {
    //   //   final routeFromMessage = message.data["route"];
    //
    //   //   Navigator.of(context).pushNamed(routeFromMessage);
    //   // }
    // });

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      NotificationServices.display(message);
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp().whenComplete(() async {
        await FirebaseFirestore.instance.collection("Students").doc('bhanu68tyagi@gmail.com').update({
          "Name":"${TimeOfDay.now().minute}"
        });
      });

    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      NotificationServices.display(message);
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp().whenComplete(() async {
        await FirebaseFirestore.instance.collection("Students").doc('bhanu68tyagi@gmail.com').update({
          "Name":"${TimeOfDay.now().minute}"
        });
      });
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   //final routeFromMessage = message.data["route"];
    //
    //   //Navigator.of(context).pushNamed(routeFromMessage);
    // });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   //WidgetsBinding.instance.removeObserver();
  // }


  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      //super.didChangeAppLifecycleState(state);
      switch (state) {
        case AppLifecycleState.resumed:
          NotificationServices().setUserState(userState: UserState.Online);

          break;
        case AppLifecycleState.inactive:
          NotificationServices().setUserState(userState: UserState.Offline);
          break;
        case AppLifecycleState.paused:
          NotificationServices().setUserState(userState: UserState.Waiting);
          break;
        case AppLifecycleState.detached:
          NotificationServices().setUserState(userState: UserState.Offline);
          break;
      }
    } catch (e) {
      print('inside catch statement');
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(213, 97, 132, 1),
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Checkconnection(),
      builder: InAppNotifications.init(),
    );
  }
}

