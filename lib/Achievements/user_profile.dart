import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import 'liked_posts.dart';
import 'my_posts.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key,}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>  with TickerProviderStateMixin{
  List<Widget> tabs=[const MyPost(),const LikedPost()];
  late TabController _tabController;
  int currTab=0;
  int likedPost=0;
  int myPostCount=0;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: size.height*0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width*0.022,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: size.height*0.065,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: size.height*0.062,

                          backgroundImage:usermodel["Profile_URL"]!=null?

                          NetworkImage(usermodel["Profile_URL"])
                              :
                          null,
                          // backgroundColor: Colors.teal.shade300,
                          child: usermodel["Profile_URL"]==null?
                          AutoSizeText(
                            usermodel["Name"].toString().substring(0,1),
                            style: GoogleFonts.exo(
                                fontSize: size.height * 0.05,
                                fontWeight: FontWeight.w600),
                          )
                              :
                          null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width*0.3,
                  ),
                  SizedBox(
                    height: size.height*0.095,
                    width: size.width*0.35,
                    child: StreamBuilder(
                      stream:  FirebaseFirestore.instance
                          .collection("Achievements").where("Email",isEqualTo: usermodel["Email"])
                          .orderBy("Time-Stamp", descending: true)
                          .orderBy("Likes", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                       if(snapshot.hasData) {
                         likedPost = 0;
                         myPostCount = 0;
                         for (int i = 0; i < snapshot.data!.docs.length; i++) {
                           if (snapshot.data!.docs[1].data()["Email"]==usermodel["Email"]) {
                             myPostCount++;
                           }
                           if (snapshot.data!.docs[1].data()["Liked by"]!=null &&
                           snapshot.data!.docs[1].data()["Liked by"]
                               .contains(usermodel["Email"])){
                             likedPost++;
                           }
                         }
                       }
                       return snapshot.hasData && snapshot.data!=null?
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Column(
                             children: [
                               Container(
                                 height: size.height*0.041,
                                 width: size.height*0.041,
                                 color: Colors.transparent,
                                 child: AutoSizeText(
                                   "$likedPost",
                                   style: GoogleFonts.exo(
                                       fontSize: size.height*0.026,
                                       color: Colors.white,
                                       fontWeight: FontWeight.w500
                                   ),
                                 ),

                               ),
                               SizedBox(
                                 height: size.height*0.012,
                               ),
                               Container(
                                   height: size.height*0.041,
                                   width: size.height*0.041,
                                   color: Colors.transparent,
                                   child:AutoSizeText(
                                     "Like",style: GoogleFonts.aBeeZee(
                                       fontSize: size.height*0.03
                                   ),
                                   )
                                 /* Image.asset("assets/icon/like.png",fit: BoxFit.cover,scale: 5,),*/
                               )
                             ],
                           ),
                           SizedBox(
                             width: size.width*0.09,
                           ),
                           Column(
                             children: [
                               Container(
                                 height: size.height*0.041,
                                 width: size.height*0.041,
                                 color: Colors.transparent,
                                 child: AutoSizeText(
                                   "$myPostCount",
                                   style: GoogleFonts.exo(
                                       fontSize: size.height*0.026,
                                       color: Colors.white,
                                       fontWeight: FontWeight.w500
                                   ),
                                 ),

                               ),
                               SizedBox(
                                 height: size.height*0.012,
                               ),
                               Container(
                                   height: size.height*0.041,
                                   width: size.height*0.041,
                                   color: Colors.transparent,
                                   child:AutoSizeText(
                                     "Post",style: GoogleFonts.aBeeZee(
                                       fontSize: size.height*0.035
                                   ),
                                   )
                                 /* Image.asset("assets/icon/like.png",fit: BoxFit.cover,scale: 5,),*/
                               )
                             ],
                           )
                         ],
                       )
                           :
                       const SizedBox();

                    },),
                  )
                ],
              ),
              SizedBox(
                height: size.height*0.023,
              ),
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
                          width: size.width*0.06,
                          child: Image.asset("assets/icon/post.png"),
                        ),
                        SizedBox(
                          width: size.width*0.02,
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: AutoSizeText(
                            "My Posts",
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
                          width: size.width*0.064,
                          child: Image.asset("assets/icon/like.png"),
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: AutoSizeText(
                            "Liked Posts",
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
              Container(
                height: size.height*1,
                color: Colors.transparent,
                child: tabs[currTab],
              )

            ],
          ),
        ),
      ),
    );
  }
}
