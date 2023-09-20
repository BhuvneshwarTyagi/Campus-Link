import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/quiz.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {



  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: const Center(
          child: Text("Notes")
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: size.height * 0.015, right: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: size.height * 0.06,
              width: size.width * 0.466,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.purpleAccent,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black, width: 2)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent),
                onPressed: () {

                  Navigator.push(context,
                      PageTransition(
                          child: const Quiz(),
                          type: PageTransitionType.bottomToTopJoined,
                          childCurrent: const Notes(),
                          duration: const Duration(milliseconds: 300)
                      )
                  );

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.upload_sharp),
                    AutoSizeText(
                      "Upload question",
                      style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
