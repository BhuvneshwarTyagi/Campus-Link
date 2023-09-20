import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameTile extends StatelessWidget {
  const NameTile({super.key, required this.name, required this.sender, required this.channel, required this.email});
  final bool sender;
  final String name;
  final String channel;
  final String email;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        if(!sender){
         showDialog(context: context, builder: (context) {
           return  AlertDialog(
             backgroundColor: Colors.black87,
             title: const Text("Actions",style: TextStyle(color: Colors.white),),
             actions: [
               Column(
                 children: [
                   Container(
                     width: size.width*0.7,
                     height: size.height*0.05,
                     decoration: BoxDecoration(
                       borderRadius:  BorderRadius.circular(14),
                       color: Colors.black,
                       gradient: const LinearGradient(colors: [
                         Colors.deepPurple,
                         Colors.purpleAccent
                       ])
                     ),
                     child: ElevatedButton(

                         onPressed: () async {

                           await FirebaseFirestore.instance.collection("Messages").doc(channel).update({
                             "${email.split("@")[0]}.Mute" : true

                           }).whenComplete((){Navigator.pop(context);});
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.transparent,
                         ),
                         child: AutoSizeText("Mute $name")
                     ),
                   ),
                   SizedBox(
                     height: size.height*0.01,
                   ),
                   Container(
                     width: size.width*0.7,
                     height: size.height*0.05,
                     decoration: BoxDecoration(
                       borderRadius:  BorderRadius.circular(14),
                       color: Colors.black,
                       gradient: const LinearGradient(colors: [
                         Colors.deepPurple,
                         Colors.purpleAccent
                       ])
                     ),
                     child: ElevatedButton(

                         onPressed: () async {

                           await FirebaseFirestore.instance.collection("Messages").doc(channel).update({
                             "Admins" : FieldValue.arrayUnion([email])

                           }).whenComplete((){Navigator.pop(context);});
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.transparent,
                         ),
                         child: AutoSizeText("Make $name admin")
                     ),
                   ),
                 ],
               ),
             ],
           );
         },);
        }
      },
      child: AutoSizeText(
        sender
            ?
        "You" :name,
        style: GoogleFonts.poppins(
            color: sender ? Colors.white : Colors.black,
            fontSize: size.width*0.034,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
