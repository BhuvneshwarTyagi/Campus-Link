import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';
import '../Screens/Main_page.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController nameController = TextEditingController();

  TextEditingController exployeeIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
        body: Container(

          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.04, 0,
                MediaQuery.of(context).size.width * 0.04, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Regcon,
                    border: Border.all(color: Colors.black),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 60,
                          blurStyle: BlurStyle.outer,
                          color: Colors.black54,
                          offset: Offset(1, 1)
                      )
                    ],
                    image: const DecorationImage(
                        image: AssetImage("assets/icon/icon.png")),
                  ),
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                ),
                AnimatedTextKit(
                  animatedTexts: [

                    WavyAnimatedText('Welcome To Campus Link',

                      textStyle: GoogleFonts.libreBaskerville(
                        fontSize: size.width*0.06,
                        fontWeight: FontWeight.w800,
                        color: Colors.white54,
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(1, 1),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                  ],
                  repeatForever: true,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.07,
                ),

                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.black,),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      child: TextField(
                          controller: nameController,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    nameController.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                              label: const Text("Your Name"),
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)
                              )
                          ),
                          keyboardType: TextInputType.emailAddress),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.black,),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ],
                      ),
                      child: TextField(
                          controller: exployeeIDController,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    exployeeIDController.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                              label: const Text("Your Employee Id"),
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              fillColor: Colors.black26.withOpacity(0.7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)
                              )
                          ),
                          keyboardType: TextInputType.emailAddress),
                    ),

                    SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.03
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.07,
                      decoration: BoxDecoration(
                          gradient:const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.purpleAccent],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black54,width: 2)
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = await FirebaseAuth.instance.currentUser?.email;
                          await FirebaseFirestore.instance.collection("Teachers").doc(email).set({
                            "Email" : email,
                            "Name" : nameController.text.trim(),
                            "Employee Id" : exployeeIDController.text.trim(),
                            "bg" : "bg-1.jpg"
                          });
                          final record = await FirebaseFirestore.instance.collection("Teacher_record").doc("Email").get();
                          record.exists
                          ?
                          await FirebaseFirestore.instance.collection("Teacher_record").doc("Email").update({
                            "Email": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.email])
                          })
                          :
                          await FirebaseFirestore.instance.collection("Teacher_record").doc("Email").set({
                          "Email": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.email])
                          })
                          ;
                          await FirebaseFirestore.instance.collection("Teachers").doc(email).collection("Teachings").doc("Teachings").set({}).whenComplete(
                          () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return const MainPage();
                          },));
                          } );
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.black54,
                            elevation: 30

                        ),
                        child: const Text("Sign Up", style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
