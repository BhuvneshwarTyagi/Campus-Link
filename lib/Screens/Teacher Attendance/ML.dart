import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../Constraints.dart';
import '../../Database/database.dart';
import '../../Screens/loadingscreen.dart';


class MlKit {

Future<void> uploadSampleImage(List<String> imageList,BuildContext context)
async {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return const loading(text: "Data Is Uploading please Wait..");
  },));
  List<String>urlList=[];

  Reference reference=FirebaseStorage.instance.ref();


  Reference imageDirectory=reference.child("Machine Learning");


  Reference pdfFolder=imageDirectory.child("$university_filter $college_filter $branch_filter $year_filter $section_filter $subject_filter");

  for(var path in imageList)
    {
      String filename= path.toString().split("/").last;
      Reference channel=pdfFolder.child(filename);
      TaskSnapshot snap= await channel.putFile(File(path));
      await snap.ref.getDownloadURL().then((value) {
        urlList.add(value);
      });
    }
  for(var path in imageList)
    {
      File(path).delete(recursive: true);
    }

  FirebaseFirestore.instance.collection("Teachers").doc("${usermodel["Email"]}")
      .update({
    "SampleImageUrl":urlList
  }).whenComplete(() {
    print("uploaded.....");
    Navigator.pop(context);
    Navigator.pop(context);
  });



}

bool checkTime()
{
  String startTime="0";
  String endTime="24";
  TimeOfDay currTime=TimeOfDay.now();
  print("Currtime is : ${currTime.hour<int.parse(endTime)} ${currTime.hour} ${currTime.hour}");
  if(currTime.hour>=int.parse(startTime) && currTime.hour<=int.parse(endTime))
  {
    return true;
  }
  return false;
}
  Future<bool> checkDistance()async {
  bool underRadius=false;
 GeoPoint collegePoint=const GeoPoint(29.6593457, 18.9834729);
 await database().getloc().whenComplete(() {
   final distance=Geolocator.distanceBetween(double.parse(tecloc.latitude.toStringAsPrecision(21)),double.parse(tecloc.longitude.toStringAsPrecision(21)), collegePoint.latitude-10, collegePoint.longitude+10) ;
   if(distance>100)
     {
       underRadius=true;
     }
 });
 return underRadius;
  }

  Future<String>faceRecognize(String imagePath)
  async {
      String result;
      var prediction;
      var url = Uri.parse('https://facerecognizeapi.onrender.com/predict');

      var request = http.MultipartRequest('POST', url)..files.add(await http.MultipartFile.fromPath('file', imagePath ?? ""));

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseBody);

          // Assuming the response has a key named 'prediction'
           prediction = jsonResponse['predictions'];

          print('Prediction: $prediction');        } else {

          print('HTTP Error: ${response.statusCode}');
        }
      } catch (error) {

        print('Error: $error');
      }
      print("return false...");

      return prediction;
  }
Future<bool?> sendImage(String? imageFilePath) async {
  bool? result;
  var url = Uri.parse('https://train-7w8l.onrender.com/detect_faces');

  var request = http.MultipartRequest('POST', url)..files.add(await http.MultipartFile.fromPath('file', imageFilePath ?? ""));

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      File outputFile = File(imageFilePath!);
      print("successful");
      await response.stream.toBytes().then((value) async {
        print(" response is :${value.toString()}");
        await outputFile.writeAsBytes(value.toList()).whenComplete(() {
          print("return true...");
          result =true;
        });
      });

    } else {
      result=false;
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (error) {
    result=false;
    print('Error: $error');
  }
  print("return false...");
  return result;
}
}