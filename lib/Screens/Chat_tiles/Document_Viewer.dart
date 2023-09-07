import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';
import '../loadingscreen.dart';

class DocumentViewer extends StatefulWidget {
  const DocumentViewer(
      {super.key,
      required this.document,
      required this.replyToName,
      required this.replyBoxHeight,
      required this.replyToText});
  final FilePickerResult? document;

  final String replyToName;

  final double replyBoxHeight;

  final String replyToText;
  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  List<PdfController> pdfControllers = [];
  late PdfDocument page;
  int pdfIndex = 0;
  List<Uint8List> imageBytes = [];
  bool load = false;
  bool initialized = false;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var file in widget.document!.files) {
      pdfControllers.add(PdfController(document: PdfDocument.openFile("${file.path}")));
    }
    getBytes();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(),
      body: initialized
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                load
                    ? SizedBox(
                        height: size.height * 0.15,
                        child: ListView.builder(

                          scrollDirection: Axis.horizontal,
                          itemCount: imageBytes.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  pdfIndex=index;
                                });
                              },
                              child: Container(
                                height: size.height * 0.2,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        image: MemoryImage(imageBytes[index]),
                                        fit: BoxFit.contain)),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: PdfView(

                    scrollDirection: Axis.vertical,
                    controller: pdfControllers[pdfIndex],
                  ),
                ),
              ],
            )
          : const loading(
              text: 'Loading Pdf please wait',
            ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: size.width,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(alignment: Alignment.bottomCenter, children: [
                AnimatedContainer(
                  height: widget.replyBoxHeight,
                  width: size.width * 0.78,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  duration: const Duration(milliseconds: 100),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        margin: EdgeInsets.only(
                          bottom: size.height * 0.07,
                          top: size.height * 0.01,
                          right: size.height * 0.01,
                          left: size.height * 0.01,
                        ),
                        padding: EdgeInsets.all(size.height * 0.008),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.replyToName,
                              style: GoogleFonts.exo(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            Text(
                              widget.replyToText,
                              style: GoogleFonts.exo(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear))
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.062,
                  width: size.width * 0.78,
                  child: TextField(
                    controller: messageController,
                    enableSuggestions: true,
                    maxLines: 5,
                    minLines: 1,
                    autocorrect: true,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () async {
                            // ImagePicker imagePicker=ImagePicker();
                            // print(imagePicker);
                            // XFile? file=await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                          },
                          icon: Icon(
                            Icons.image,
                            color: Colors.black,
                            size: size.height * 0.04,
                          )),
                      suffixIconColor: Colors.black,
                      fillColor: Colors.white70,
                      filled: true,
                      hintText: "Message",
                      hintStyle: GoogleFonts.exo(
                        color: Colors.black54,
                        fontSize: 19, //height:size.height*0.0034
                      ),
                      contentPadding: EdgeInsets.only(left: size.width * 0),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1)),
                      prefixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        size: size.height * 0.042,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ]),
              TextButton(
                onPressed: () {},
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: size.height * 0.032,
                  child: Icon(
                    Icons.send,
                    size: size.height * 0.032,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    setState(() {
      initialized = true;
      load = true;
    });
  }
}
