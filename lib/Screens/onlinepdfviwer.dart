import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class OnlinePdfViewer extends StatefulWidget {




  const OnlinePdfViewer({super.key, required this.url,required this.name});
  final String url;
  final String name;
  @override
  State<OnlinePdfViewer> createState() => _OnlinePdfViewerState();
}

class _OnlinePdfViewerState extends State<OnlinePdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
 backgroundColor: Colors.transparent,
        title:  Text("${widget.name}"),
      ),
      body: Container(
        color: Colors.black,

        child: const PDF().fromUrl(
            widget.url,

            placeholder: (error)=>Center(child: Text(error.toString(),
            ),
            )
        ),
      ),
    );
  }
}
