import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:campus_link_teachers/Screens/Notes/Notes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../Constraints.dart';
import '../../Database/database.dart';
import '../loadingscreen.dart';

class AlternativeNotesBottomSheet extends StatefulWidget {
  const AlternativeNotesBottomSheet({super.key, required this.notesIndex});
  final int notesIndex;
  @override
  State<AlternativeNotesBottomSheet> createState() => _AlternativeNotesBottomSheetState();
}

class _AlternativeNotesBottomSheetState extends State<AlternativeNotesBottomSheet> {
  List<Uint8List> imageBytes = [];
  bool a=true;
  TextEditingController videoController = TextEditingController();
  TextEditingController notesDescription = TextEditingController();
  double percent=0.0;

  int notesCount=0;
  bool fileSelected=false;
  late  FilePickerResult? filePath;
  List<PdfController> pdfControllers = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: EdgeInsets.all(size.height * 0.009),
            child: Row(
              children: [
                AutoSizeText(
                  "Upload File",
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: size.height * 0.023,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                const Icon(
                  Icons.cloud_upload,
                  color: Colors.black,
                )
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: size.height * 0.1,
                width: size.width,
                child: DottedBorder(
                    color: Colors.black,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          size: size.height * 0.04,
                          Icons.upload_sharp,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        AutoSizeText(
                          "Drop item here  or",
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: size.height * 0.02,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FilePicker
                                .platform
                                .pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                                allowMultiple: false).then((value) {
                              if(value!.files[0].path!.isNotEmpty && (value.files[0].extension=="pdf" || value.files[0].extension=="docx")) {
                                filePath = value;
                                print(".......PickedFile${filePath
                                    ?.files[0].path}");
                                setState(() {
                                  fileSelected=true;
                                });
                              }
                              else{
                                print("Extension is : ${value.files[0].extension}");
                                setState(() {
                                  fileSelected=false;
                                });
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
                                    description: "Please select only PDF or doc type",
                                    leading: const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 40,
                                    ));
                              }
                            });
                          },
                          child: AutoSizeText(
                            "Browse File",
                            style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.w700),
                          ),


                        ),
                        fileSelected
                            ?
                        Icon(
                          size: size.height * 0.02,
                          Icons.check_circle,
                          color: Colors.green,
                        )
                            :
                        const SizedBox()
                      ],
                    )
                )),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: size.height * 0.07,
                width: size.width,
                child: DottedBorder(
                  color: Colors.black,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: videoController,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.height*0.018
                    ),
                    decoration:  const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Additional Link ",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        )),
                    cursorColor: Colors.black,
                  ),
                )),
          ),
          SizedBox(
            height: size.height*0.03,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: size.height * 0.07,
                width: size.width,
                child: DottedBorder(
                  color: Colors.black,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: notesDescription,
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size.height*0.018
                    ) ,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Notes Description ",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        )),
                    cursorColor: Colors.black,
                  ),
                )),
          ),
          SizedBox(
            height: size.height*0.03,),
          Center(
            child: Container(
              height: size.height * 0.06,
              width: size.width * 0.466,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue,
                      Colors.purpleAccent,
                    ],
                  ),
                  borderRadius:  BorderRadius.all(Radius.circular(size.width*0.033)),
                  border: Border.all(color: Colors.black, width: 2)
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent
                ),
                onPressed: () async {
                  if(fileSelected && notesDescription.text.toString().isNotEmpty && videoController.text.toString().isNotEmpty)
                  {
                    Navigator.push(context, PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: const Duration(milliseconds: 400),
                        childCurrent: const Notes(),
                        child: const loading(text: "Data is uploading to server please wait.......")));
                    DateTime stamp= DateTime.now();
                    DateTime deadline= DateTime.now();


                    pdfControllers.add(PdfController(document: PdfDocument.openFile("${filePath?.files[0].path}")));
                    getBytes();

                    Reference reference=FirebaseStorage.instance.ref();


                    Reference imageDirectory=reference.child("Notes");


                    Reference pdfFolder=imageDirectory.child("$university_filter $college_filter $branch_filter $year_filter $section_filter $subject_filter");

                    Reference channel=pdfFolder.child("$stamp");


                    TaskSnapshot snap= await channel.putFile(File("${filePath?.files[0].path}"));
                    String pdfURL=await snap.ref.getDownloadURL();

                    print("......File Uploaded $pdfURL");
                    Directory? directory = await getApplicationSupportDirectory();
                    String additionalPath= "/Notes";
                    directory = Directory("${directory.path}$additionalPath");
                    // File file = await File("${directory.path}/$stamp.pdf").create(recursive: true);



                    // Create Thumbnail of the Pdf


                    Reference imageFolder=pdfFolder.child("image");
                    Reference channel_2=imageFolder.child("$stamp");


                    String additionalPathForImage= "/images";
                    File image = await File("${Directory("${directory.path}$additionalPathForImage").path}/$stamp.jpg").create(recursive: true);

                    File imagePath = await image.writeAsBytes(imageBytes[0]);

                    //String path = await VideoThumbnail.thumbnailFile(video: URL,imageFormat: ImageFormat.PNG,quality: 1,thumbnailPath: (await getApplicationDocumentsDirectory()).path) ?? "";


                    snap= await channel_2.putFile(File(imagePath.path));
                    String imageURL=await snap.ref.getDownloadURL().whenComplete(() => print(".............First Image Created and uploaded..."));
                    /* String additionalPathForThumb= "/thumbnail";
                                 XFile? compressed;
                                 File thumb = await File("${Directory("${directory.path}$additionalPathForThumb").path}/$stamp.jpg").create(recursive: true);

                                 await FlutterImageCompress.compressAndGetFile(
                                   imagePath.path,
                                   thumb.path,
                                   quality: 1,
                                   //format: CompressFormat.png
                                 ).then((value) => compressed=value);

                                 Reference thumbnailFolder=pdfFolder.child("thumbnail");
                                 Reference channel_3=thumbnailFolder.child("$stamp");
                                 snap= await channel_3.putFile(File(thumb.path));
                                 String thumbnailURL=await snap.ref.getDownloadURL().whenComplete(() => print("..Thumbnail uploaded"));
*/



                    // Thumbnail Created

                      FirebaseFirestore
                          .instance
                          .collection("Notes")
                          .doc(
                          "${university_filter.split(" ")[0]} ${college_filter.split(" ")[0]} ${course_filter.split(" ")[0]} ${branch_filter.split(" ")[0]} $year_filter $section_filter $subject_filter")
                          .update({
                        "Notes-${widget.notesIndex}.Alternatives": FieldValue.arrayUnion([
                          {
                            "Stamp":stamp,
                            "File_Size":filePath?.files[0].size,
                            "File_Name":filePath?.files[0].name,
                            "Pdf_URL":pdfURL,
                            "Notes_description":notesDescription.text.toString().trim(),
                            "Additional_Link":videoController.text.toString().trim(),
                            "imageURL":imageURL,
                            "Quiz_Created":false,
                          }
                        ]),
                      }).whenComplete(() {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                    var studentsDoc =     await FirebaseFirestore.instance.collection("Students")
                        .where("University",isEqualTo: university_filter)
                        .where("College",isEqualTo: college_filter)
                        .where("Branch",isEqualTo: branch_filter)
                        .where("Course",isEqualTo: course_filter)
                        .where("Year",isEqualTo: year_filter)
                        .where("Section",isEqualTo: section_filter)
                        .where("Subject",arrayContains: subject_filter).get();
                    List<dynamic> tokens =[];
                    List<dynamic> emails=[];
                    for(int i=0;i<studentsDoc.docs.length ; i++){
                      tokens.add(studentsDoc.docs[i].data()["Token"]);
                    }
                    for(int i=0;i<tokens.length;i++ ){
                      database().sendPushMessage(tokens[i], "$subject_filter Notes ${notesCount+1} uploaded,Quiz DeadLine: $deadline","$subject_filter Notes ${notesCount+1}", false, "", stamp);
                      await FirebaseFirestore.instance.collection("Students").doc(emails[i]).update({
                        "Notifications" : FieldValue.arrayUnion([{
                          "title" : "$subject_filter notes ${widget.notesIndex} alternative notes",
                          'body' : 'Your teacher uploaded alternative notes for $subject_filter notes ${widget.notesIndex}'
                        }])
                      });
                    }
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
                        description: "Please select all field",
                        leading: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ));
                  }
                },
                child:  AutoSizeText("Submit",
                  style: GoogleFonts.openSans(
                      fontSize: size.height * 0.025, color: Colors.black,
                      fontWeight: FontWeight.w700
                  ),

                ),
              ),
            ),
          ),


        ]);
  }
  getBytes() async {
    for (var controller in pdfControllers) {
      PdfDocument doc = await controller.document;
      PdfPage page = await doc.getPage(1);
      PdfPageImage? image = await page.render(
          width: 400,
          height: 400,
          format: PdfPageImageFormat.png,
          backgroundColor: "#FFFFFF");
      imageBytes.add(image!.bytes);
      await page.close();
      print("............running");
    }
    print("..........................\n${imageBytes[0]}");

  }
}
