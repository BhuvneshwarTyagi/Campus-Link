import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Constraints.dart';


List months = [
  "January",
  "Feburary",
  "March",
  "April",
  "May",
  "June",
  "July",
  'August',
  "September",
  "October",
  "November",
  "December"
];




class database {

  Future signOut() async {
    try {
      return FirebaseAuth.instance.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String?> email() async {
    return await FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> getloc() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      print("enabled permission");
    } else {
      print('not enabled ermission');
    }
    var status = await Permission.location.status;
    if (status.isGranted) {
      print("Granted");
    } else if (status.isDenied) {
      Map<Permission, PermissionStatus> status = await [Permission.location].request();
    }
    if (await Permission.location.isPermanentlyDenied ||
        await Permission.location.isRestricted) {
      openAppSettings();
    }

    tecloc= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  // Future getUserData() async {
  //   List userdetail = [];
  //   User? user = await FirebaseAuth.instance.currentUser;
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("Teachers")
  //         .doc(user!.email)
  //         .get()
  //         .then((value) {
  //       userdetail.add(value.data()!);
  //     });
  //
  //     return userdetail;
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // Future<void> fetchuserdata() async {
  //   try {
  //     dynamic result = await getUserData();
  //     if (result != null) {
  //       teacher_data = result;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
}
