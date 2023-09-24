import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';
enum Options { trueFalse, multipleChoice }
class QuizQustion extends StatefulWidget {
  const QuizQustion({super.key});

  @override
  State<QuizQustion> createState() => _QuizQustionState();
}

class _QuizQustionState extends State<QuizQustion> {

  TextEditingController numberController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionController = [];
  TextEditingController answerController = TextEditingController();
  List<String> options = ["A", "B", "C", "D"];
  int questionCount = 0;
  PageController pageController = PageController();
  var currIndex = 0;
  bool optionType = false;
  Options? _options;


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 50,
        backgroundColor: Colors.transparent,
        title: AutoSizeText("Upload Question",
          style: GoogleFonts.openSans(
              fontSize: size.height * 0.022, color: Colors.white),

        ),
      ),
      body: Container(
        height: size.height*1,
 width: size.width*1,
 color: Colors.black45.withOpacity(0.9),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: TextField(
                  controller: numberController,
                  onChanged: (value) {
                    setState(() {
                      questionCount = int.parse(value.toString());
                      print("....................................$questionCount");
                    });
                  },
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: "Enter the  number of Question",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                  style: GoogleFonts.openSans(
                      fontSize: size.height * 0.022, color: Colors.white),
                  cursorColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                    height: questionCount == 0
                        ? size.height * 0
                        : size.height * 0.85,
                    width: size.width,
                    duration: const Duration(milliseconds: 100),
                    child: PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: questionCount * 2,
                      itemBuilder: (context, index) {
                        return SizedBox(
                            height: _options == Options.multipleChoice
                                ? size.height * 0.7
                                : size.height * 0.55,
                            width: size.width,
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.04,
                                      ),
                                      AutoSizeText(
                                        "${index + 1}/${questionCount * 2}",
                                        style: GoogleFonts.openSans(
                                            fontSize: size.height * 0.025,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.015,
                                  ),
                                  TextField(
                                    controller: questionController,
                                    autocorrect: true,
                                    keyboardType: TextInputType.text,
                                    minLines: 3,
                                    maxLines: 6,
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      hintText:
                                      "Write your Question here......",
                                      hintStyle: const TextStyle(
                                          color: Colors.white),
                                      contentPadding:
                                      EdgeInsets.all(size.height * 0.02),
                                      helperStyle: GoogleFonts.openSans(
                                          color: Colors.white54,
                                          fontSize: size.height * 0.022),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white54,
                                              width: 2)),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      disabledBorder:
                                      const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white54,
                                              width: 2)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white54,
                                              width: 2)),
                                    ),
                                    style: GoogleFonts.openSans(
                                        fontSize: size.height * 0.022,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: Colors.white,
                                          contentPadding:
                                          const EdgeInsets.all(0.0),
                                          title: AutoSizeText(
                                            "MultipleChoice",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height * 0.02),
                                          ),
                                          value: Options.multipleChoice,
                                          groupValue: _options,
                                          onChanged: (value) {
                                            setState(() {
                                              _options = value;
                                              print(
                                                  "....................${_options}");
                                              optionController = List.generate(
                                                  4,
                                                      (i) =>
                                                      TextEditingController());
                                              optionType = true;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: Colors.white,
                                          contentPadding:
                                          const EdgeInsets.all(0.0),
                                          title: AutoSizeText(
                                            "True or false",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height * 0.02),
                                          ),
                                          value: Options.trueFalse,
                                          groupValue: _options,
                                          onChanged: (value) {
                                            setState(() {
                                              _options = value;
                                              optionController = List.generate(
                                                  2,
                                                      (i) =>
                                                      TextEditingController());
                                              optionType = true;
                                              //print("/////................///........$optionController");
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),


                                  optionType
                                      ? Column(
                                    children: [
                                      _options == Options.multipleChoice
                                          ? SizedBox(
                                          height:
                                          size.height * 0.45,
                                          width: size.width * 0.9,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                size.height *
                                                    0.36,
                                                width: size.width *
                                                    0.9,
                                                child: ListView
                                                    .builder(
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                  optionController
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index_1) {
                                                    return Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(
                                                          6.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          AutoSizeText(
                                                            options[
                                                            index_1],
                                                            style: GoogleFonts.openSans(
                                                                color:
                                                                Colors.white,
                                                                fontSize: size.height * 0.022),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.022,
                                                          ),
                                                          Container(
                                                            height: size.height *
                                                                0.065,
                                                            width: size.width *
                                                                0.8,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                Colors.transparent,
                                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                                border: Border.all(color: Colors.white54, width: 2)),
                                                            child:
                                                            TextField(
                                                              controller:
                                                              optionController[index_1],
                                                              onTap:
                                                                  () {
                                                                print(".......this index is $index_1");
                                                              },
                                                              textAlign:
                                                              TextAlign.center,
                                                              style:
                                                              GoogleFonts.openSans(
                                                                color:
                                                                Colors.white,
                                                                fontSize:
                                                                size.height * 0.02,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                size.height *
                                                    0.004,
                                              ),
                                              Container(
                                                height:
                                                size.height *
                                                    0.063,
                                                width: size.width *
                                                    0.79,
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .transparent,
                                                    borderRadius:
                                                    const BorderRadius
                                                        .all(
                                                        Radius.circular(
                                                            20)),
                                                    border: Border.all(
                                                        color: Colors
                                                            .white54,
                                                        width: 2)),
                                                child: TextField(
                                                  controller:
                                                  answerController,
                                                  decoration:
                                                  InputDecoration(
                                                    hintText:
                                                    "Right Option",
                                                    helperStyle:
                                                    GoogleFonts
                                                        .openSans(
                                                      color: Colors
                                                          .white,
                                                      fontSize:
                                                      size.height *
                                                          0.02,
                                                    ),
                                                  ),
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                  style: GoogleFonts
                                                      .openSans(
                                                    color: Colors
                                                        .white,
                                                    fontSize:
                                                    size.height *
                                                        0.02,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))
                                          : SizedBox(
                                          height: size.height * 0.3,
                                          width: size.width * 0.9,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                size.height *
                                                    0.2,
                                                width: size.width *
                                                    0.9,
                                                child: ListView
                                                    .builder(
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                  optionController
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index_2) {
                                                    return Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(
                                                          6.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          AutoSizeText(
                                                            options[
                                                            index_2],
                                                            style: GoogleFonts.openSans(
                                                                color:
                                                                Colors.white,
                                                                fontSize: size.height * 0.022),
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.022,
                                                          ),
                                                          Container(
                                                            height: size.height *
                                                                0.065,
                                                            width: size.width *
                                                                0.8,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                Colors.transparent,
                                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                                border: Border.all(color: Colors.white54, width: 2)),
                                                            child:
                                                            TextField(
                                                              controller:
                                                              optionController[index_2],
                                                              textAlign:
                                                              TextAlign.center,
                                                              style:
                                                              GoogleFonts.openSans(
                                                                color:
                                                                Colors.white,
                                                                fontSize:
                                                                size.height * 0.02,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                size.height *
                                                    0.004,
                                              ),
                                              Container(
                                                height:
                                                size.height *
                                                    0.063,
                                                width: size.width *
                                                    0.79,
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .transparent,
                                                    borderRadius:
                                                    const BorderRadius
                                                        .all(
                                                        Radius.circular(
                                                            20)),
                                                    border: Border.all(
                                                        color: Colors
                                                            .white54,
                                                        width: 2)),
                                                child: TextField(
                                                  controller:
                                                  answerController,
                                                  decoration:
                                                  InputDecoration(
                                                    hintText:
                                                    "Right Option",
                                                    helperStyle:
                                                    GoogleFonts
                                                        .openSans(
                                                      color: Colors
                                                          .white,
                                                      fontSize:
                                                      size.height *
                                                          0.02,
                                                    ),
                                                  ),
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                  style: GoogleFonts
                                                      .openSans(
                                                    color: Colors
                                                        .white,
                                                    fontSize:
                                                    size.height *
                                                        0.02,
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: size.height * 0.056,
                                            width: size.width * 0.55,
                                            decoration: const BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        100))),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  List<String>
                                                  optionList = [];
                                                  for (var i = 0;
                                                  i <
                                                      optionController
                                                          .length;
                                                  i++) {
                                                    optionList.add(
                                                        optionController[
                                                        i]
                                                            .text
                                                            .toString()
                                                            .trim());
                                                  }
                                                  FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      "Notes")
                                                      .doc(
                                                      "$university_filter $college_filter $branch_filter $year_filter $section_filter $subject_filter")
                                                      .set({
                                                    "Notes-1": {
                                                      "Question-1": {
                                                        "Question":
                                                        questionController
                                                            .text
                                                            .toString()
                                                            .trim(),
                                                        "Options":
                                                        optionList,
                                                        "Answer":
                                                        answerController
                                                            .text
                                                            .toString(),
                                                        "Question-Type": _options ==
                                                            Options
                                                                .multipleChoice
                                                            ? "multipleChoice"
                                                            : "True and False"
                                                      },
                                                    }
                                                  }).whenComplete(() {
                                                    setState(() {
                                                      answerController
                                                          .clear();
                                                      questionController
                                                          .clear();
                                                      optionList
                                                          .clear();
                                                    });
                                                  });

                                                  setState(() {
                                                    currIndex++;
                                                    pageController.animateToPage(
                                                        currIndex,
                                                        duration:
                                                        const Duration(
                                                            milliseconds:
                                                            600),
                                                        curve: Curves
                                                            .linear);
                                                  });
                                                },
                                                child: AutoSizeText(
                                                  "Save and Next",
                                                  style: GoogleFonts
                                                      .openSans(
                                                    color: Colors.white,
                                                    fontSize:
                                                    size.height *
                                                        0.024,
                                                  ),
                                                )),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                      : const SizedBox()
                                ],
                              ),
                            ));
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
