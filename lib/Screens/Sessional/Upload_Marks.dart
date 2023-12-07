import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Constraints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadMarks extends StatefulWidget {
  const UploadMarks({super.key});

  @override
  State<UploadMarks> createState() => _UploadMarksState();
}

class _UploadMarksState extends State<UploadMarks> {

  List<String> uploadedName = [""];
  List<TextEditingController> controllers = [];
  List<String> emails = [];
  List<FocusNode> nodes =[];
  int currIndex=0;

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          stream: FirebaseFirestore
              .instance
              .collection("Students")
              .where("University",isEqualTo: university_filter)
              .where("College",isEqualTo: college_filter)
              .where("Course",isEqualTo: course_filter)
              .where("Branch",isEqualTo: branch_filter)
              .where("Year",isEqualTo: year_filter)
              .where("Section",isEqualTo: section_filter)
              .where("Subject",arrayContains: subject_filter)
              .where("Name",  whereNotIn: uploadedName)
              .snapshots(),
          builder: (context, snapshot) {
            int sessional=0;
            if(snapshot.hasData){
              controllers.clear();
              emails.clear();
              if(snapshot.data!.docs.isNotEmpty && snapshot.data?.docs[currIndex].data()["Marks"]!= null && snapshot.data?.docs[currIndex].data()["Marks"][subject_filter] != null){
                sessional = snapshot.data?.docs[currIndex].data()["Marks"][subject_filter]["Total"] ?? 1;
              }
              for(var doc in snapshot.data!.docs){
                controllers.add(TextEditingController());
                emails.add(doc.data()["Email"]);
                nodes.add(FocusNode());
              }
            }
            return snapshot.hasData
                ?
            ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    index==0
                        ?
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: AutoSizeText(
                        "Upload Marks from sessional ${sessional+1}",
                        style: GoogleFonts.tiltNeon(
                            fontSize: size.width*0.05,
                            color: Colors.red[900]
                        ),
                      ),
                    )
                        :
                    const SizedBox(),
                    Card(
                      elevation: 30,
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: size.width * 0.06,
                            backgroundColor: Colors.green[900],
                            child:  snapshot.data?.docs[index].data()["Profile_URL"] !="null" && snapshot.data?.docs[index].data()["Profile_URL"] != null
                                ?
                            CircleAvatar(
                              radius: size.width * 0.055,
                              backgroundImage: NetworkImage(snapshot.data?.docs[index].data()["Profile_URL"]),
                            )
                                :
                            CircleAvatar(
                              radius: size.width * 0.055,
                              backgroundImage: const AssetImage("assets/images/unknown.png"),
                            )
                        ),
                        title: AutoSizeText(
                          snapshot.data?.docs[index].data()["Name"],
                          style: GoogleFonts.tiltNeon(
                            fontSize: size.width*0.05,
                            color: Colors.black
                          ),
                        ),
                        subtitle: AutoSizeText(
                          snapshot.data?.docs[index].data()["Rollnumber"],
                          style: GoogleFonts.tiltNeon(
                              fontSize: size.width*0.035,
                              color: Colors.black87
                          ),
                        ),
                        trailing: SizedBox(
                          width: size.width*0.26,
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width*0.14,
                                child: TextField(
                                  onTap: (){
                                    setState(() {
                                      currIndex=index;
                                    });
                                  },
                                  controller: controllers[index],
                                  focusNode: nodes[index],
                                  maxLength: 3,
                                  maxLines: 1,
                                  cursorColor: Colors.green,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 1.5
                                      )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(size.width*0.01))
                                    )
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    if(controllers[index].text.isNotEmpty){
                                      await FirebaseFirestore
                                          .instance
                                          .collection("Students")
                                          .doc(snapshot.data?.docs[index].data()["Email"]).update({
                                        "Marks.$subject_filter.Sessional_${sessional+1}" : int.parse(controllers[index].text.toString()),
                                        "Marks.$subject_filter.Total" : sessional+1,
                                      }).whenComplete((){
                                        uploadedName.add(snapshot.data?.docs[index].data()["Name"]);
                                      });
                                      controllers.removeAt(index);
                                      emails.removeAt(index);
                                      nodes.removeAt(index);
                                      setState(() {

                                      });
                                    }
                                    else{
                                      InAppNotifications.instance
                                        ..titleFontSize = 25.0
                                        ..descriptionFontSize = 15.0
                                        ..textColor = Colors.black
                                        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
                                        ..shadow = true
                                        ..animationStyle = InAppNotificationsAnimationStyle.scale;
                                      InAppNotifications.show(
                                        title: 'Error',
                                        duration: const Duration(seconds: 2),
                                        description: "Marks cannot be empty",
                                        leading: const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.check,color: Colors.green,))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
                },
            )
                :
            const SizedBox();
          },
      ),
    );
  }
}
