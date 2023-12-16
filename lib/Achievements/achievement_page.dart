import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Achievements/user_profile.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'all_post_section.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost>with TickerProviderStateMixin {
  late TabController _tabController;
  int currTab=0;
  List<Widget> tabs=[const AchievementPage(),const UserProfilePage()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: size.height*0.055,
            flexibleSpace: SizedBox(
              height: size.height * 0.11,
              width: size.width * 1,
              child: Column(
                children: [
                  //SizedBox(height: size.height*0.01),
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
                              width: size.width*0.062,
                              child: Image.asset("assets/icon/post.png"),
                            ),
                            SizedBox(
                              width: size.width*0.02,
                            ),
                            AutoSizeText(
                              "New Post",
                              style: GoogleFonts.tiltNeon(
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
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
                              child: Image.asset("assets/icon/user_profile.png"),
                            ),
                            FittedBox(
                              fit: BoxFit.cover,
                              child: AutoSizeText(
                                "My Profile",
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
          body: Center(
            child: SizedBox(
              width: size.width*0.97,
                child: tabs[currTab]
            ),
          )


      ),
    );
  }
}
