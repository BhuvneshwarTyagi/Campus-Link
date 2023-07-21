import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Database/database.dart';
class SelectedStudents extends StatefulWidget {
  const SelectedStudents({Key? key}) : super(key: key);

  @override
  State<SelectedStudents> createState() => _SelectedStudentsState();
}

class _SelectedStudentsState extends State<SelectedStudents> {
  bool button_enabled=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Students").where("Subject", isEqualTo: subject).where("Active", isEqualTo: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ?
          ListView.builder(

            itemCount: snapshot.data?.size,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,right: MediaQuery.of(context).size.width*0.03),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(12, 12, 12, 1),
                    border: Border.all(color: Colors.black,width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 6,
                        blurStyle: BlurStyle.outer,
                        color: Colors.amber,
                        offset: Offset(0, 0),
                      )
                    ]
                ),
                margin: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        Text(snapshot.data.docs[index]["Name"],style: const TextStyle(color: Colors.white)),
                        Text(snapshot.data.docs[index]["Rollnumber"],style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.03,
                        ),
                        IconButton(
                            onPressed: () async{
                              await FirebaseFirestore.instance.collection("Students").doc(snapshot.data.docs[index]["Email"]).update(
                                {"Active" : false
                                },
                              );
                            },
                            icon: const Icon(Icons.clear_outlined,color: Colors.red,))
                      ],
                    )
                  ],
                ),
              );
            },
          )
              :
              const Center(
                child: CircularProgressIndicator(color: Colors.yellow,),
              );
        }
        ,),
    );
  }
}
