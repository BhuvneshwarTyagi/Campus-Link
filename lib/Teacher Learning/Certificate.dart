import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../../Constraints.dart';

class Certificate extends StatefulWidget {
  const Certificate({super.key, required this.certificateName});
  final String certificateName;

  @override
  State<Certificate> createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  ScreenshotController ssController = ScreenshotController();
  String pdfName="";
  String path="";
  String? systempath='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSystemPath();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AutoSizeText(widget.certificateName),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
    )
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width :size.width*0.95,
            child: Screenshot(
              controller: ssController,
              child: Container(
                width: size.width*0.95,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(image: AssetImage("assets/images/Certificate.png"),fit: BoxFit.fitWidth)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height*0.14,
                    ),
                    AutoSizeText(usermodel["Name"],style: GoogleFonts.tiltNeon(color: Colors.black)),
                    SizedBox(
                      height: size.height*0.03,
                    ),
                    AutoSizeText(widget.certificateName),

                  ],
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: (){
                ssController.captureAndSave("${systempath!}/certificates/${widget.certificateName}.png");
              },
              icon: const Icon(Icons.download_for_offline_outlined,color: Colors.white,
              ),
          ),
        ],
      )
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

  }

}
