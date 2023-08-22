import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constraints.dart';
import 'chat.dart';

class chatsystem extends StatefulWidget {
  const chatsystem({super.key});

  @override
  State<chatsystem> createState() => _chatsystemState();
}

class _chatsystemState extends State<chatsystem> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(63, 63, 63,1),
        leadingWidth: size.width*0.07,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text("Campus Link"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Teachers").doc(usermodel["Email"]).snapshots(),
        builder: (context, snapshot) {
          return
            snapshot.hasData
              ?
            ListView.builder(
              itemCount: snapshot.data?.data()!["Message_channels"].length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => chat_page(channel: snapshot.data?.data()!["Message_channels"][index]),
                        ));
                  },
                  child: Container(
                    height: 90,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    padding: EdgeInsets.all(size.width*0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color.fromRGBO(86, 149, 178, 1),
                          radius: 30,

                          child: Text("P",
                            style: TextStyle(color: Colors.black,fontSize: 30),

                          ),
                        ),
                        SizedBox(width: size.width*0.03),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText("${snapshot.data?.data()!["Message_channels"][index]}",
                              style: GoogleFonts.poppins(color: Colors.black,fontSize: 18),
                            ),
                            SizedBox(
                              height: size.height*0.03,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            )
                :
                const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
