
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;

import '../../Constraints.dart';
import '../../Database/database.dart';
import '../../Screens/loadingscreen.dart';


class MlKit {


Future<List<Face>> detectFacesFromImage(CameraImage image) async {
 final faceDetector = GoogleMlKit.vision.faceDetector(
       const FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
      ),
    );
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final inputImageFormat = InputImageFormatMethods.fromRawValue(image.format.raw) ?? InputImageFormat.NV21;
    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: InputImageRotation.Rotation_0deg,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    print(await faceDetector.processImage(
    InputImage.fromBytes(
    bytes: bytes,
        inputImageData:inputImageData
    ),
  ));
    return  faceDetector.processImage(
      InputImage.fromBytes(
          bytes: bytes,
          inputImageData:inputImageData
      ),
    );
}


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
      const String apiUrl = 'YOUR_API_ENDPOINT';
      const String imagePath = 'YOUR_IMAGE_PATH';
      final File imageFile = File(imagePath);
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          final String responseData = await response.stream.bytesToString();
          final Map<String, dynamic> decodedResponse = json.decode(responseData);
          result=decodedResponse.toString();
          print('API Response: $decodedResponse');
        } else {
          // Request failed
          result=response.reasonPhrase.toString();
          print('Error: ${response.reasonPhrase}');
        }
      } catch (error) {
        result=error.toString();
        print('Error sending request: $error');
      }
      return result;
  }
}