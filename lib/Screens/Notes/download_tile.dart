import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:io';
import '../../Constraints.dart';

class download extends StatefulWidget {
   download({Key? key,required this.downloadUrl,required this.pdfName,required this.path}) : super(key: key);
  String downloadUrl;
  String pdfName;
  String path;
  @override
  State<download> createState() => _downloadState();
}

class _downloadState extends State<download> {
  final dio=Dio();
  double percent=0.0;
  bool isDownloading=false;
  bool isDownloaded=true;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height*0.045,
      width: size.height*0.045,
      decoration: const BoxDecoration(
        shape: BoxShape.circle
      ),
      child: Center(
        child: Column(
          children: [
            isDownloaded
            ?
            isDownloading
            ?
            Center(
              child: Center(
                child: CircularPercentIndicator(
                  percent: percent,
                  radius: size.width*0.042,
                  animation: true,
                  animateFromLastPercent: true,
                  curve: accelerateEasing,
                  progressColor: Colors.green,
                  center: Text((percent*100).toDouble().toStringAsFixed(0),style: GoogleFonts.openSans(fontSize: size.height*0.017),),
                  //footer: const Text("Downloading"),
                  backgroundColor: Colors.transparent,
                ),
              ),
            )
            :
            InkWell(
                onTap: ()
                async {
                  File file=File("${widget.path}/${widget.pdfName}");
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

                },
                child: Icon(Icons.download_for_offline_outlined,color: Colors.black87,size:size.height*0.043))
                :
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
