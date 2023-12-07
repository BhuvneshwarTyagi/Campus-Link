import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Sessional/Upload_Marks.dart';
import 'package:campus_link_teachers/Screens/Sessional/View_Marks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sessional extends StatefulWidget {
  const Sessional({Key? key}) : super(key: key);

  @override
  State<Sessional> createState() => _SessionalState();
}

class _SessionalState extends State<Sessional> with TickerProviderStateMixin{

  late TabController _tabController;
  int currTab=0;
  List<Widget> tab=[const ViewMarks(),const UploadMarks()];
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: size.height*0.07,
          flexibleSpace: SizedBox(
            height: size.height * 0.11,
            width: size.width * 1,
            child: Column(
              children: [
                SizedBox(height: size.height*0.01),
                TabBar(
                  indicatorColor: Colors.black,
                  labelColor: Colors.green,

                  controller: _tabController,
                  onTap: (value) {
                    setState(() {
                      currTab=value;
                    });
                  },
                  tabs: [
                    SizedBox(
                      height: size.height*0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width*0.08,
                            child: Image.asset("assets/images/viewmarks.png"),
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: AutoSizeText(
                              "View Marks",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width*0.08,
                            child: Image.asset("assets/images/uploadmarks.png"),
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: AutoSizeText(
                              "Upload Marks",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        body: tab[currTab]
    );
  }
}
