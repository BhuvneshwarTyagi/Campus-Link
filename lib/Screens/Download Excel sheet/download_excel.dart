import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadExcelSheet extends StatefulWidget {
  const DownloadExcelSheet({Key? key}) : super(key: key);

  @override
  State<DownloadExcelSheet> createState() => _DownloadExcelSheetState();
}

class _DownloadExcelSheetState extends State<DownloadExcelSheet> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: AutoSizeText(
          "Select Option",
          style: GoogleFonts.exo(
            fontSize: size.height*0.022,
            color: Colors.black
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.folder,color: Colors.yellow,size: size.height*0.025,),
            title: AutoSizeText(
              "Attendance Excel Sheet",
              style: GoogleFonts.exo(
                  fontSize: size.height*0.022,
                  color: Colors.black
              ),
            ),
          )

        ],
      ),
    );
  }
}
