import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ML.dart';


class TakeSampleImage extends StatefulWidget {

  const TakeSampleImage({ required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription>? cameras;
  @override
  _TakeSampleImageState createState() => _TakeSampleImageState();
}

class _TakeSampleImageState extends State<TakeSampleImage> {
  // for camera
  late CameraController _cameraController;
  XFile? pictureFile;

  // for ml model


  List<String> filePath = [];
  int currIndex = 0;

  @override
  void initState() {
    super.initState();
    print("Available cameras are : ${widget.cameras}");
    _cameraController = CameraController(
      widget.cameras![1],
      ResolutionPreset.high,
    );
    _cameraController.setFlashMode(FlashMode.off);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Upload Your Sample Image"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.002,
          ),
          filePath.length < 22
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: size.height * 0.65,
                          width: size.width * 1,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black45,
                            width: 2,
                          )),
                          child:_cameraController.value.isInitialized
                          ?
                          CameraPreview(_cameraController)
                          :
                              const CircularProgressIndicator(
                                  color:Colors.black ,backgroundColor: Colors.white70)
                          ,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.04,
                        ),
                        SizedBox(
                          child: AutoSizeText(
                            "Count : ${filePath.length} / 22",
                            style: GoogleFonts.exo(
                                color: Colors.black,
                                fontSize: size.height * 0.02),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.14,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              bool faceDetected = true;
                              pictureFile =
                                  await _cameraController.takePicture();
                              print("Image Path is: ${pictureFile?.path}");
                              if (pictureFile?.path != null) {
                                setState(() {
                                  filePath.add(pictureFile!.path);
                                });
                              }
                            },
                            child: const Text('Capture Image'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: size.height * 0.65,
                          width: size.width * 0.98,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black45,
                            width: 2,
                          )),
                          child: Center(
                              child: Image.file(File(filePath[currIndex]),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: AutoSizeText(
                            "Count : ${filePath.length} / 22",
                            style: GoogleFonts.exo(
                                color: Colors.black,
                                fontSize: size.height * 0.02),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                File(filePath[currIndex]).delete(recursive: true);
                                filePath.removeAt(currIndex);
                              });
                            },
                            child: const Text('Retake Image'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (filePath.length == 22) {
                                _cameraController.dispose();
                                MlKit().uploadSampleImage(filePath,context);

                              } else {
                                InAppNotifications.instance
                                  ..titleFontSize = 25.0
                                  ..descriptionFontSize = 15.0
                                  ..textColor = Colors.black
                                  ..backgroundColor =
                                      const Color.fromRGBO(150, 150, 150, 1)
                                  ..shadow = true
                                  ..animationStyle =
                                      InAppNotificationsAnimationStyle.scale;
                                InAppNotifications.show(
                                    title: 'Error',
                                    duration: const Duration(seconds: 2),
                                    description:
                                        "Please Take & photos",
                                    leading: const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 40,
                                    ));
                              }
                            },
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          SizedBox(
            height: size.height * 0.085,
            width: size.width * 0.99,
            child: Center(
              child: ListView.builder(
                itemCount: filePath.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          currIndex = index;
                        });
                      },
                      child: Container(
                        width: size.width * 0.12,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: currIndex == index
                                  ? Colors.red
                                  : Colors.black,
                              width: 2),
                        ),
                        child: Image.file(File(filePath[index]),
                            fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
