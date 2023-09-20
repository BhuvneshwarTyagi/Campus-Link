import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


enum Options{ trueFalse,multipleChoice}
class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  TextEditingController videoController=TextEditingController();
  TextEditingController numberController=TextEditingController();
  List<TextEditingController>questionList=[TextEditingController()];
  List<TextEditingController>optionController=[TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()];
  List<String>options=["A","B","C","D","E"];
  int questionCount=1;

  Options? _options;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height ,
        padding: EdgeInsets.all(size.height*0.01),
        decoration:  BoxDecoration(
          color: Colors.black26.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),

          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.all(
                      size.height * 0.009),
                  child: Row(
                    children: [
                      AutoSizeText(
                        "Upload File",
                        style: GoogleFonts.openSans(
                          color:  Colors.white,

                          fontSize: size.height * 0.023,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: size.width*0.02,),
                      const Icon(Icons.cloud_upload,color: Colors.white,)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: size.height*0.1,
                      width: size.width,

                      child: DottedBorder(
                        color: Colors.white,
                        borderType: BorderType.RRect,

                        radius: const Radius.circular(12),
                        padding:  EdgeInsets.all(size.height*0.01),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Icon(

                              size: size.height*0.04,
                              Icons.upload_sharp,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: size.width*0.03,
                            ),
                            AutoSizeText("Drop item here  or",

                              style:   GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: size.height * 0.02,
                              ),

                            ),


                            TextButton(
                              onPressed: (){},
                              child:AutoSizeText("Browse File",
                                style:   GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: size.height * 0.02,
                                    fontWeight: FontWeight.w700
                                ),


                              ) ,


                            )


                          ],
                        ),
                      )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: size.height*0.07,
                      width: size.width,

                      child: DottedBorder(
                        color: Colors.white,
                        borderType: BorderType.RRect,

                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(10),
                        child:TextField(
                          controller: videoController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,

                              hintText: "Enter Video Link Here ",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )

                          ),
                          cursorColor: Colors.white,

                        ),
                      )
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(size.height*0.01),
                  child: TextField(
                    controller: numberController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        disabledBorder:UnderlineInputBorder (
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Enter the  number of Question",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        )
                    ),
                    cursorColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height*0.6,
                    width: size.width,
                    child: ListView.builder(
                      itemCount: questionCount,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SizedBox(
                            height: size.height*0.6,
                            width: size.width,
                            child:SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: questionList[index],
                                    autocorrect: true,
                                    keyboardType:TextInputType.text,
                                    minLines: 3,
                                    maxLines: 6,
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      hintText: "Write your Question here......",
                                      hintStyle: const TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.all(size.height*0.02),
                                      helperStyle: GoogleFonts.openSans(
                                          color: Colors.white54,
                                          fontSize: size.height*0.022
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white54,
                                              width:2
                                          )
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              width:2
                                          )
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white54,
                                              width:2
                                          )
                                      ),
                                      focusedBorder:const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: Colors.white54,
                                              width:2
                                          )
                                      ) ,
                                    ),
                                    style: GoogleFonts.openSans(
                                        fontSize: size.height*0.022,
                                        color: Colors.white
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height*0.01,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: Colors.white,
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title: AutoSizeText("MultipleChoice",
                                            style: TextStyle(color: Colors.white,
                                                fontSize: size.height*0.02
                                            ),
                                          ),
                                          value: Options.multipleChoice, groupValue: _options,
                                          onChanged: (value) {
                                            setState(() {
                                              _options=value;
                                            });

                                          },),
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: Colors.white,
                                          contentPadding: const EdgeInsets.all(0.0),
                                          title:  AutoSizeText("True or false",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height*0.02
                                            ),
                                          ),
                                          value: Options.trueFalse, groupValue: _options,
                                          onChanged: (value) {
                                            setState(() {
                                              _options=value;
                                            });
                                          },),
                                      )
                                    ],
                                  ),

                                  /*SizedBox(
                                                      height: size.height*0.02,
                                                      width: size.width*0.9,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: size.height*0.04,
                                                            width: size.width*0.9,
                                                            child: ListTile(
                                                              splashColor: Colors.transparent,

                                                              onTap: (){

                                                              },
                                                              title: const AutoSizeText("Single option"),
                                                              titleTextStyle: GoogleFonts.exo(
                                                                  color: Colors.white,
                                                                  fontSize: size.height*0.022,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                              leading: Radio(
                                                                activeColor: Colors.white54,
                                                                focusColor: Colors.limeAccent,
                                                                value: "Single option",
                                                                onChanged: (value) {
                                                                  setState(
                                                                        () {

                                                                    },
                                                                  );
                                                                }, groupValue: "Single option",
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )*/
                                  _options==Options.multipleChoice?
                                  SizedBox(
                                    height: size.height*0.5,
                                    width: size.width*0.9,
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height: size.height*0.065,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                border: Border.all(
                                                    color: Colors.white54,
                                                    width: 2
                                                )
                                            ),
                                            child: TextField(
                                              controller:optionController[index] ,
                                              decoration: InputDecoration(
                                                  hintText: options[index],
                                                  hintStyle: const TextStyle(color: Colors.white),
                                                  helperStyle: GoogleFonts.openSans(
                                                      color: Colors.white,
                                                      fontSize: size.height*0.022
                                                  )
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                      :
                                  SizedBox(
                                    height: size.height*0.2,
                                    width: size.width*0.9,
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height: size.height*0.065,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                border: Border.all(
                                                    color: Colors.white54,
                                                    width: 2
                                                )
                                            ),
                                            child: TextField(
                                              controller:optionController[index] ,
                                              decoration: InputDecoration(
                                                  hintText: options[index],
                                                  hintStyle: const TextStyle(color: Colors.white),
                                                  helperStyle: GoogleFonts.openSans(
                                                      color: Colors.white,
                                                      fontSize: size.height*0.022
                                                  )
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )


                                ],
                              ),
                            )
                        );
                      },),
                  ),
                )
              ]
          ),
        ));


  }
}
