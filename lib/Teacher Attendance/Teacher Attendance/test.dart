import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class detectFace extends StatefulWidget {

  const detectFace({ required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription>? cameras;
  @override
  _detectFaceState createState() => _detectFaceState();
}

class _detectFaceState extends State<detectFace> {
  // for camera
  late CameraController _cameraController;
  XFile? pictureFile;
  bool show=false;
  // for ml model


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
          Column(
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
                    show ? Image.file(File(pictureFile!.path)) :CameraPreview(_cameraController)
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
                      "Count : ",
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

                        // bool faceDetected = true;
                        // _cameraController.startImageStream(
                        //         (image){
                        //           MlKit().detectFacesFromImage(image);
                        //           return image;});
                        pictureFile =await _cameraController.takePicture();
                        print(pictureFile?.path);
                        _sendImage(pictureFile?.path);

                      },
                      child: const Text('Capture Image'),
                    ),
                  ),
                ],
              ),
            ],
          )


        ],
      ),
    );
  }
  Future<void> _sendImage(String? imageFilePath) async {
    var url = Uri.parse('https://train-7w8l.onrender.com/detect_faces');

    var request = http.MultipartRequest('POST', url)..files.add(await http.MultipartFile.fromPath('file', imageFilePath ?? ""));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        File outputFile = File(imageFilePath!);
        print("successful");
        await response.stream.toBytes().then((value) async {
          await outputFile.writeAsBytes(value.toList()).whenComplete(() {
            setState(() {
              show=true;
            });
          });
        });

      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
