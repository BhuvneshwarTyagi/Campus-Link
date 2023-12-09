//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// import 'ML.dart';
//
// class CameraPage extends StatefulWidget {
//
//    const CameraPage({required this.cameras, Key? key}) : super(key: key);
//    final List<CameraDescription>? cameras;
//   @override
//   _CameraPageState createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   // for camera
//    late CameraController _cameraController;
//   XFile? pictureFile;
//
//   // for ml model
//    late FaceDetector _faceDetector;
//    List<Face>detectedFace=[];
//
//   @override
//   void initState() {
//     super.initState();
//     print("Available cameras are : ${widget.cameras}");
//     _cameraController = CameraController(
//       widget.cameras![1],
//       ResolutionPreset.high,
//     );
//     _cameraController.setFlashMode(FlashMode.off);
//     _cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//     _faceDetector=GoogleMlKit.vision.faceDetector(
//       const FaceDetectorOptions(
//         mode: FaceDetectorMode.accurate
//       )
//     );
//
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size=MediaQuery.of(context).size;
//     print("I am Here.");
//     if (!_cameraController.value.isInitialized) {
//       return const SizedBox(
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey,
//         title: const Text("Take Picture"),
//         centerTitle: true,
//       ),
//       body:Column(
//         children: [
//           SizedBox(
//             height: size.height*0.075,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: SizedBox(
//                 height: size.height*0.54,
//                 width: size.width*0.95,
//                 child: CameraPreview(_cameraController),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () async {
//                 bool faceDetected=true;
//                 // await _cameraController.takePicture().then((image) async {
//                 //   if(faceDetected){
//                 //     await MlKit().detectFacesFromImage(_cameraController.).whenComplete(() {
//                 //       //faceDetected=false;
//                 //       _cameraController.stopImageStream();
//                 //     }).then((value){
//                 //       print("Face: $value");
//                 //     });
//                 //     //print("Face are :${detectedFace}");
//                 //   }
//                 // });
//                 _cameraController.startImageStream((image) async {
//                   //_cameraController.stopImageStream();
//                   if(faceDetected){
//                    await MlKit().detectFacesFromImage(image).whenComplete(() {
//                         faceDetected=false;
//                         _cameraController.stopImageStream();
//                     }).then((value){
//                       print("Face: $value");
//                    });
//                    //print("Face are :${detectedFace}");
//                   }
//                 });
//               },
//               child: const Text('Capture Image'),
//             ),
//           ),
//           /*if (pictureFile != null)
//           Image.network(
//             pictureFile!.path,
//             height: size.height,
//           )*/
//           //Android/iOS
//           // Image.file(File(pictureFile!.path)))
//         ],
//       ),
//     );
//   }
// }
