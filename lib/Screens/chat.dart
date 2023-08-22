import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class chat_page extends StatefulWidget {
  const chat_page({Key? key}) : super(key: key);

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(63, 63, 63,1),
        leadingWidth: size.width*0.05,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: size.height*0.03,
              backgroundColor: Colors.white70,
            ),
            SizedBox(
              width: size.width*0.03,
            ),
            AutoSizeText(
              "Arun Kumar",
              style: GoogleFonts.exo(
                color: Colors.white
              ),
            ),
          ],
        ),
        actions:<Widget> [
          IconButton(onPressed: (){},
              icon: Icon(Icons.more_vert,size: size.height*0.04,))
        ],
      ),
      body: Container(
        height: size.height,
        color: Colors.black26,


      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width*1,
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                 SizedBox(
                   height: size.height*0.062,
                   width: size.width*0.84,
                   child: TextField(
                     enableSuggestions: true,
                     autocorrect: true,
                     textAlign:TextAlign.start,
                     style: const TextStyle(color: Colors.white,fontSize: 18),
                     decoration: InputDecoration(
                       fillColor: Colors.black12,
                       filled: true,
                       hintText: "Message",
                       hintStyle:  GoogleFonts.exo(
                           color: Colors.black54,
                           fontSize: 19,//height:size.height*0.0034
                       ),
                       contentPadding: EdgeInsets.only(left: size.width*0.2),
                       enabledBorder: const OutlineInputBorder(
                         borderRadius: BorderRadius.all(Radius.circular(30.0)),
                           borderSide: BorderSide(color: Colors.black54, width: 1)
                       ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.black54, width: 1)
                      ),
                      prefixIcon: Icon(Icons.emoji_emotions_outlined,size: size.height*0.042,color: Colors.black26,),
                     ),

                   ),
                 ),
                  ElevatedButton(onPressed: (){},
                      style: ElevatedButton.styleFrom(
                          padding:  EdgeInsets.symmetric(horizontal: size.width*0.01, vertical: size.height*0.01),
                          shape: const CircleBorder(

                          ), backgroundColor: Color.fromRGBO(63, 63, 63,1)
                      ),
                     child: Icon(Icons.send,size: size.height*0.04,)),
            ],
          ),
        ),
      ),
    );
  }

  Row show_date(String chat_time){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.032,
          width: MediaQuery.of(context).size.width*0.28,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(63, 63, 63,1),
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(
              color: const Color.fromRGBO(63, 63, 63,1),
              width: 1
            )
          ),
          child: Center(
            child: AutoSizeText(
                chat_time,
              style: GoogleFonts.exo(
                fontSize: 16,
                color:Colors.black54
              ),
            ),
          ),
        )
      ],
    );
  }
}
