import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';

class FaceRecognize extends StatefulWidget {
  const FaceRecognize({super.key});

  @override
  State<FaceRecognize> createState() => _FaceRecognizeState();
}

class _FaceRecognizeState extends State<FaceRecognize> {



  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
  downloadModel() async {
    await FirebaseModelDownloader
        .instance
        .getModel("FaceDetection", FirebaseModelDownloadType.localModelUpdateInBackground)
        .then((value) async {
      String modelPath=value.file.path;
      // String? res = await Tflite.loadModel(
      //     model: modelPath,
      //     labels: "assets/labels.txt",
      //     numThreads: 1, // defaults to 1
      //     isAsset: false, // defaults to true, set to false to load resources outside assets
      //     useGpuDelegate: false // defaults to false, set to true to use GPU delegate
      // );
      // print(modelPath);
      // print(res);
    });
  }
}
