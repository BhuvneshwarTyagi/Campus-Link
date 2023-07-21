import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:searchfield/searchfield.dart';
import '../Database/database.dart';

class basicDetails extends StatefulWidget {
  const basicDetails({Key? key}) : super(key: key);

  @override
  State<basicDetails> createState() => _basicDetailsState();
}

class _basicDetailsState extends State<basicDetails> {


  late TextEditingController universityController = TextEditingController();
  List<String> university = [];
  final FocusNode univf = FocusNode();

  late TextEditingController clgController = TextEditingController();
  List<String> clg = [];
  final FocusNode clgf = FocusNode();

  late TextEditingController courseController = TextEditingController();
  List<String> course = [];
  final FocusNode coursef = FocusNode();

  late TextEditingController branchController = TextEditingController();
  List<String> branch = [];
  final FocusNode branchf = FocusNode();

  late TextEditingController yearController = TextEditingController();
  List<String> year = ['1', '2', '3', '4', '5'];
  final FocusNode yearf = FocusNode();

  late TextEditingController secController = TextEditingController();
  List<String> sec = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final FocusNode secf = FocusNode();

  late TextEditingController subjectController = TextEditingController();
  List<String> subject = [];
  final FocusNode subjectf = FocusNode();

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
    color: Colors.amber,
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
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        //transform: GradientRotation(2),
        colors: [
          Color.fromRGBO(3, 9, 46, 1),
          Color.fromRGBO(3, 74, 140, 1)

          //Color.fromRGBO(148, 18, 194, 1),
          //Color.fromRGBO(40, 19, 174, 1),
          //Color.fromRGBO(140, 39, 200, 1),
        ],
      )),
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
                'Fill Your Details',
                textStyle: GoogleFonts.openSans(
                    color: const Color.fromRGBO(213, 97, 132, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
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
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "University",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
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
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Colleges",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {});
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
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Course",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(branchf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                      course.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Course

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: branchf,
                  controller: branchController,
                  searchStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Branch",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(yearf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                      branch.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Branch

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: yearf,
                  controller: yearController,
                  searchStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Year",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(secf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: year.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Year

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: secf,
                  controller: secController,
                  searchStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Section",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(subjectf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: sec.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), // section

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: subjectf,
                  controller: subjectController,
                  searchStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Subject",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {});
                    FocusScope.of(context).requestFocus(buttonf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                      subject.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ), //Subject
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      side: const BorderSide(width: 3, color: Colors.black),
                      backgroundColor: (universityController.text.isNotEmpty &&
                              clgController.text.isNotEmpty &&
                              courseController.text.isNotEmpty &&
                              branchController.text.isNotEmpty &&
                              yearController.text.isNotEmpty &&
                              secController.text.isNotEmpty &&
                              subjectController.text.isNotEmpty)
                          ? const Color.fromRGBO(213, 97, 132, 1)
                          : Colors.grey),
                  focusNode: buttonf,
                  onPressed: () async {
                    if (universityController.text.isNotEmpty &&
                        clgController.text.isNotEmpty &&
                        courseController.text.isNotEmpty &&
                        branchController.text.isNotEmpty &&
                        yearController.text.isNotEmpty &&
                        secController.text.isNotEmpty &&
                        subjectController.text.isNotEmpty) {
                      try {
                        await FirebaseFirestore.instance
                            .collection("Teachers")
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .update({
                          "University": [universityController.text.trim()],
                          "Colleges-0": [clgController.text.trim()],
                          'Course-0': [courseController.text.trim()],
                          "Branch-0": [branchController.text.trim()],
                          'Year-0': [yearController.text.trim()],
                          "Section": [secController.text.trim()],
                          "Subject": [subjectController.text.trim()]
                        }).whenComplete(() => FirebaseAuth.instance.signOut());
                        Navigator.pop(context);
                      } on FirebaseException catch (e) {
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
                            description: e.toString().split(']')[1].trim(),
                            leading: const Icon(
                              Icons.error_outline_outlined,
                              color: Colors.red,
                              size: 55,
                            ));
                      }
                    } else {
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
                        fontWeight: FontWeight.w800, fontSize: 18),
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
      university.clear();
      for (var element in feed['University']) {
        setState(() {
          university.add(element.toString());
        });
      }
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
      clg.clear();
      for (var element in feed.data()?['Colleges']) {
        setState(() {
          clg.add(element.toString());
        });
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  /*
  decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(

                          ),
                          enabledBorder: const OutlineInputBorder(

                          ),
                          labelText: "Select University",
                          suffixIcon: DropdownButtonFormField(

                              isExpanded: false,
                              items: university
                                  .map<DropdownMenuItem<String>>((dynamic value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  uni = value;
                                });
                              }
                          )
                      ),



  Widget _universityaddtile() {
    return ListTile(
      title: const Center(child: Text('Add University',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),)),
      onTap: () {
        final controller = TextEditingController();
        final field = TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'University cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    int index=_universitycontroller.indexOf(controller);
                    _universitycontroller.removeAt(index);
                    _universityFields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.black,
              ),
              labelText: "University ${_universitycontroller.length + 1}",
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700)),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        );
        setState(() {
          _universitycontroller.add(controller);
          _universityFields.add(field);
        });
      },
    );
  }

  Widget _universitylistview() {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(
      controller: listScrollController,
      itemCount: _universityFields.length,
      itemBuilder: (context, index) {
        print("$index");
        return Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: Colors.black,width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      color: Colors.black26,
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                _universityFields[index],
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  height: 280,
                  child: Expanded( child: _courselistview(index),),
                ),
                _courseaddtile(index)

              ],
            )
        );
      },
    );
  }

  Widget _courseaddtile(int index) {
    return ListTile(
      title: const Center(child: Text('Add Course',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),)),
      onTap: () {
        final controller = TextEditingController();
        final field = TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Course cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    int index=_universitycontroller.indexOf(controller);
                    _universitycontroller.removeAt(index);
                    _universityFields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.black,
              ),
              labelText: "Course ${_coursecontroller.length + 1}",
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700)),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        );
        setState(() {
          _coursecontroller.add([]);
          _courseFields.add([]);
          _coursecontroller[index].add(controller);
          _courseFields[index].add(field);
        });
        print("${_coursecontroller.length}");
      },
    );
  }

  Widget _courselistview(int inde) {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(
      controller: listScrollController,
      itemCount: _courseFields.length,
      itemBuilder: (context, index) {
        return Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: Colors.black,width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      color: Colors.black26,
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                _courseFields[inde][index],
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  height: 280,
                  child: const Expanded( child: Text("Branch"),),
                ),
                //add branch tile

              ],
            )
        );
      },
    );
  }

*/
  Future upload(String naam, String section) async {
    try {
      Position x = await database().getloc();
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        "Name": naam,
        'Section': section,
        'Location': GeoPoint(x.latitude, x.longitude)
      });
    } on FirebaseAuthException catch (e) {
      InAppNotifications.instance
        ..titleFontSize = 14.0
        ..descriptionFontSize = 14.0
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
            size: 55,
          ));
    }
  }
}
