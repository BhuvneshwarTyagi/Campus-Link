import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class DownloadButton extends StatefulWidget {
  DownloadButton({Key? key,required this.downloadUrl,required this.pdfName,required this.path}) : super(key: key);
  String downloadUrl;
  String pdfName;
  String path;
  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final dio=Dio();
  double percent=0.0;
  bool isDownloading=false;
  bool isDownloaded=true;
  String? systempath='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSystemPath();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height*0.045,
      width: size.height*0.045,
      decoration: const BoxDecoration(
          shape: BoxShape.circle
      ),
      child: isDownloaded
          ?
      isDownloading
          ?
      Center(
        child: Center(
          child: CircularPercentIndicator(
            percent: percent,
            radius: size.width*0.045,
            animation: true,
            linearGradient: const LinearGradient(

                colors: [
                  //Colors.lightGreenAccent,
                  CupertinoColors.activeGreen,
                  CupertinoColors.activeGreen,
              CupertinoColors.activeGreen,
              Colors.red,
              Colors.red,
              Colors.deepOrange,

              Colors.orangeAccent,

            ]),
            animateFromLastPercent: true,
            curve: accelerateEasing,
            //progressColor: Colors.green,
            center: Text("${(percent*100).toDouble().toStringAsFixed(0)}%",style: GoogleFonts.openSans(fontSize: size.height*0.014),),
            //footer: const Text("Downloading"),
            backgroundColor: Colors.transparent,
          ),
        ),
      )
          :
      InkWell(
          onTap: () async {
           if(kIsWeb){
             html.AnchorElement anchorElement =  html.AnchorElement(href: widget.downloadUrl);
             anchorElement.download = widget.downloadUrl;
             anchorElement.click();
           }
           else{
             if(await checkPermissions()){
               File file=File("$systempath${widget.path}/${widget.pdfName}");
               await file.exists().then((value) async {
                 if(!value)
                 {
                   print(".Start");
                   setState(() {
                     isDownloading=true;
                   });
                   await dio.download(widget.downloadUrl,file.path,onReceiveProgress: (count, total) {
                     if(count==total){
                       setState(() {
                         isDownloaded=false;
                       });
                     }
                     else{
                       setState(() {
                         percent = (count/total);
                       });
                     }
                   },);
                 }
                 else{
                   print("..Already Exsist");
                 }
               });
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
                 description: "Please grant storage permission first to download documents",
                 // leading: const Icon(
                 //   Icons.error_outline_outlined,
                 //   color: Colors.red,
                 //   size: 55,
                 // )
               );
             }
           }
          },
          child: SizedBox(
            width: size.height*0.045,
              height: size.height*0.045,
              child: Image.asset("assets/images/download.png",fit: BoxFit.contain)))
          :
      const SizedBox(),
    );
  }
  Future<bool> checkPermissions() async {
    bool granted=false;
    if(Platform.isAndroid){
      granted=  await Permission.manageExternalStorage.isGranted;
      if(!granted){
        await Permission.manageExternalStorage.request();
      }
      granted = await Permission.accessMediaLocation.isGranted;
      if(!granted){
        await Permission.accessMediaLocation.request();
      }
      return (await Permission.manageExternalStorage.isGranted && await Permission.accessMediaLocation.isGranted);
    }
    if(Platform.isIOS){
      granted=  await Permission.mediaLibrary.isGranted;
      if(!granted){
        await Permission.mediaLibrary.request();
      }
      return await Permission.mediaLibrary.isGranted;
    }
    return false;
  }
  setSystemPath() async {
    Directory? directory;
    if(Platform.isAndroid){
      Directory? directory = await getExternalStorageDirectory();

      systempath = directory?.path.toString().substring(0, 19);

    }
    if(Platform.isIOS){
      directory= await getApplicationDocumentsDirectory();
      systempath = directory.path;
    }
    await check();
  }
  check(){
    File file=File("$systempath${widget.path}/${widget.pdfName}");
    if(file.existsSync()){
      setState(() {
        isDownloaded=false;
      });
    }
  }
}
