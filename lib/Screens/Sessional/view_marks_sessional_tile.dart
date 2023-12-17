

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SessionalEditTile extends StatefulWidget {
  const SessionalEditTile({super.key, required this.sessionalindex, required this.sessionalmarks, required this.sessionaltotal, required this.email, required this.subject});
  final int sessionalindex;
  final int sessionalmarks;
  final int sessionaltotal;
  final String subject;
  final String email;
  @override
  State<SessionalEditTile> createState() => _SessionalEditTileState();
}

class _SessionalEditTileState extends State<SessionalEditTile> {

  TextEditingController marks = TextEditingController();
  TextEditingController total = TextEditingController();
  bool enable=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marks.text="${widget.sessionalmarks}";
    total.text="${widget.sessionaltotal}";
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return ListTile(
      title: AutoSizeText(
        "Sessional ${widget.sessionalindex}",
        style: GoogleFonts.tiltNeon(
            fontSize: size.width*0.05,
            color: Colors.black
        ),
      ),
      trailing: SizedBox(

        width: size.width*0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            enable
                ?
            Row(
              children: [
                Container(

                  width: size.width*0.15,
                  //height: size.height*0.05,
                  margin: const EdgeInsets.all(4),
                  child: TextField(
                    controller: marks,
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

                          borderRadius: BorderRadius.all(
                            Radius.circular(size.width*0.01),
                          ),

                        )
                    ),
                  ),
                ),
                AutoSizeText(
                  "/",
                  style: GoogleFonts.tiltNeon(
                      fontSize: size.width*0.06,
                      color: Colors.black
                  ),
                ),
                Container(

                  width: size.width*0.15,
                  //height: size.height*0.05,
                  margin: const EdgeInsets.all(4),
                  child: TextField(
                    controller: total,
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

                          borderRadius: BorderRadius.all(
                            Radius.circular(size.width*0.01),
                          ),

                        )
                    ),
                  ),
                ),

              ],
            )
                :
            AutoSizeText("${widget.sessionalmarks}/${widget.sessionaltotal}",style: GoogleFonts.tiltNeon(
              fontSize: size.width*0.055,
              color: Colors.black
            ),),
            enable
                ?
            IconButton(
              onPressed: () async {
                if(int.parse(marks.text.trim()) < int.parse(total.text.trim())){
                await FirebaseFirestore.instance.collection("Students").doc(widget.email).update({
                  "Marks.${widget.subject}.Sessional_${widget.sessionalindex}" : int.parse(marks.text.trim()),
                  "Marks.${widget.subject}.Sessional_${widget.sessionalindex}_total" : int.parse(total.text.trim()),
                });
                setState(() {
                enable=!enable;
                });
                }
              },
              icon: const Icon(Icons.check,color: Colors.green,),
            )
                :
            IconButton(
              onPressed: (){
                setState(() {
                  enable=!enable;
                });
              },
              icon: const Icon(Icons.edit,color: Colors.black,),
            )
          ],
        ),
      ),
    );
  }
}
