import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopThree extends StatelessWidget {
  const TopThree({super.key, required this.data});
  final List<Map<String , dynamic>> data;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.32,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.07,
          ),
          SizedBox(
            width: size.width * 0.214,
            child: Column(children: [
              SizedBox(
                height: ((size.height * 0.12) + (size.width * 0.214)),
                child: Stack(children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Students").doc(data[1]["Email"]).snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData ?
                        CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: size.width * 0.107,
                            child: snapshot.data!.data()?['Profile_URL'] != null && snapshot.data!.data()?['Profile_URL'] != "null"
                                ?
                            CircleAvatar(
                                backgroundColor: Colors.green[600],
                                radius: size.width * 0.1,
                                backgroundImage: NetworkImage(snapshot.data!.data()?['Profile_URL'])
                            )
                                :
                            CircleAvatar(
                              backgroundColor: Colors.green[600],
                              radius: size.width * 0.1,
                              backgroundImage: const AssetImage("assets/images/unknown.png"),
                            )

                        ) : const SizedBox();
                      }
                    ),
                  ),
                  Positioned(
                    top: ((size.height * 0.12) - (size.width * 0.03)),
                    left: ((size.width * 0.107) - (size.width * 0.03)),
                    child: CircleAvatar(
                      radius: size.width * 0.03,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: size.width * 0.026,
                        child: const SizedBox(
                          child: AutoSizeText(
                            '2',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                ),
              ),
              SizedBox(
                height: size.height*0.01,
              ),
              Center(
                child: SizedBox(
                  width: size.width * 0.2,
                  child: AutoSizeText(
                    data[1]["Name"]
                    ,
                    style: GoogleFonts.tiltNeon(
                        fontSize: size.width*0.04,
                        color: Colors.black
                    ),

                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              AutoSizeText(
                "${data[1]["Submitted"]} / ${data[1]["outOf"]}",
                style: const TextStyle(
                  color: Color.fromARGB(255, 10, 52, 84),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            ),
          ),
          SizedBox(
            width: size.width * 0.069,
          ),
          SizedBox(
            width: size.width * 0.294,
            child: Column(
              children: [
                SizedBox(
                  height: ((size.height * 0.05) + (size.width * 0.294)),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("Students").doc(data[0]["Email"]).snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ?
                            CircleAvatar(
                                radius: size.width * 0.147,
                                backgroundColor: Colors.black,
                                child:  snapshot.data!.data()?['Profile_URL'] != null && snapshot.data!.data()?['Profile_URL'] != "null"
                                    ?
                                CircleAvatar(
                                  backgroundColor: Colors.green[600],
                                  radius: size.width * 0.14,
                                  backgroundImage: NetworkImage(snapshot.data!.data()?['Profile_URL'])

                                  ,
                                )
                                    :
                                CircleAvatar(
                                  backgroundColor: Colors.green[600],
                                  radius: size.width * 0.14,
                                  backgroundImage: const AssetImage("assets/images/unknown.png"),
                                )
                            )
                                :
                            const SizedBox();
                          }
                        ),
                      ),
                      Positioned(
                        top: ((size.height * 0.05) - (size.width * 0.03)),
                        left: ((size.width * 0.147) - (size.width * 0.03)),
                        child: CircleAvatar(
                          radius: size.width * 0.03,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: size.width * 0.026,
                            child: const SizedBox(
                              child: AutoSizeText(
                                '1',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height*0.01,
                ),
                Center(
                  child: SizedBox(
                    width: size.width * 0.24,
                    child: AutoSizeText(
                      data[0]["Name"],
                      style: GoogleFonts.tiltNeon(
                        color: Colors.black,
                        fontSize: size.width * 0.05,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AutoSizeText( "${data[0]["Submitted"]} / ${data[0]["outOf"]}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 10, 52, 84),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.069,
          ),
          SizedBox(
            width: size.width * 0.214,
            child: Column(
              children: [
                SizedBox(
                  height: ((size.height * 0.12) + (size.width * 0.214)),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("Students").doc(data[2]["Email"]).snapshots(),
                          builder: (context, snapshot) {
                            return
                              snapshot.hasData
                                  ?
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: size.width * 0.107,
                                child:  snapshot.data!.data()?['Profile_URL'] != null && snapshot.data!.data()?['Profile_URL'] != "null"
                                    ?
                                CircleAvatar(
                                    radius: size.width * 0.1,
                                    backgroundColor: Colors.green[600],
                                    backgroundImage: NetworkImage(snapshot.data!.data()?['Profile_URL'])
                                )
                                    :
                                CircleAvatar(
                                    radius: size.width * 0.1,
                                    backgroundColor: Colors.green[600],
                                    backgroundImage: const AssetImage("assets/images/unknown.png")

                                )
                            )
                                  :
                              const SizedBox();
                          }
                        ),
                      ),

                      Positioned(
                        top: ((size.height * 0.12) - (size.width * 0.03)),
                        left: ((size.width * 0.107) - (size.width * 0.03)),
                        child: CircleAvatar(
                          radius: size.width * 0.03,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: size.width * 0.026,
                            child: const SizedBox(
                              child: AutoSizeText(
                                '3',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height*0.01,
                ),
                SizedBox(
                  width: size.width * 0.2,
                  child: AutoSizeText(
                    data[2]["Name"]
                    ,
                    style: GoogleFonts.tiltNeon(
                      color: Colors.black,
                      fontSize: size.width * 0.04,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                AutoSizeText(
                  "${data[2]["Submitted"]} / ${data[2]["outOf"]}",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 10, 52, 84),
                        fontWeight: FontWeight.w500,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
