import 'package:campus_link_teachers/Constraints.dart';
import 'package:campus_link_teachers/Database/database.dart';
import 'package:campus_link_teachers/Screens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:searchfield/searchfield.dart';

class DeanPanel extends StatefulWidget {
  const DeanPanel({Key? key}) : super(key: key);

  @override
  State<DeanPanel> createState() => _DeanPanelState();
}

class _DeanPanelState extends State<DeanPanel> {


  late TextEditingController universityController = TextEditingController();
  List<dynamic> university = [];
  final FocusNode univf = FocusNode();

  late TextEditingController clgController = TextEditingController();
  TextEditingController courseController=TextEditingController();
  TextEditingController branchController=TextEditingController();
  List<dynamic> clg = [];
  final FocusNode clgf = FocusNode();
  final FocusNode branchFocus=FocusNode();
  List<dynamic> branch = [];
  List<dynamic> course = [];
  final FocusNode coursef = FocusNode();
  final FocusNode emailfn = FocusNode();
  TextEditingController emailController=TextEditingController();

  final FocusNode buttonf = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    fetchUniversity();
    super.initState();
  }

  final textStyle = GoogleFonts.alegreya(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(86, 149, 178, 1),
            // Color.fromRGBO(86, 149, 178, 1),
            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'Create HOD',
                textStyle: GoogleFonts.openSans(
                    color: Colors.white54,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    shadows: <Shadow>[
                      const Shadow(
                        offset: Offset(1, 1),
                        color: Colors.black,
                      ),
                    ]
                ),
              ),
            ],
            repeatForever: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: univf,
                  controller: universityController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  marginColor: Colors.black,
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                    hintText: "University",
                    hintStyle: GoogleFonts.openSans(
                        color: Colors.white38,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchCollege(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(clgf);
                  },
                  enabled: true,
                  hint: "University",
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                  university.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //University

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: clgf,
                  controller: clgController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(

                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                    hintText: "Colleges",
                    hintStyle: GoogleFonts.openSans(
                        color: Colors.white38,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchCourse(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(coursef);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: clg.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //College

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: coursef,
                  controller: courseController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                    hintText: "Course",
                    hintStyle: GoogleFonts.openSans(
                        color: Colors.white38,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchBranch(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(branchFocus);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                  course.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Course
              //Subject

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: branchFocus,
                  controller: branchController,
                  searchStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: const Color.fromRGBO(40, 130, 146, 1),
                      //shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(0)),
                  searchInputDecoration: InputDecoration(
                    fillColor: Colors.black26.withOpacity(0.7),
                    filled: true,
                    hintText: "Branch",
                    hintStyle: GoogleFonts.openSans(
                        color: Colors.white38,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusColor: Colors.black,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSuggestionTap: (value) {
                    FocusScope.of(context).requestFocus(emailfn);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: branch.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.018,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: emailController,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Enter HOD Email",
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.white
                        ),
                        fillColor: Colors.black,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, style: BorderStyle.solid,color: Colors.black),
                      )
                    ),
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    keyboardType: TextInputType.visiblePassword),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                decoration: BoxDecoration(
                    gradient:(
                        universityController.text.isNotEmpty &&
                            clgController.text.isNotEmpty &&
                            courseController.text.isNotEmpty &&
                             branchController.text.isNotEmpty
                    )
                        ?
                    const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.purpleAccent],
                    )
                        :

                    LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey, Colors.grey.shade300,Colors.grey

                      ],
                    )
                    ,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black54,width: 2)
                ),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height*0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    side: const BorderSide(width: 2, color: Colors.black),
                    backgroundColor: Colors.transparent,
                  ),
                  focusNode: buttonf,
                  onPressed: () async {

                    if (universityController.text.isNotEmpty &&
                        clgController.text.isNotEmpty &&
                        courseController.text.isNotEmpty &&
                        branchController.text.isNotEmpty &&
                      emailController.text.isNotEmpty
                    ) {
                      try{
                        Navigator.push(context, PageTransition(
                            duration: const Duration(milliseconds: 400),
                            childCurrent: const DeanPanel(),
                            child: const loading(text: "Adding subject please wait"),
                            type: PageTransitionType.bottomToTopJoined));
                        print("try code is started...........");
                         await FirebaseFirestore.instance.collection("HOD Id").doc("${universityController.text.trim().split(" ")[0]} "
                            "${clgController.text.trim().split(" ")[0]} "
                            "${courseController.text.trim().split(" ")[0]} "
                            "${branchController.text.trim().split(" ")[0]}"
                        ).get().then((value) async {
                          if(value.data()==null)
                            {
                              await FirebaseFirestore.instance.collection("HOD Id").doc("${universityController.text.trim().split(" ")[0]} "
                                  "HOD Email"
                              ).set({
                                branchController.text.toString():emailController.text.toString()
                              });
                            }
                          else{
                            await FirebaseFirestore.instance.collection("HOD Id").doc("${universityController.text.trim().split(" ")[0]} "
                                "HOD Email"
                            ).update({
                              branchController.text.toString():emailController.text.toString()
                            });

                          }
                         }).whenComplete(() async {
                           await FirebaseFirestore.instance.collection("Teachers").doc(emailController.text.toString().trim()).update({
                             "HOD-University":universityController.text.toString(),
                             "HOD-College":clgController.text.toString(),
                             "HOD-Course":courseController.text.toString(),
                             "HOD-Branch":branchController.text.toString()
                           });
                         });

                        print("Data is Uploded...");
                        var data=await FirebaseFirestore.instance.collection("University").doc("University").get();

                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("University").doc("University").set(
                            {
                              "University": FieldValue.arrayUnion([universityController.text.trim()])
                            })
                            :
                        await FirebaseFirestore.instance.collection("University").doc("University").update(
                            {
                              "University": FieldValue.arrayUnion([universityController.text.trim()])
                            });

                        data=await FirebaseFirestore.instance.collection("Colleges").doc(universityController.text.trim()).get();

                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Colleges").doc(universityController.text.trim()).set({
                          "Colleges":[clgController.text.trim()]
                        })
                            :
                        await FirebaseFirestore.instance.collection("Colleges").doc(universityController.text.trim()).update({
                          "Colleges": FieldValue.arrayUnion([clgController.text.trim()])
                        });

                        data=await FirebaseFirestore.instance.collection("Course").doc(clgController.text.trim()).get();
                        data.data()==null
                            ?
                        await FirebaseFirestore.instance.collection("Course").doc(clgController.text.trim()).set({
                          "Course":[courseController.text.trim()]
                        })
                            :
                        await FirebaseFirestore.instance.collection("Course").doc(clgController.text.trim()).update({
                          "Course": FieldValue.arrayUnion([courseController.text.trim()])
                        });

                        // data=await FirebaseFirestore.instance.collection("Branch").doc(courseController.text.trim()).get();
                        // data.data()==null
                        //     ?
                        // await FirebaseFirestore.instance.collection("Branch").doc(courseController.text.trim()).set({
                        //   "Branch":[branchController.text.trim()]
                        // })
                        //     :
                        // await FirebaseFirestore.instance.collection("Branch").doc(courseController.text.trim()).update({
                        //   "Branch": FieldValue.arrayUnion([branchController.text.trim()])
                        // });
                        //
                        // data=await FirebaseFirestore.instance.collection("Subject").doc(branchController.text.trim()).get();
                        // data.data()==null
                        //     ?
                        // await FirebaseFirestore.instance.collection("Subject").doc(branchController.text.trim()).set({
                        //   "Subject":[subjectController.text.trim()]
                        // })
                        //     :
                        // await FirebaseFirestore.instance.collection("Subject").doc(branchController.text.trim()).update({
                        //   "Subject": FieldValue.arrayUnion([subjectController.text.trim()])
                        // });
                        InAppNotifications.instance
                          ..titleFontSize = 35.0
                          ..descriptionFontSize = 20.0
                          ..textColor = Colors.black
                          ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                          ..shadow = true
                          ..animationStyle = InAppNotificationsAnimationStyle.scale;
                        InAppNotifications.show(
                            title: 'Successful',
                            duration: const Duration(seconds: 2),
                            description: "Course added",
                            leading: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30,
                            ));
                        database().fetchuser().whenComplete((){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      }on FirebaseException catch
                      (e) {
                        InAppNotifications.instance
                          ..titleFontSize = 20.0
                          ..descriptionFontSize = 15.0
                          ..textColor = Colors.black
                          ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                          ..shadow = true
                          ..animationStyle = InAppNotificationsAnimationStyle.scale;
                        InAppNotifications.show(
                            title: 'Failed',
                            duration: const Duration(seconds: 2),
                            description: e.toString().split(']')[1].trim(),
                            leading: const Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                              size: 30,
                            ));
                      }
                    }
                    else {
                      InAppNotifications.instance
                        ..titleFontSize = 14.0
                        ..descriptionFontSize = 14.0
                        ..textColor = Colors.black
                        ..backgroundColor =
                        const Color.fromRGBO(150, 150, 150, 1)
                        ..shadow = true
                        ..animationStyle =
                            InAppNotificationsAnimationStyle.scale;
                      InAppNotifications.show(
                          title: 'Failed',
                          duration: const Duration(seconds: 2),
                          description: "Please fill all the details",
                          leading: const Icon(
                            Icons.error_outline_outlined,
                            color: Colors.red,
                            size: 20,
                          ));
                    }
                    // if(_universitycontroller.text.trim().toString().isNotEmpty){
                    //
                    //   List<dynamic> unis=[_universitycontroller.text.trim()];
                    //   await FirebaseFirestore.instance.collection("University").doc("University").update(
                    //       {"University": FieldValue.arrayUnion(unis)
                    //       });
                    //
                    //
                    //   List<dynamic> clgs=["Select Your College", _collegecontroller.text.trim()];
                    //   if(_universitycontroller.text.trim().toString().isNotEmpty){
                    //     await FirebaseFirestore.instance.collection("Colleges").doc(_universitycontroller.text.trim().toString()).set(
                    //         {"Colleges": clgs
                    //         });
                    //
                    //   }
                    //   fetchCollege();
                    //   fetchUniversity();
                    // }
                    // else{
                    //
                    //   if(_collegecontroller.text.trim().toString().isNotEmpty){
                    //     try{
                    //       List<dynamic> clgs=[_collegecontroller.text.trim()];
                    //       await FirebaseFirestore.instance.collection("Colleges").doc(uni).update(
                    //           {"Colleges": FieldValue.arrayUnion(clgs)
                    //           });
                    //     }on FirebaseException catch(e){
                    //       List<dynamic> clgs=["Select Your College",_collegecontroller.text.trim()];
                    //       await FirebaseFirestore.instance.collection("Colleges").doc(uni).set(
                    //           {"Colleges": clgs
                    //           });
                    //     }
                    //   }
                    //   fetchCollege();
                    // }
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w700, fontSize:MediaQuery.of(context).size.height*0.026 ,
                      color: Colors.black,
                    ),
                  ),
                ),
              ) // submit button
            ],
          ),
        ),
      ),
    );
  }

  fetchUniversity() async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('University')
          .doc("University")
          .get();
      setState(() {
        university=feed.data()!["University"];
      });
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  fetchCollege(String univ) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Colleges')
          .doc(univ)
          .get();
      setState(() {
        clg=feed.data()!["Colleges"];
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  fetchCourse(String clg) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Course')
          .doc(clg)
          .get();

      setState(() {
        course=feed.data()!["Course"];
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  fetchBranch(String course) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Branch')
          .doc(course)
          .get();

      setState(() {
        branch=feed.data()!["Branch"];
      });

      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

// fetchSubject(String Branch) async {
//   try {
//     final feed = await FirebaseFirestore.instance
//         .collection('Subject')
//         .doc(Branch)
//         .get();
//
//     setState(() {
//       subject=feed.data()!["Subject"];
//     });
//
//     return true;
//   } on FirebaseAuthException catch (e) {
//     print("\n\n\n\n $e \n\n\n\n");
//   }
// }


}