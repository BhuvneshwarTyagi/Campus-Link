import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

import '../../push_notification/Storage_permission.dart';

class quizExcelSheet extends StatefulWidget {
  const quizExcelSheet({super.key,required this.uni, required this.clg, required this.course, required this.branch, required this.year, required this.section, required this.subject});
  final String uni;
  final String clg;
  final String course;
  final String branch;
  final String year;
  final String section;
  final String subject;


  @override
  State<quizExcelSheet> createState() => _quizExcelSheetState();
}

class _quizExcelSheetState extends State<quizExcelSheet> {
  final FileManagerController controller = FileManagerController();
  var checkALLPermissions = CheckPermission();
  bool isPermission = false;
  bool loading=true;
  late Directory path;
  Future<void> setpath() async {
    checkPermission();
    path = Directory("/storage/emulated/0/Campus Link/Quiz Score Sheet/${widget.uni} ${widget.clg} ${widget.course} ${widget.branch} ${widget.year} ${widget.section} ${widget.subject}");
    if(! ( path!.existsSync())){
      await Directory(path.path).create(recursive: true);
    }
    setState(() {
      controller.setCurrentPath=path.path;
      loading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setpath();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*1,
      width: size.width*1,
      decoration: BoxDecoration(
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
        appBar:  AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.black26,
          centerTitle: true,
          title: AutoSizeText(
            "Download Sheet",
            style: GoogleFonts.gfsDidot(
                fontSize: size.height * 0.03, color: Colors.black),
          ),
          actions: [
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                size: size.height * 0.035,
                color: Colors.black,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: TextButton(
                          onPressed: () async {
                            print("all Quize clicked.....");
                            if(isPermission)
                            {
                              var excel = Excel.createExcel();
                              Sheet sheetObject = excel["All Quiz Score"];
                              List<dynamic> initialrow = [];
                              initialrow.add("Sr no.");
                              initialrow.add("Name");
                              initialrow.add("Roll Number");
                              initialrow.add("Score");
                              initialrow.add("Quiz Attempted");
                              initialrow.add("Total Quiz");
                              sheetObject.appendRow(initialrow);

                              await  FirebaseFirestore
                                  .instance
                                  .collection("Students")
                                  .where("University", isEqualTo:widget.uni)
                                  .where("College", isEqualTo: widget.clg)
                                  .where("Course", isEqualTo: widget.course)
                                  .where("Branch", isEqualTo:widget.branch)
                                  .where("Year", isEqualTo: widget.year)
                                  .where("Section", isEqualTo: widget.section)
                                  .where("Subject", arrayContains: widget.year)
                                  .where("Name",isNull: false)
                                  .orderBy("Name")
                                  .get().then((value) async {
                               await FirebaseFirestore.instance
                                    .collection("Notes")
                                    .doc(
                                    "${widget.uni.split(" ")[0]} ${widget.clg.split(" ")[0]} ${widget.course.split(" ")[0]} ${widget.branch.split(" ")[0]} ${widget.year.split(" ")[0]} ${widget.section} ${widget.subject}")
                                    .get().then((snapshot) {
                                      int quizCount=0;
                                      for(int i=1;i<=snapshot.data()?["Total_Notes"];i++)
                                        {
                                          if(snapshot.data()?["Notes-$i"]["Quiz_Created"])
                                            {
                                              quizCount++;
                                            }
                                        }
                                      print("Quiz Count is : $quizCount");

                                 for(int i=0;i<value.docs.length;i++)
                                 {
                                   if(snapshot.data()?[value.docs[i]["Email"].toString().split("@")[0]]!=null){
                                     print("Entry...${i+1}");
                                     sheetObject.appendRow([i+1,"${value.docs[i]["Rollnumber"]}","${value.docs[i]["Name"]}","${snapshot.data()?[value.docs[i]["Email"].toString().split("@")[0]]["Score"]}","${snapshot.data()?[value.docs[i]["Email"].toString().split("@")[0]]["Quiz_attempted"]}","${quizCount}"]);
                                   }
                                   else{
                                     sheetObject.appendRow([i+1,"${value.docs[i]["Rollnumber"]}","${value.docs[i]["Name"]}","NA"]);
                                   }
                                 }

                               }) ;

                              });
                              var fileBytes = excel.save();
                              var fileName =
                                  "All Quiz Score.xls";
                              if (!(path.existsSync())) {
                                await Directory(path.path)
                                    .create(recursive: true).whenComplete(() {
                                  print("File Created");
                                });
                              }
                              File(join('${path.path}/$fileName'))
                                ..create(recursive: true)
                                ..writeAsBytes(fileBytes!).whenComplete(() {
                                  print("Write Created......");
                                  Navigator.pop(context);
                                  setState(() {

                                  });
                                });

                            }
                          },
                          child: const Text(
                            "All Quiz",
                            style: TextStyle(color: Colors.black),
                          ))),
                  PopupMenuItem(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Notes")
                            .doc(
                            "${widget.uni.split(" ")[0]} ${widget.clg.split(" ")[0]} ${widget.course.split(" ")[0]} ${widget.branch.split(" ")[0]} ${widget.year.split(" ")[0]} ${widget.section} ${widget.subject}")
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          print("object");
                          return snapshot.data!=null
                              ? SizedBox(
                            height: size.height*0.1,
                            width: size.width*0.15,
                            child: ListView.builder(
                              itemCount: snapshot.data.data()["Total_Notes"],
                              itemBuilder: (context, index) {
                                return snapshot.data.data()["Notes-${index+1}"]["Quiz_Created"]
                                    ?
                                TextButton(
                                    onPressed: () async {
                                      if(isPermission)
                                      {
                                        var excel = Excel.createExcel();
                                        Sheet sheetObject = excel["Quiz-${index+1}"];
                                        List<dynamic> initialrow = [];
                                        initialrow.add("Name");
                                        initialrow.add("Roll Number");
                                        initialrow.add("Score");
                                        initialrow.add("Out Of");
                                        sheetObject.appendRow(initialrow);

                                        await  FirebaseFirestore
                                            .instance
                                            .collection("Students")
                                            .where("University", isEqualTo:widget.uni)
                                            .where("College", isEqualTo: widget.clg)
                                            .where("Course", isEqualTo: widget.course)
                                            .where("Branch", isEqualTo:widget.branch)
                                            .where("Year", isEqualTo: widget.year)
                                            .where("Section", isEqualTo: widget.section)
                                            .where("Subject", arrayContains: widget.year)
                                            .where("Name",isNull: false)
                                            .orderBy("Name")
                                            .get().then((value) {
                                          for(int i=0;i<value.docs.length;i++)
                                          {
                                            if(snapshot.data!.data()["Notes-${index+1}"]["Submitted by"]!=null && snapshot.data!.data()["Notes-${index+1}"]["Submitted by"].contains("${value.docs[i]["Email"].toString().split("@")[0]}-${value.docs[i]["Name"]}-${value.docs[i]["Rollnumber"]}")){
                                              print("Entry...${i+1}");
                                              sheetObject.appendRow(["${value.docs[i]["Rollnumber"]}","${value.docs[i]["Name"]}","${snapshot.data!.data()["Notes-${index+1}"]["Response"]["${value.docs[i]["Email"].toString().split("@")[0]}-${value.docs[i]["Name"]}-${value.docs[i]["Rollnumber"]}"]["Score"]}","10"]);
                                            }
                                            else{
                                              sheetObject.appendRow(["${value.docs[i]["Rollnumber"]}","${value.docs[i]["Name"]}","NA"]);
                                            }
                                          }

                                        });
                                        var fileBytes = excel.save();
                                        var fileName =
                                            "Quiz${index+1}.xls";
                                         if (!(path.existsSync())) {
                                          await Directory(path.path)
                                              .create(recursive: true).whenComplete(() {
                                            print("File Created");
                                          });
                                        }
                                        File(join('${path.path}/$fileName'))
                                          ..create(recursive: true)
                                          ..writeAsBytes(fileBytes!).whenComplete(() {
                                            print("Write Created......");
                                            Navigator.pop(context);
                                            setState(() {

                                            });
                                          });

                                      }

                                    },
                                    child: Text(
                                      "Quiz-${index + 1}",
                                      style:
                                      const TextStyle(color: Colors.black),
                                    ))
                                    :
                                const SizedBox();
                              },
                            ),
                          )
                              : const SizedBox();
                        },
                      ))
                ];
              },
            )
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              height: size.height*0.9,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height*0.85,
                    child: FileManager(
                        controller: controller,
                        builder: (context, snapshot) {
                          final List<FileSystemEntity> entities = snapshot;
                          int filescount=0;
                          if(!(entities.length.isNaN || entities.length.isInfinite)){
                            filescount=entities.length;
                            print("File Counrt is: ${filescount}");
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                            itemCount: filescount,
                            itemBuilder: (context, index) {
                              FileSystemEntity entity = entities[index];
                              print(".........Entity: $entity");
                              return Padding(
                                padding:  const EdgeInsets.only(top:8.0),
                                child: Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: FileManager.isFile(entity)
                                            ?
                                        SizedBox(
                                            height: size.height*0.06,
                                            child: const Image(image: AssetImage("assets/images/excel.png"),fit: BoxFit.contain,))
                                            :  Icon(Icons.folder,color: Colors.white,size: size.height*0.042),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              FileManager.basename(
                                                entity,
                                                showFileExtension: true,
                                              ),
                                              style: GoogleFonts.exo(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500

                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await Share.shareXFiles(
                                                          [XFile(entity.path)], text: '${widget.uni} ${widget.clg} ${widget.course} ${widget.branch} ${widget.year} ${widget.section} ${widget.subject} Quiz Sheet');
                                                    },
                                                    icon: const Icon(Icons.share,color: Colors.black,)),
                                                IconButton(
                                                    onPressed: () async {
                                                      await File(entity.path).delete();
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(Icons.delete_outline,color: Colors.black,)),
                                              ],
                                            ),

                                          ],
                                        ),
                                        subtitle: subtitle(entity),
                                        onTap: () async {
                                          OpenFile.open(entity.path);
                                          if (FileManager.isDirectory(entity)) {
                                            // open the folder
                                            controller.openDirectory(entity);

                                            // delete a folder
                                            // await entity.delete(recursive: true);

                                            // rename a folder
                                            // await entity.rename("newPath");

                                            // Check weather folder exists
                                            // entity.exists();

                                            // get date of file
                                            // DateTime date = (await entity.stat()).modified;
                                          } else {
                                            // delete a file
                                            // await entity.delete();

                                            // rename a file
                                            // await entity.rename("newPath");

                                            // Check weather file exists
                                            // entity.exists();

                                            // get date of file
                                            // DateTime date = (await entity.stat()).modified;

                                            // get the size of the file
                                            // int size = (await entity.stat()).size;
                                          }
                                        },
                                      ),
                                      const Divider(
                                        height: 2,
                                        color: Colors.black87,
                                        indent: 5,
                                        endIndent: 5,
                                        thickness: 2,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },);}),
                  ),
                  SizedBox(
                    height: size.height*0.03,
                  )
                ],
              ),
            ),
          ],
        )
        ,
      ),
    );
  }
  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return AutoSizeText(
              FileManager.formatBytes(size),
              style: GoogleFonts.exo(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500

              ),
            );
          }
          return AutoSizeText(
            "${snapshot.data!.modified}".substring(0, 10),
            style: GoogleFonts.exo(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500

            ),
          );
        } else {
          return AutoSizeText("",style: GoogleFonts.exo(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500

          ),);
        }
      },
    );
  }
  checkPermission() async {
    var permission = await checkALLPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
        print("Permission is : ${isPermission}");
      });
    }
  }

}