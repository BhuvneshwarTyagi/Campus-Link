import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QueriesDrawer extends StatefulWidget {
  QueriesDrawer({super.key, required this.description, required this.email, required this.index, required this.type, this.sessional, required this.from, required this.subject});
  final List<dynamic> description;
  final String email;
  final int index;
  final String type;
  final int? sessional;
  final String from;
  final String subject;
  @override
  State<QueriesDrawer> createState() => _QueriesDrawerState();
}

class _QueriesDrawerState extends State<QueriesDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Students").doc(widget.email).snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ?
          Card(
            child: ExpansionTile(
              title: AutoSizeText("${widget.subject} Sessional ${widget.sessional} ${widget.type} Error",style: GoogleFonts.tiltNeon(color: Colors.red),),
              subtitle: AutoSizeText("${snapshot.data!.data()?["Name"]}",style: GoogleFonts.tiltNeon(color: Colors.black),),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.description.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: AutoSizeText("${widget.description[index]}",style: GoogleFonts.tiltNeon(color: Colors.red),),
                    );
                },
                )
              ],
            )
        )
            :
        SizedBox();
      }
    );
  }
}
