import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Assignment/Assignment_Tile.dart';
import 'package:campus_link_teachers/Screens/Assignment/Leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignmentsUpload extends StatefulWidget {
  const AssignmentsUpload({Key? key}) : super(key: key);

  @override
  State<AssignmentsUpload> createState() => _AssignmentsUploadState();
}

class _AssignmentsUploadState extends State<AssignmentsUpload> with TickerProviderStateMixin{
  late TabController _tabController;
  int currTab=0;
  int pending=0;
  int notsubmitted=0;
  List<Widget> tabs=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs.add(AssignmentTile(notsubmitted: notsubmitted,pending: pending));
    tabs.add(const AssignmentsOverAllLeaderBoard());
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
                          width: size.width*0.1,
                          child: Image.asset("assets/images/assignment.png"),
                        ),
                        SizedBox(
                          width: size.width*0.02,
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: AutoSizeText(
                            "Assignments",
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
                          child: Image.asset("assets/images/leaderboard.png"),
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: AutoSizeText(
                            "Leaderboard",
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


                  // Container(
                  //   height: size.height * 0.06,
                  //   //width: size.width * 0.38,
                  //   decoration: BoxDecoration(
                  //       gradient: const LinearGradient(
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //         colors: [
                  //           Colors.blue,
                  //           Colors.purpleAccent,
                  //         ],
                  //       ),
                  //       borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //       border: Border.all(color: Colors.black, width: 2)),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         elevation: 0,
                  //         backgroundColor: Colors.transparent,
                  //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                  //     ),
                  //     onPressed: () {
                  //
                  //
                  //
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         const Icon(Icons.leaderboard_sharp,color: Colors.red),
                  //         FittedBox(
                  //           fit: BoxFit.cover,
                  //           child: AutoSizeText(
                  //             "Leaderboard",
                  //             style: TextStyle(
                  //                 fontSize: size.height * 0.02,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.white70
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   height: size.height * 0.06,
                  //   //width: size.width * 0.38,
                  //   decoration: BoxDecoration(
                  //       gradient: const LinearGradient(
                  //         begin: Alignment.topLeft,
                  //         end: Alignment.bottomRight,
                  //         colors: [
                  //           Colors.blue,
                  //           Colors.purpleAccent,
                  //         ],
                  //       ),
                  //       borderRadius: const BorderRadius.all(Radius.circular(20)),
                  //       border: Border.all(color: Colors.black, width: 2)),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         elevation: 0,
                  //         backgroundColor: Colors.transparent,
                  //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                  //     ),
                  //     onPressed: () {
                  //
                  //
                  //
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         const Icon(Icons.upload_sharp,color: Colors.red),
                  //         FittedBox(
                  //           fit: BoxFit.cover,
                  //           child: AutoSizeText(
                  //             "Upload Notes",
                  //             style: TextStyle(
                  //                 fontSize: size.height * 0.02,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.white70
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
      body: tabs[currTab]


    );
  }






}


