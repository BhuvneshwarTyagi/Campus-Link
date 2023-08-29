import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ImageTile extends StatefulWidget {
  const ImageTile(
      {super.key,
      required this.channel,
      required this.imageURL,
      required this.compressedURL,
      required this.stamp});
  final String channel;
  final String imageURL;
  final String compressedURL;
  final DateTime stamp;

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  final dio=Dio();
  bool _downloaded = false;
  File _imagePath=File("");
  final ReceivePort _port = ReceivePort();

  String? downloadTaskId;

  int downloadTaskStatus = 0;

  int downloadTaskProgress = 0;

  bool isDownloading = false;
  @override
  void initState() {
    super.initState();
    _downloaded
    ?
        null
    :
        check();
    //initDownloadController();
    //downloadFile(url: "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //print("build     ${imagePath}");
    return _downloaded
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.008, vertical: size.height * 0.003),
            child: ClipRect(
              child: Container(
                width: size.width*0.55,
                height: size.height*0.3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    image: FileImage(_imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Colors.white.withOpacity(0.0),
                    ),
                  ),
                ),
              ),
            ),
            // ClipRect(
            //   child: Stack(
            //     children: [
            //       Container(
            //         height: size.height*0.3,
            //         width: size.width*0.55,
            //         decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.5),
            //           borderRadius: const BorderRadius.all(Radius.circular(12)),
            //           border: Border.all(color: Colors.black, width: 2),
            //           //  image: DecorationImage(image: FileImage(imagePath)),
            //         ),
            //         child: Image(image: FileImage(imagePath)),
            //       ),
            //       Container(
            //         height: size.height*0.3,
            //         width: size.width*0.55,
            //         child: BackdropFilter(
            //           filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
            //           child: Con,
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
          )
        : IconButton(onPressed: (){setState(() {
          _downloaded=true;
        });}, icon: const Icon(Icons.refresh));
  }


  check() async {
    Directory? directory = await getApplicationCacheDirectory();
    String additionalPath= "/thumbnail";
    directory = Directory("${directory.path}$additionalPath");

    if(directory.existsSync()){
      print("Directory exist");
    }
    else{
      await directory.create();
    }

    _imagePath=File("${directory.path}/${widget.stamp}.png");

    if(await _imagePath.exists()){
      print("image exist");
      setState(() {
        _downloaded=true;
      });
    }
    else{
       // downloadTaskId =  await FlutterDownloader.enqueue(
       //        url: widget.compressedURL,
       //        fileName: "${widget.stamp}.png",
       //        savedDir: directory.path
       //    ) ;
      var  response = await dio.download(widget.compressedURL, _imagePath.path,onReceiveProgress: (count, total) {
        if(count==total){
          setState(() {
            _downloaded=true;
          });
        }
      },);


    }


  }

  initDownloadController() {
    _bindBackgroundIsolate();
  }

  disposeDownloadController() {
    _unbindBackgroundIsolate();
  }
  _bindBackgroundIsolate() async {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort, 'downloader_send_port',
    );


    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    else {
      _port.listen((message) {
        setState(
              () {
            downloadTaskId = message[0];
            downloadTaskStatus = message[1];
            downloadTaskProgress = message[2];
            if(message[2]==100){
              setState(() {
                _downloaded=true;
              });
            }
          },
        );

        if (message[1] == 2) {
          isDownloading = true;
        } else {
          isDownloading = false;
        }
      });
      await FlutterDownloader.registerCallback(registerCallback);
    }
  }


  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }


  @pragma('vm:entry-point')
  static registerCallback(String id, int status, int progress) {
    /// reference https://www.scaler.com/topics/flutter-downloader/
    final SendPort? send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  Future<void> downloadFile({required String url}) async {

    setState(() {
      isDownloading = true;
    });

    check();
  }

  Future pauseDownload() async {
    await FlutterDownloader.pause(taskId: downloadTaskId ?? '');
  }

  Future resumeDownload() async {
    await FlutterDownloader.resume(taskId: downloadTaskId ?? '');
  }

  Future cancelDownload() async {
    await FlutterDownloader.cancel(taskId: downloadTaskId ?? '');
    setState(() {
      isDownloading = false;
    });
  }

  String getDownloadStatusString() {
    late String downloadStatus;

    switch (downloadTaskStatus) {
      case 0:
        downloadStatus = 'Undefined';
        break;
      case 1:
        downloadStatus = 'Enqueued';
        break;
      case 2:
        downloadStatus = 'Downloading';
        break;
      case 3:
        downloadStatus = 'Failed';
        break;
      case 4:
        downloadStatus = 'Canceled';
        break;
      case 5:
        downloadStatus = 'Paused';
        break;
      default:
        downloadStatus = "Error";
    }

    return downloadStatus;
  }

}
