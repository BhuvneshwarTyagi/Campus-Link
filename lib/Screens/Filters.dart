import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Database/database.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<dynamic>? university = [];
  List<dynamic>? clg = [];
  List<dynamic>? course = [];
   final ScrollController _controller = ScrollController();
  var currentuni="";
  var currentclg="";
  var currentcourse="";
  int clgIndex=-1;
  int courseIndex=-1;
  int branchIndex=-1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: const Text("Filters"),
        titleTextStyle: TextStyle(
            color: const Color.fromRGBO(150, 150, 150, 1),
            fontWeight: FontWeight.w900,
            fontSize: MediaQuery.of(context).size.height * 0.03),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: size.height*0.05,
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 20,
                  backgroundColor: const Color.fromRGBO(150, 150, 150, 1)),
              onPressed: () {
                subject = "";
                Navigator.pop(context);
              },
              child: const Text(
                "Apply",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: size.height*0.95,
        width: size.width,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: const Color.fromRGBO(60, 60, 60, 1),
                          width: MediaQuery.of(context).size.width * 0.008),
                  ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Color.fromRGBO(150, 150, 150, 1),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: AutoSizeText("University",
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: size.height*0.68,
              width: size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Teachers")
                    .doc("bhanu68tyagi@gmail.com")
                    .snapshots(),
                builder: (context, snapshot) {
                  university = snapshot.data?.data()?["University"];

                  if (!snapshot.hasData || university!.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }
                  else {

                    return SizedBox(
                      height: size.height*0.68,
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.08 *university!.length,
                              width: size.width,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: university?.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: () => setState(
                                                () {
                                              currentuni=university?[index];
                                              clg=snapshot.data?.data()?["Colleges-$index"];
                                              _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.linear);

                                            },
                                          ),
                                          title: Text(university?[index]),
                                            leading: Radio(
                                              activeColor: Colors.amber,
                                              value: university?[index],
                                              groupValue: currentuni,
                                              onChanged: (value) {
                                                setState(
                                                      () {
                                                        currentuni=value;
                                                        clg=snapshot.data?.data()?["Colleges-$index"];
                                                        _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.linear);

                                                      },
                                                );
                                              },
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ), // University
                            Padding(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                              child: AutoSizeText("Colleges",
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              height: size.height*0.08 * clg!.length,
                              width: size.width,
                              color: Colors.yellow,
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(

                                    child: ListView.builder(
                                      itemCount: clg?.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          onTap: () => setState(
                                                () {
                                              currentclg=clg?[index];
                                              course=snapshot.data?.data()?["Course-$index"];
                                              _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                            },
                                          ),
                                          title: Text(clg?[index]),
                                            leading: Radio(

                                              activeColor: Colors.amber,
                                              value: clg?[index],
                                              groupValue: currentclg,
                                              onChanged: (value) {
                                                setState(
                                                      () {
                                                        currentclg=value;
                                                        course=snapshot.data?.data()?["Course-$index"];
                                                        _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                                      },
                                                );
                                              },
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ), // College
                            Padding(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                              child: AutoSizeText("Course",
                                style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: size.height*0.08* course!.length,
                              width: size.width,
                              color: Colors.yellow,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: course?.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(course?[index]),
                                            leading: Radio(

                                              activeColor: Colors.amber,
                                              value: course?[index],
                                              groupValue: currentcourse,
                                              onChanged: (value) {
                                                setState(
                                                      () {
                                                        currentcourse=value;
                                                        branchIndex=index;
                                                      },
                                                );
                                              },
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ), //Course
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // SizedBox(
            //   height: size.height * 0.2,
            //   width: size.width,
            //   child: StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection("Teachers")
            //         .doc("bhanu68tyagi@gmail.com")
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       List<dynamic>? college = snapshot.data?.data()?["Colleges-$uni_index"];
            //
            //       if (!snapshot.hasData || college!.isEmpty) {
            //         return const Center(
            //           child: CircularProgressIndicator(
            //             color: Colors.amber,
            //           ),
            //         );
            //       }
            //       else {
            //         return SizedBox(
            //           height: size.height * 0.2,
            //           width: size.width,
            //           child: Column(
            //             children: [
            //               Expanded(
            //                 child: ListView.builder(
            //                   itemCount: college.length,
            //                   scrollDirection: Axis.vertical,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return ListTile(
            //                       title: Text(college[index]),
            //                         leading: Radio(
            //
            //                           activeColor: Colors.amber,
            //                           value: college[index],
            //                           groupValue: currentclg,
            //                           onChanged: (value) {
            //                             setState(
            //                                   () {
            //                                     currentclg=value;
            //                                   },
            //                             );
            //                           },
            //                         ),
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       }
            //     },
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}
