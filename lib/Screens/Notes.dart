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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: const Center(
          child: Text("Notes")
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.green,
        child: IconButton(
            onPressed: (){
              Navigator.push(context,
                  PageTransition(
                    child: const Quiz(),
                    type: PageTransitionType.bottomToTopJoined,
                    childCurrent: const Notes(),
                    duration: const Duration(milliseconds: 300)
                  )
              );
            },
            icon: const Icon(Icons.add,color: Colors.black,)),
      ),
    );
  }
}
