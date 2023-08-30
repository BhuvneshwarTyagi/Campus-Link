import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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

  int downloadTaskStatus = 0;
  bool downloaded=false;
  double percent=0;
  bool isDownloading = false;
  double x=8,y=8;
  @override
  void initState() {
    super.initState();
    _downloaded
    ?
        null
    :
        check();
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
                  filter: ImageFilter.blur(sigmaX: x, sigmaY: y),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Colors.white.withOpacity(0.0),
                    ),
                    child: downloaded
                        ?
                    const SizedBox()
                        :
                    isDownloading
                        ?
                    CircularPercentIndicator(
                      percent: percent,
                      radius: size.width*0.08,
                      animation: true,
                      animateFromLastPercent: true,
                      curve: accelerateEasing,
                      progressColor: Colors.green,
                      center: Text("${(percent*100).toStringAsFixed(2)}%"),
                      footer: const Text("Downloading"),
                      backgroundColor: Colors.transparent,
                    )
                        :
                    IconButton(
                        onPressed: (){
                          downloadImage();
                          setState(() {
                            isDownloading=true;
                          });
                        },
                        icon: const Icon(Icons.download)
                    )
                    ,
                  ),
                ),
              ),
            ),

          )
        : const SizedBox();
  }


  check() async {
    Directory? directory = await getApplicationCacheDirectory();
    String additionalPath= "/images";
    directory = Directory("${directory.path}$additionalPath");
    _imagePath=File("${directory.path}/${widget.stamp}.png");
      if(await _imagePath.exists()){
        print("image exist original");
        setState(() {
          _downloaded=true;
          x=0;
          y=0;
          downloaded=true;
        });
      }

    else{
      print("original not exist");
      directory = await getApplicationCacheDirectory();
      additionalPath= "/thumbnail";
      directory = Directory("${directory.path}$additionalPath");

      if(directory.existsSync()){
        print("Directory exist");
      }
      else{
        print("thumbnail not exist");
        await directory.create();
      }

      _imagePath=File("${directory.path}/${widget.stamp}.png");

      if(await _imagePath.exists()){
        print("image exist thumbnail image");
        setState(() {
          _downloaded=true;
        });
      }
      else{
        print("Downloading thumbnail");
        await dio.download(widget.compressedURL, _imagePath.path,onReceiveProgress: (count, total) {
          if(count==total){
            setState(() {
              _downloaded=true;
            });
          }
        },);


      }
    }




  }



  downloadImage() async {
    Directory directory = await getApplicationCacheDirectory();
    String additionalPath= "/images";
    directory = Directory("${directory.path}$additionalPath");

    if(directory.existsSync()){
      print("Directory exist");
    }
    else{
      await directory.create();
    }

    File imagePath=File("${directory.path}/${widget.stamp}.png");



    await dio.download(widget.imageURL, imagePath.path,onReceiveProgress: (count, total) {
    if(count==total){
    setState(() {
      _imagePath=imagePath;
      x=0;
      y=0;
      downloaded=true;
    });
    }
    else{
      setState(() {
        isDownloading=true;
        percent = (count/total);
      });
    }
    },);

  }

}
