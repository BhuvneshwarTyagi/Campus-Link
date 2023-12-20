import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Constraints.dart';
import '../Screens/loadingscreen.dart';
import 'SkillsTile.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> with TickerProviderStateMixin {
  List<Widget> tabs=[];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/images/bg-image.png"),fit: BoxFit.fill
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Colors.black,
            // Colors.deepPurple,
            // Colors.purpleAccent
            const Color.fromRGBO(86, 149, 178, 1),

            const Color.fromRGBO(68, 174, 218, 1),
            //Color.fromRGBO(118, 78, 232, 1),
            Colors.deepPurple.shade300
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: AutoSizeText(
            "Skills", style: GoogleFonts.tiltNeon(
            fontSize: size.width*0.05,
            color: Colors.black
          ),
          ),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
          actions: [
            DropdownMenu(
              onSelected: (value) async {
                await FirebaseFirestore.instance.collection("Teachers").doc(usermodel["Email"]).update({
                  "Skills": FieldValue.arrayUnion([value])
                });
              },
                dropdownMenuEntries: const [
              DropdownMenuEntry(value: "C Programming", label: "C Programming"),

                DropdownMenuEntry(value: "DBMS", label: "DBMS")
              ],
            )
          ],
        ),
        body:  Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: usermodel["Skills"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print(usermodel["Skills"][index]);
                  return StreamBuilder(
                    stream: FirebaseFirestore
                        .instance
                        .collection("Teacher Courses")
                        .doc("${usermodel["Skills"][index]}")
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(snapshot.data?.data());
                      if(snapshot.hasData){
                        print(snapshot.data?.data());
                      }
                      return snapshot.hasData
                          ?
                      snapshot.data!.data()!=null
                          ?
                      SkillsTile(
                        title: usermodel["Skills"][index],
                        status: usermodel["${usermodel["Skills"][index]}-record"] ==null ?  "Pending" :usermodel["${usermodel["Skills"][index]}-record"]["Status"],
                        currentLevel: usermodel["${usermodel["Skills"][index]}-record"] ==null ?  0 :usermodel["${usermodel["Skills"][index]}-record"]["Level"],
                        urls: snapshot.data?.data()!["Contant"] ,
                        name: usermodel["Skills"][index], quiz: snapshot.data?.data()!["Level-1"],
                      )
                          :
                      Center(
                        child: AutoSizeText(
                          "No Data found!",
                          style: GoogleFonts.tiltNeon(
                              color: Colors.black87,
                              fontSize: size.width*0.08
                          ),
                        ),
                      )
                          :
                      const loading(text: "Fetching data from server");
                    },
                  );

                }
            ),
          ],
        )
      ),
    );
  }
}
