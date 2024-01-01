
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constraints.dart';

class TeachersList extends StatefulWidget {
  const TeachersList({super.key});

  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {

  var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  String selectedUniversity=usermodel["HOD University"];
  String selectedCollege=usermodel["HOD College"];
  String selectedCourse= usermodel["HOD Course"];
  String selectedBranch= usermodel["HOD Branch"];
  int selectedYear=1;
  TextEditingController yearController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Teachers Id")
          .doc("$selectedUniversity $selectedCollege $selectedCourse $selectedBranch")
          .snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData)
          {
            print("teacers Lis is :${snapshot.data!.data()?["Teachers"]}");
          }
        return snapshot.data!=null && snapshot.hasData
            ?
        ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.data()?["Teachers"].length,
          itemBuilder: (context, index) {
            print(index);
            return  Card(
              shape: Border.all(
                  color: Colors.black,
                  width: 1
              ),
              child: ExpansionTile(
                backgroundColor: Colors.white12,
                collapsedBackgroundColor: Colors.white12,
                leading: Column(
                  children: [
                    SizedBox(
                      height: size.height*0.013,
                    ),
                    AutoSizeText(snapshot.data!.data()?["Teachers"][index]["Name"],style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: size.height*0.02,
                      fontWeight: FontWeight.w500
                    ),),
                    AutoSizeText(snapshot.data!.data()?["Teachers"][index]["Employee Id"]),
                  ],
                ),
                trailing: Icon(Icons.arrow_drop_down,color: Colors.black,size: size.height*0.041),
                title: const AutoSizeText(""),
                children: [
                  const ExpansionTile(
                    title: Text("Certificates"),
                    trailing: Text("2"),
                    children: [
                      ListTile(
                        title: Text("C Programming"),
                      ),
                      ListTile(
                        title: Text("DBMS"),
                      )
                    ],
                  ),
                 const ListTile(
                   title: Text("Points"),
                   trailing: Text("400 Points earned till now"),
                 ),
                 ExpansionTile(
                     title: const Text("Assign subject"),
                     children: [
                       ListTile(
                         leading: AutoSizeText("Year",
                           style:GoogleFonts.openSans(
                               fontSize: size.height*0.02,
                               color: Colors.black54,
                               fontWeight: FontWeight.w400
                           ) ,
                         ),
                         trailing: Container(
                           height: size.height*0.045,
                           width: size.width*0.17,
                           decoration:BoxDecoration(
                               color: Colors.transparent,
                               borderRadius: BorderRadius.all(Radius.circular(size.height*0.012)),
                               border: Border.all(
                                   color: Colors.black,
                                   width: 2
                               )
                           ),
                           child: Center(
                             child: TextField(
                               maxLines: 1,
                               controller: yearController,
                               textAlign: TextAlign.center,
                               decoration: const InputDecoration(
                                   focusedBorder: OutlineInputBorder(
                                       borderSide: BorderSide.none
                                   )
                               ),
                             ),
                           ),
                         ),
                       ),
                       ListTile(
                         leading: AutoSizeText("Section",
                           style:GoogleFonts.openSans(
                               fontSize: size.height*0.02,
                               color: Colors.black54,
                               fontWeight: FontWeight.w400
                           ) ,
                         ),
                         trailing: Container(
                           height: size.height*0.045,
                           width: size.width*0.17,
                           decoration:BoxDecoration(
                               color: Colors.transparent,
                               borderRadius: BorderRadius.all(Radius.circular(size.height*0.012)),
                               border: Border.all(
                                   color: Colors.black,
                                   width: 2
                               )
                           ),
                           child: TextField(
                             maxLines: 1,
                             textAlign: TextAlign.center,
                             controller: sectionController,
                             decoration: const InputDecoration(
                                 focusedBorder: OutlineInputBorder(
                                     borderSide: BorderSide.none
                                 )
                             ),
                           ),
                         ),
                       ),
                       ListTile(
                         leading: AutoSizeText(
                           "Subject",
                           style:GoogleFonts.openSans(
                               fontSize: size.height*0.02,
                               color: Colors.black54,
                               fontWeight: FontWeight.w400
                           ) ,
                         ),
                         trailing: Container(
                           height: size.height*0.045,
                           width: size.width*0.4,
                           decoration:BoxDecoration(
                               color: Colors.transparent,
                               borderRadius: BorderRadius.all(Radius.circular(size.height*0.012)),
                               border: Border.all(
                                   color: Colors.black,
                                   width: 2
                               )
                           ),
                           child: TextField(
                             maxLines: 1,
                             textAlign: TextAlign.center,
                             controller: subjectController,
                             decoration: const InputDecoration(
                                 focusedBorder: OutlineInputBorder(
                                     borderSide: BorderSide.none
                                 )
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         height: size.height*0.01,
                       ),
                       InkWell(
                         onTap: () async {
                           /* await FirebaseFirestore.instance.collection("Subject").doc("${usermodel["HOD Branch"]}").get().then((value) async {
                        value.data()!=null
                        ?
                        await FirebaseFirestore.instance.collection("Subject").doc("${usermodel["HOD Branch"]}").set(
                            {
                              "Subject": FieldValue.arrayUnion([subjectController.text.trim()])
                            })
                        :
                        await FirebaseFirestore.instance.collection("Subject").doc("${usermodel["HOD Branch"]}").update(
                        {
                        "Subject": FieldValue.arrayUnion([subjectController.text.trim()])
                        });
                      });
                    */


                           //......................................
                                if(sectionController.text.isNotEmpty && yearController.text.isNotEmpty && subjectController.text.isNotEmpty)
                                  {
                                    final ref= FirebaseFirestore
                                        .instance
                                        .collection("Teachers")
                                        .doc("${snapshot.data!.data()?["Teachers"][index]["Email"]}")
                                        .collection("Teachings")
                                        .doc("Teachings");
                                    await ref.update(
                                      {
                                        "University": FieldValue.arrayUnion([selectedUniversity]),
                                      },
                                    );

                                    var data= await ref.get();

                                    List<dynamic> universityList= data.data()!["University"];
                                    int uniIndex =universityList.indexOf(selectedUniversity);

                                    await ref
                                        .update(
                                      {
                                        "College-$uniIndex": FieldValue.arrayUnion([selectedCollege]),
                                      },
                                    );
                                    data= await ref.get();
                                    List<dynamic> clgList=data.data()!["College-$uniIndex"];
                                    int clgIndex =clgList.indexOf(selectedCollege);
                                    await ref
                                        .update(
                                      {
                                        "Course-$uniIndex$clgIndex": FieldValue.arrayUnion([selectedCourse]),
                                      },

                                    );
                                    data= await ref.get();
                                    List<dynamic> courseList=data.data()!["Course-$uniIndex$clgIndex"];
                                    int courseIndex =courseList.indexOf(selectedCourse);
                                    await ref
                                        .update(
                                      {
                                        "Branch-$uniIndex$clgIndex$courseIndex": FieldValue.arrayUnion([selectedBranch]),
                                      },

                                    );
                                    data= await ref.get();
                                    List<dynamic> branchList=data.data()!["Branch-$uniIndex$clgIndex$courseIndex"];
                                    int branchIndex =branchList.indexOf(selectedBranch);

                                    await ref
                                        .update(
                                      {
                                        "Year-$uniIndex$clgIndex$courseIndex$branchIndex": FieldValue.arrayUnion([yearController.text.toString()]),
                                      },
                                    );
                                    data= await ref.get();
                                    List<dynamic> yearList=data.data()!["Year-$uniIndex$clgIndex$courseIndex$branchIndex"];
                                    int yearIndex =yearList.indexOf(yearController.text.toString());

                                    await ref
                                        .update(
                                      {
                                        "Section-$uniIndex$clgIndex$courseIndex$branchIndex$yearIndex": FieldValue.arrayUnion([sectionController.text.toString()]),
                                      },);
                                    data= await ref.get();
                                    List<dynamic> sectionList=data.data()!["Section-$uniIndex$clgIndex$courseIndex$branchIndex$yearIndex"];
                                    int sectionIndex =sectionList.indexOf(sectionController.text.toString());

                                    await ref
                                        .update(
                                      {
                                        "Subject-$uniIndex$clgIndex$courseIndex$branchIndex$yearIndex$sectionIndex": FieldValue.arrayUnion([subjectController.text.toString()]),
                                      },).whenComplete(() async {
                                      await FirebaseFirestore.instance.collection("Teachers Id")
                                          .doc("$selectedUniversity $selectedCollege $selectedCourse $selectedBranch")
                                          .update({
                                        "Assigned subject":FieldValue.arrayUnion([{
                                          "Section":sectionController.text.toString(),
                                          "Year":yearController.text.toString(),
                                          "Subject":subjectController.text.toString(),
                                          "Name":snapshot.data!.data()?["Teachers"][index]["Name"],
                                          "Email":snapshot.data!.data()?["Teachers"][index]["Email"],
                                          "Employee Id":snapshot.data!.data()?["Teachers"][index]["Employee Id"]
                                        }])

                                      });
                                    }).whenComplete(() {

                                      setState(() {
                                        yearController.clear();
                                        sectionController.clear();
                                        subjectController.clear();
                                      });
                                    });
                                  }
                                else{
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
                                      description: "Please Provide All Details",
                                      leading: const Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.red,
                                        size: 55,
                                      ));
                                }

                         },
                         child: Container(
                           height: size.height*0.043,
                           width: size.width*0.22,
                           decoration: BoxDecoration(
                               color: Colors.transparent,
                               border: Border.all(
                                 color: Colors.red,
                                 width: 2,
                               ),
                               borderRadius: BorderRadius.all(Radius.circular(size.height*0.012))
                           ),
                           child: Center(
                             child: AutoSizeText(
                               "Done",style: GoogleFonts.openSans(
                                 color: Colors.red,
                                 fontSize: size.height*0.022
                             ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         height: size.height*0.01,
                       ),
                     ],
                 ),
                  ExpansionTile(
                    title: const Text("Already Assigned"),
                    children: [
                      SizedBox(
                        height: size.height*0.05,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.data()?["Assigned subject"].length??0,
                          itemBuilder: (context, index1) {
                            return snapshot.data!.data()?["Assigned subject"][index1]["Email"]==snapshot.data!.data()?["Teachers"][index]["Email"]
                                ?
                            Container(
                              height: size.height*0.042*snapshot.data!.data()?["Assigned subject"].length,
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText("Section : ${snapshot.data!.data()?["Assigned subject"][index1]["Section"]}  | ",
                                        style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: size.height*0.018,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      AutoSizeText("Year : ${snapshot.data!.data()?["Assigned subject"][index1]["Year"]}  | ",
                                        style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: size.height*0.018,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      AutoSizeText("Subject : ${snapshot.data!.data()?["Assigned subject"][index1]["Subject"]}",
                                        style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: size.height*0.018,
                                            fontWeight: FontWeight.w500
                                        ),),

                                    ],
                                  ),
                                  /*Divider(
                                    height: size.height*0.013,
                                    color: Colors.black54,
                                    endIndent:size.width*0.15,
                                    thickness: 1,
                                    indent: size.width*0.15,
                                  )*/
                                ],
                              ),
                            )
                                :
                                 SizedBox(
                                  child: index1==0
                                    ?
                                  const Center(child: AutoSizeText("Not Assigned"))
                                  :
                                  const SizedBox(),
                                );

                        },),
                      )
                    ],
                  ),
                ],
              ),
            );
          },)
            :
        const SizedBox();
      },
    );
  }
}
