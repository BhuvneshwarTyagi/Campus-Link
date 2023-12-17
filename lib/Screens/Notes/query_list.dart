import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constraints.dart';
import 'Raise_Query_Notes.dart';

class QueryList extends StatefulWidget {
  const QueryList({super.key, required this.notesindex});
  final int notesindex;
  @override
  State<QueryList> createState() => _QueryListState();
}

class _QueryListState extends State<QueryList> {
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AutoSizeText("$course_filter $branch_filter $year_filter $section_filter $subject_filter Notes ${widget.notesindex} Query section",style: GoogleFonts.tiltNeon(
             color: Colors.black,
            fontSize: size.width*0.04
          ),),
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Notes").doc("${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter").snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ?
               ListView.builder(
                 itemCount: snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"].length,
                 itemBuilder: (context, index) {
                   return Card(
                     child: ListTile(
                       leading: CircleAvatar(
                         backgroundColor: Colors.grey,
                         backgroundImage: (snapshot.data!.data()?[snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index].toString().split("@")[0]]["Profile_URL"] != null && snapshot.data!.data()?[snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index].toString().split("@")[0]]["Profile_URL"] != "null" && snapshot.data!.data()?[snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index].toString().split("@")[0]]["Profile_URL"] != "") ?
                         NetworkImage(snapshot.data!.data()?[snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index].toString().split("@")[0]]["Profile_URL"])
                         :
                         const AssetImage("assets/images/unknown.png") as ImageProvider,
                       ),
                       title: AutoSizeText("${snapshot.data!.data()?[snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index].toString().split("@")[0]]["Name"]}",
                         style: GoogleFonts.tiltNeon(
                           fontSize: size.width*0.05
                         ),
                       ),
                       trailing: const CircleAvatar(
                         radius: 8,
                         backgroundColor: Colors.red,
                       ),
                       onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) {
                           return NotesQuery(
                             subject: subject_filter,
                             index: widget.notesindex, Email: snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index],
                             name: snapshot.data!.data()?[snapshot.data!.data()?["Notes-${widget.notesindex}"]["QueryBy"][index].toString().split("@")[0]]["Name"],
                           );
                         },));
                       },
                     ),
                   );
                 },
               )
                  :
              const SizedBox();
            },),
      ),
    );
  }
}
