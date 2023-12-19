import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Hod%20Panel/StudentsList.dart';
import 'package:campus_link_teachers/Hod%20Panel/Teachers_List.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Screens/Navigator.dart';

class HODPanel extends StatefulWidget {
  const HODPanel({super.key});

  @override
  State<HODPanel> createState() => _HODPanelState();
}

class _HODPanelState extends State<HODPanel> with TickerProviderStateMixin{
  late TabController _tabController;
  int currTab=0;
  List<Widget> tabs=[const TeachersList(),const StudentsList()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*tabs.add(const TeachersList());
    tabs.add(const StudentsList());*/
    _tabController=TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromRGBO(86, 149, 178, 1),

          const Color.fromRGBO(68, 174, 218, 1),
          Colors.deepPurple.shade300
        ],
      ),
    ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return const Nevi();
              },));
            },
          ),
          title: AutoSizeText("HOD Panel",style: GoogleFonts.tiltNeon(
            fontWeight: FontWeight.w500,
            fontSize: size.width*0.055,
            color: Colors.black
          ),),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
              width: size.width * 1,
              child: Column(
                children: [
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
                                "Teachers",
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
                                "Students",
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
            SizedBox(
              child: tabs[currTab],
            )
          ],
        ),
      ),
    );
  }
}
