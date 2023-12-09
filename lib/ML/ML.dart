//
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// class MlKit {
//  /* Future<List<Face>?> detectFacesFromImage(CameraImage image,
//       CameraController controller, FaceDetector _faceDetector) async {
//
//     _faceDetector.processImage(
//         InputImage.fromBytes(
//           bytes: Uint8List.fromList(
//             image.planes.fold(
//                 <int>[],
//                     (List<int> previousValue, element) =>
//                 previousValue..addAll(element.bytes)),
//           ),
//           inputImageData:InputImageData(
//             inputImageFormat:InputImageFormatMethods.fromRawValue(image.format.raw)!,
//             size: Size(image.width.toDouble(), image.height.toDouble()),
//             imageRotation: rotation,
//             planeData: image.planes.map(
//                   (Plane plane) {
//                 return InputImagePlaneMetadata(
//                   bytesPerRow: plane.bytesPerRow,
//                   height: plane.height,
//                   width: plane.width,
//                 );
//               },
//             ).toList(),
//           ), metadata: InputImageMetadata(rotation: InputImageRotation.rotation0deg,size: const Size(64, 64),
//         bytesPerRow: ),
//         ),
//
//     }*/
//
//
//
//
//
//
//
// Future<List<Face>> detectFacesFromImage(CameraImage image) async {
//
//   String? res = await Tflite.loadModel(
//         model: "assets/images/model.tflite",
//         labels: "assets/images/labels.txt",
//         numThreads: 1, // defaults to 1
//         isAsset: true, // defaults to true, set to false to load resources outside assets
//         useGpuDelegate: false // defaults to false, set to true to use GPU delegate
//     );
//   print(res);
//
//
//     final faceDetector = GoogleMlKit.vision.faceDetector(
//        const FaceDetectorOptions(
//         mode: FaceDetectorMode.accurate,
//         enableLandmarks: true,
//       ),
//     );
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//     print("..................///////////////////////////Byte:$bytes");
//
//     Tflite.runModelOnBinary(
//         binary: bytes,
//     ).then((value) {
//       print("Result: $value");
//     });
//     final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//     final inputImageFormat =
//         InputImageFormatMethods.fromRawValue(image.format.raw) ??
//             InputImageFormat.NV21;
//     final planeData = image.planes.map(
//           (Plane plane) {
//         return InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       },
//     ).toList();
//
//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: InputImageRotation.Rotation_0deg,
//       inputImageFormat: inputImageFormat,
//       planeData: planeData,
//     );
//
//     return  faceDetector.processImage(
//       InputImage.fromBytes(
//           bytes: bytes,
//           inputImageData:inputImageData
//       ),
//     );
// }
// }