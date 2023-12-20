// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:campus_link_teachers/Teacher%20Learning/Certificate.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class NewsLetter extends StatefulWidget {
//   const NewsLetter({Key? key}) : super(key: key);
//
//   @override
//   State<NewsLetter> createState() => _NewsLetterState();
// }
//
// class _NewsLetterState extends State<NewsLetter> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SizedBox(
//       height: size.height*0.8,
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("Teachers").snapshots(),
//         builder: (context, snapshot) {
//           return snapshot.hasData
//               ?
//           SizedBox(
//             width: size.width,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: snapshot.data?.docs.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 30,
//                   shape: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10))
//                   ),
//                   child: SizedBox(
//                     height: size.height*0.25,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data?.docs[index].data()["Skills"] == null ? 0:snapshot.data?.docs[index].data()["Skills"].length,
//                       itemBuilder: (context, index1) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               tileColor: Colors.transparent,
//                               trailing: AutoSizeText("${snapshot.data!.docs[index].data()["Points"] ?? 0}+ Points"),
//                               leading:  CircleAvatar(
//                                 radius: size.width*0.08,
//                                 backgroundColor: Colors.black,
//                                 child: CircleAvatar(
//                                   radius: size.width*0.062,
//                                   backgroundColor: Colors.green,
//                                   child: snapshot.data?.docs[index].data()["Profile-URL"]!=null
//                                       ?
//                                   Image.network(snapshot.data?.docs[index].data()["Profile-URL"])
//                                       :
//                                   AutoSizeText(
//                                     snapshot.data!.docs[index].data()["Name"].toString().substring(0,1),
//                                     style: GoogleFonts.tiltNeon(
//                                         color: Colors.black,
//                                         fontSize: size.height*0.035,
//                                         fontWeight: FontWeight.w600
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               title: AutoSizeText( snapshot.data!.docs[index].data()["Name"]),
//                               subtitle:  AutoSizeText( snapshot.data!.docs[index].data()["Name"]),
//
//                             ),
//                             Divider(
//                               color: Colors.black,
//                               height: size.height*0.015,
//                               thickness: 1,
//                               endIndent: size.height*0.02,
//                               indent: size.height*0.02,
//                             ),
//                             SizedBox(height: size.height*0.01,),
//                             Padding(
//                               padding: EdgeInsets.only(left: size.width*0.04),
//                               child:  AutoSizeText( snapshot.data!.docs[index].data()["Skills"][index1],
//                                 style: GoogleFonts.tiltNeon(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: size.height*0.022,
//                                     color: Colors.black
//                                 ),),
//                             ),
//                             SizedBox(height: size.height*0.01,),
//                             Padding(
//                               padding: EdgeInsets.only(left: size.width*0.04),
//                               child:  AutoSizeText(snapshot.data!.docs[index].data()["Skills"][index1]),
//                             ),
//                             SizedBox(height: size.height*0.01,),
//                             SizedBox(
//                               width: size.width,
//                               height: size.height*0.3,
//                               child: Container(
//                                 width: size.width*0.95,
//                                 decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     image: DecorationImage(image: AssetImage("assets/images/Certificate.png"),fit: BoxFit.fill)
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: size.height*0.14,
//                                     ),
//                                     AutoSizeText(snapshot.data!.docs[index].data()["Name"],style: GoogleFonts.tiltNeon(color: Colors.black)),
//                                     SizedBox(
//                                       height: size.height*0.03,
//                                     ),
//                                     AutoSizeText(snapshot.data!.docs[index].data()["Skills"][index1]),
//
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 );
//
//               },),
//           )
//               :
//           const SizedBox();
//         },
//       ),
//     );
//   }
// }
