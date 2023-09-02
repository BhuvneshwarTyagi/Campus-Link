import 'dart:async';
import 'package:campus_link_teachers/push_notification/helper_notification.dart';
import 'package:campus_link_teachers/push_notification/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'Connection.dart';


const fetchBackground = "fetchBackground";

@pragma('vm:entry-point')
callbackDispatcherfordelevery() async {

  try{
    print(".......Starting workmanager executeTask   2.....");
    Workmanager().executeTask((taskName, inputData) async {
      try{
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        print(".............doc ${inputData?["channel"]}");
        print(".............stamp ${inputData?["stamp"]}");
        await FirebaseFirestore.instance.collection("Messages").doc(inputData?["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
            {
              "${inputData?["stamp"]}_delevered" : FieldValue.arrayUnion([
                {
                  "Email" : FirebaseAuth.instance.currentUser?.email,
                  "Stamp" : DateTime.now()
                }
              ])
            }
        );
      }
      catch (e){
        print("fucking error............................. $e ");
      }
      return Future.value(true);
    });

  }catch (e){
    print("..........error.........\n.........$e........");
  }
}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message");
  }

  print(".............from background handler.............");

  //NotificationServices.display(message);

  print(message.data["msg"]);
  if(message.data["msg"]=="true"){
    try{
      Workmanager().initialize(
        callbackDispatcherfordelevery,
      );
      print(".......workmanager");
      await Workmanager().registerOneOffTask("Develered", "Delevery",inputData: {
        "channel" :message.data["channel"],
        "stamp" : message.data["stamp"].toString().split(".")[0]
      });
    }catch(e){
      print("........Error from background handler.........");
    }
  }
}
@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage.............");
  if(message.data["msg"]=="true"){
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["stamp"].toString().split(".")[0]}_delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
  NotificationServices.display(message);

}@pragma('vm:entry-point')
Future<void> firebaseMessagingonmessageOpenedAppHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a onmessage message");
  }

  print(".............From onmessage Opened App.............");
  if(message.data["msg"]=="true"){
    await FirebaseFirestore.instance.collection("Messages").doc(message.data["channel"]).collection("Messages_Detail").doc("Messages_Detail").update(
        {
          "${message.data["stamp"].toString().split(".")[0]}_delevered" : FieldValue.arrayUnion([
            {
              "Email" : FirebaseAuth.instance.currentUser?.email,
              "Stamp" : DateTime.now()
            }
          ])
        }
    );
  }
  NotificationServices.display(message);

}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Workmanager().initialize(
  //   callbackDispatcherfordelevery(),
  // );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }



class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    NotificationServices.initialize(context);

    FirebaseMessaging.onMessage.listen(firebaseMessagingonmessageHandler);

    FirebaseMessaging.onBackgroundMessage.call(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingonmessageOpenedAppHandler);

  }

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
      // TODO: Handle this case.
      }
    } catch (e) {
      if (kDebugMode) {
        print('inside catch statement');
      }
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

