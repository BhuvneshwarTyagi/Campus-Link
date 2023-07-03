import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:searchfield/searchfield.dart';
import '../Database/database.dart';

class basicDetails extends StatefulWidget {
  const basicDetails({Key? key}) : super(key: key);

  @override
  State<basicDetails> createState() => _basicDetailsState();
}

class _basicDetailsState extends State<basicDetails> {
  late TextEditingController universityController = TextEditingController();
  late TextEditingController clgController = TextEditingController();
  List<String> university = [];
  List<String> clg = ['Please Select University'];
  bool showDropdown = false;
  final FocusNode clgf = FocusNode();
  final FocusNode univf = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    fetchUniversity();
    super.initState();
  }

  final textStyle = GoogleFonts.alegreya(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Colors.amber,
    shadows: <Shadow>[
      const Shadow(
        offset: Offset(1, 1),
        color: Colors.black,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        //transform: GradientRotation(2),
        colors: [
          Color.fromRGBO(3, 9, 46, 1),
          Color.fromRGBO(3, 74, 140, 1)

          //Color.fromRGBO(148, 18, 194, 1),
          //Color.fromRGBO(40, 19, 174, 1),
          //Color.fromRGBO(140, 39, 200, 1),
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'Fill Your Details',
                    textStyle: GoogleFonts.openSans(
                        color: const Color.fromRGBO(213, 97, 132, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ],
                repeatForever: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: univf,
                  controller: universityController,
                  searchStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "University",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchCollege(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(clgf);
                  },
                  enabled: true,
                  hint: "University",
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions:
                      university.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ),
              //List<SearchFieldListItem<dynamic>>
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  suggestionItemDecoration: SuggestionDecoration(),
                  key: const Key('searchfield'),
                  focusNode: clgf,
                  controller: clgController,
                  searchStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionStyle: GoogleFonts.openSans(
                      color: const Color.fromRGBO(213, 97, 132, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                  suggestionsDecoration: SuggestionDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      padding: const EdgeInsets.all(10),
                      border: Border.all(width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  searchInputDecoration: InputDecoration(
                      hintText: "Colleges",
                      hintStyle: GoogleFonts.openSans(
                          color: Colors.white38,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusColor: const Color.fromRGBO(213, 97, 132, 1),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Color.fromRGBO(213, 97, 132, 1),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onSuggestionTap: (value) {
                    setState(() {
                      fetchCollege(value.searchKey);
                    });
                    FocusScope.of(context).requestFocus(clgf);
                  },
                  enabled: true,
                  itemHeight: 50,
                  maxSuggestionsInViewPort: 3,
                  suggestions: clg.map((e) => SearchFieldListItem(e)).toList(),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("University")
                      .doc("University")
                      .update({
                    "University": FieldValue.arrayUnion([
                      "Acharya N.G. Ranga Agricultural University",
                      "Acharya Nagarjuna  University",
                      "Adikavi Nannaya University",
                      "Andhra Kesari University",
                      "Andhra University",
                      "Bharatiya Engineering Science and Technology Innovation University",
                      "Acharya N.G. Ranga Agricultural University",
                      "Central University  of  Andhra  Pradesh",
                      "Central Tribal University of Andhra Pradesh",
                      "Centurion University of Technology and Management",
                      "Cluster   University",
                      "Damodaram Sanjivayya National Law University",
                      "Dr. Abdul Haq Urdu University",
                      "Dr. B.R. Ambedkar University",
                      "Dravidian University",
                      "Dr. Y.S.R Architecture and Fine Arts University",
                      "Dr. Y.S.R. Horticultural University",
                      "Dr. N.T.R. University of Health Sciences (Formerly  Andhra  Pradesh University of  Health Sciences)",
                      "Gandhi Institute of Technology and Management (GITAM)",
                      "Jawaharlal Nehru Technological University",
                      "Jawaharlal Nehru Technological University",
                      "Jawaharlal Nehru Technological University - Gurajada",
                      "Koneru Lakshmaiah Education Foundation",
                      "KREA University",
                      "Krishna University",
                      "Rajiv Gandhi University of Knowledge Technologies Andhra Pradesh",
                      "Rayalaseema University",
                      "Saveetha Amaravati University",
                      "Sri Krishnadevaraya University",
                      "Sri Padmavati Mahila Vishwavidyalayam",
                      "Sri Sathya Sai Institute of Higher Learning",
                      "Sri Venkateswara University",
                      "Sri Venkateswara Vedic University",
                      "Sri Venkateswara Veterinary University",
                      "Sri Venkateswara Institute of Medical Sciences",
                      "SRM University",
                      "The National Sanskrit University",
                      "Vignan's Foundation for Science",
                      "Vikrama Simhapuri University",
                      "VIT-AP University",
                      "Yogi Vemana University",
                      "Apex Professional University",
                      "Arunachal University of Studies",
                      "Arunachal Pradesh University",
                      "Arunodaya University",
                      "Himalayan University",
                      "North East Frontier Technical University",
                      "North Eastern Regional Institute of Science & Technology",
                      "Rajiv Gandhi University",
                      "The Global University",
                      "The Indira Gandhi Technological & Medical Sciences University",
                      "Venkateshwara Open University",
                      "Assam Agricultural University",
                      "Assam Don Bosco University",
                      "Assam Down Town University",
                      "Assam University",
                      "Assam Rajiv Gandhi University of Co-operative Management",
                      "Assam Science & Technology University",
                      "Assam Women’s University",
                      "Birangana Sati Sadhani Rajyik Vishwavidyalaya",
                      "Bodoland University",
                      "Bhattadev University",
                      "Cotton Univeristy",
                      "Central Institute of Technology (CIT)",
                      "Dibrugarh University",
                      "Gauhati  University",
                      "Girijananda Chowdhury University Assam",
                      "Krishna Kanta Handiqui State Open University (Formerly Krishna Kanta Handique State Open University)",
                      "Kumar Bhaskar Varma Sanskrit & Ancient Studies University",
                      "Krishnaguru Adhyatmik Visvavidyalaya",
                      "Madhabdev University",
                      "Mahapurusha Srimanta Sankaradeva Viswavidyalaya",
                      "Majuli University of Culture",
                      "National Law University and Judicial Academy",
                      "Pragjyotishpur University",
                      "Rabindranath Tagore University",
                      "Srimanta Sankaradeva University of Health Sciences",
                      "Sri Sri Anirudhadeva Sports University",
                      "Tezpur University",
                      "The Assam Kaziranga University",
                      "The Assam Royal Global University",
                      "Amity University",
                      "Aryabhatta knowledge University",
                      "Babasaheb Bhimrao Ambedkar Bihar University",
                      "Bhupendra Narayan Mandal University",
                      "Bihar Agricultural University",
                      "Bihar Animal Sciences University",
                      "Central University  of  South  Bihar",
                      "Chanakya National Law University",
                      "Dr. C.V. Raman University",
                      "Gopal Narayan Singh University",
                      "Jai Prakash Vishwavidyalaya",
                      "Kameshwara Singh Darbhanga Sanskrit Vishwavidyalaya",
                      "K.K. University",
                      "Lalit Narayan Mithila University",
                      "Magadh University",
                      "Mahatma Gandhi Central University",
                      "Mata Gujri University",
                      "Maulana Mazharul Haque Arabic & Persian University",
                      "Munger University",
                      "Nalanda University",
                      "Nalanda Open University",
                      "Nava Nalanda Mahavihara",
                      "Patna University",
                      "Patliputra University",
                      "Purnea University",
                      "Dr. Rajendra Prasad Central Agricultural University",
                      "Sandip University",
                      "T.M. University",
                      "Veer Kunwar Singh University",
                      "Al-Karim University",
                      "AAFT University of Media and Arts",
                      "Amity University",
                      "Ayush and Health Sciences University of Chhattisgarh",
                      "Bharti Vishwavidyalaya",
                      "Atal Bihari Vajpayee Vishwavidyalaya (Formerly Bilaspur Vishwavidyalaya)",
                      "Chhattisgarh Kamdhenu Vishwavidyalaya",
                      "Chhattisgarh Swami Vivekanand Technical University",
                      "Dev Sanskriti Vishwavidyalaya",
                      "Dr. C.V. Raman University",
                      "Durg Vishwavidyalaya",
                      "Guru Ghasidas Vishwavidyalaya",
                      "Hidayatullah National Law University",
                      "ICFAI University",
                      "International Institute of Information Technology",
                      "ISBM University",
                      "Indira Gandhi Krishi Vishwavidyalaya",
                      "Indira Kala Sangeet Vishwavidyalaya",
                      "ITM University",
                      "K.K. Modi University",
                      "Kushabhau Thakre Patrakarita Avam Jansanchar Vishwavidyalaya",
                      "Kalinga University",
                      "Maharishi University of Management and Technology",
                      "Mahatma Gandhi Udyanikee Evam Vanikee Vishwavidyalaya",
                      "MATS University",
                      "O.P. Jindal University",
                      "Pt.mRavishankar Shukla University",
                      "Pandit Sundar Lal Sharma (Open) University Chhatisgarh",
                      "Sant Gahira Guru Vishwavidyalaya (formerly Sarguja University)",
                      "Shaheed Mahendra Karma Vishwavidyalaya",
                      "Shaheed Nandkumar Patel Vishwavidyalaya",
                      "Shri Rawatpura Sarkar University",
                      "Shri Shankaracharaya Professional University",
                      "Goa University",
                      "India International University of Legal Education and Research",
                      "Adani University",
                      "Ahmedabad University",
                      "Anand Agricultural Univerisity",
                      "Anant National University",
                      "Atmiya University",
                      "AURO University of Hospitality and Management",
                      "Bhagwan Mahavir University",
                      "Bhaikaka University",
                      "Bhakta Kavi Narsinh Mehta University",
                      "Birsa Munda Tribal University",
                      "Central University of Gujarat",
                      "Gati Shakti Vishwavidyalaya",
                      "Centre for Environmental Planning and Technology University",
                      "Charotar University of Science & Technology",
                      "Children’s University",
                      "C.U. Shah University",
                      "Darshan University",
                      "Dharmsinh Desai University",
                      "Dhirubhai Ambani Institute of Information and Communication Technology",
                      "Dr. Babasaheb Ambedkar Open University",
                      "Drs. Kiran & Pallavi Patel Global University (KPGU)",
                      "Dr. Subhash University",
                      "Ganpat University",
                      "G.L.S. University",
                      "Gandhinagar University",
                      "Gokul Global University",
                      "GSFC University",
                      "Gujarat Ayurveda University",
                      "Gujarat Biotechnology  University",
                      "Gujarat Maritime University",
                      "Gujarat National Law University",
                      "Gujarat Natural Farming and Organic Agricultural University (Formerly Gujarat Organic Agriculture University)",
                      "Gujarat Technlogical   University",
                      "Gujarat University",
                      "Gujarat University of Transplantation Sciences",
                      "Gujarat Vidyapith",
                      "Hemchandracharya North Gujarat University",
                      "Indian Institute of Public Health",
                      "Indian Institute of Teacher Education",
                      "Indrashil University",
                      "Indus University",
                      "Institute of Infrastructure Technology Research and Management",
                      "Institute of Advanced Research",
                      "ITM (SLS) Baroda University",
                      "ITM-Vocational University",
                      "J.G. University",
                      "Junagarh Agricultural University",
                      "Kadi Sarva Vishwavidyalaya",
                      "Kamdhenu University",
                      "Karnavati University",
                      "Krantiguru Shyamji Krishna Verma Kachchh University",
                      "Kaushalya the Skill University",
                      "Lakulish Yoga University",
                      "Lok Jagruti Kendra University",
                      "Lokbharati University for Rural Innovation",
                      "Maganbhai Adenwala Mahagujarat University",
                      "Maharaja Krishnakumarsinji Bhavnagar University"
                    ])
                  });
                  // if(_universitycontroller.text.trim().toString().isNotEmpty){
                  //
                  //   List<dynamic> unis=[_universitycontroller.text.trim()];
                  //   await FirebaseFirestore.instance.collection("University").doc("University").update(
                  //       {"University": FieldValue.arrayUnion(unis)
                  //       });
                  //
                  //
                  //   List<dynamic> clgs=["Select Your College", _collegecontroller.text.trim()];
                  //   if(_universitycontroller.text.trim().toString().isNotEmpty){
                  //     await FirebaseFirestore.instance.collection("Colleges").doc(_universitycontroller.text.trim().toString()).set(
                  //         {"Colleges": clgs
                  //         });
                  //
                  //   }
                  //   fetchCollege();
                  //   fetchUniversity();
                  // }
                  // else{
                  //
                  //   if(_collegecontroller.text.trim().toString().isNotEmpty){
                  //     try{
                  //       List<dynamic> clgs=[_collegecontroller.text.trim()];
                  //       await FirebaseFirestore.instance.collection("Colleges").doc(uni).update(
                  //           {"Colleges": FieldValue.arrayUnion(clgs)
                  //           });
                  //     }on FirebaseException catch(e){
                  //       List<dynamic> clgs=["Select Your College",_collegecontroller.text.trim()];
                  //       await FirebaseFirestore.instance.collection("Colleges").doc(uni).set(
                  //           {"Colleges": clgs
                  //           });
                  //     }
                  //   }
                  //   fetchCollege();
                  // }
                },
                child: Text(
                  "Submit",
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w800, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  fetchUniversity() async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('University')
          .doc("University")
          .get();
      university.clear();
      for (var element in feed['University']) {
        setState(() {
          university.add(element.toString());
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  fetchCollege(String univ) async {
    try {
      final feed = await FirebaseFirestore.instance
          .collection('Colleges')
          .doc(univ)
          .get();
      clg.clear();
      for (var element in feed.data()?['Colleges']) {
        setState(() {
          clg.add(element.toString());
        });
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print("\n\n\n\n $e \n\n\n\n");
    }
  }

  /*
  decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(

                          ),
                          enabledBorder: const OutlineInputBorder(

                          ),
                          labelText: "Select University",
                          suffixIcon: DropdownButtonFormField(

                              isExpanded: false,
                              items: university
                                  .map<DropdownMenuItem<String>>((dynamic value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  uni = value;
                                });
                              }
                          )
                      ),



  Widget _universityaddtile() {
    return ListTile(
      title: const Center(child: Text('Add University',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),)),
      onTap: () {
        final controller = TextEditingController();
        final field = TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'University cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    int index=_universitycontroller.indexOf(controller);
                    _universitycontroller.removeAt(index);
                    _universityFields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.black,
              ),
              labelText: "University ${_universitycontroller.length + 1}",
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700)),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        );
        setState(() {
          _universitycontroller.add(controller);
          _universityFields.add(field);
        });
      },
    );
  }

  Widget _universitylistview() {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(
      controller: listScrollController,
      itemCount: _universityFields.length,
      itemBuilder: (context, index) {
        print("$index");
        return Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: Colors.black,width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      color: Colors.black26,
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                _universityFields[index],
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  height: 280,
                  child: Expanded( child: _courselistview(index),),
                ),
                _courseaddtile(index)

              ],
            )
        );
      },
    );
  }

  Widget _courseaddtile(int index) {
    return ListTile(
      title: const Center(child: Text('Add Course',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),)),
      onTap: () {
        final controller = TextEditingController();
        final field = TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Course cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    int index=_universitycontroller.indexOf(controller);
                    _universitycontroller.removeAt(index);
                    _universityFields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
                color: Colors.black,
              ),
              labelText: "Course ${_coursecontroller.length + 1}",
              labelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700)),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        );
        setState(() {
          _coursecontroller.add([]);
          _courseFields.add([]);
          _coursecontroller[index].add(controller);
          _courseFields[index].add(field);
        });
        print("${_coursecontroller.length}");
      },
    );
  }

  Widget _courselistview(int inde) {
    ScrollController listScrollController = ScrollController();
    if(listScrollController.hasClients){
      setState(() {
        final position = listScrollController.position.maxScrollExtent;
        listScrollController.jumpTo(position);
      });
    }
    return ListView.builder(
      controller: listScrollController,
      itemCount: _courseFields.length,
      itemBuilder: (context, index) {
        return Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: Colors.black,width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      color: Colors.black26,
                      offset: Offset(1, 1)
                  )
                ]
            ),
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                _courseFields[inde][index],
                Container(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  height: 280,
                  child: const Expanded( child: Text("Branch"),),
                ),
                //add branch tile

              ],
            )
        );
      },
    );
  }

*/
  Future upload(String naam, String section) async {
    try {
      Position x = await database().getloc();
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        "Name": naam,
        'Section': section,
        'Location': GeoPoint(x.latitude, x.longitude)
      });
    } on FirebaseAuthException catch (e) {
      InAppNotifications.instance
        ..titleFontSize = 14.0
        ..descriptionFontSize = 14.0
        ..textColor = Colors.black
        ..backgroundColor = const Color.fromRGBO(150, 150, 150, 1)
        ..shadow = true
        ..animationStyle = InAppNotificationsAnimationStyle.scale;
      InAppNotifications.show(
          title: 'Failed',
          duration: const Duration(seconds: 2),
          description: e.toString().split(']')[1].trim(),
          leading: const Icon(
            Icons.error_outline_outlined,
            color: Colors.red,
            size: 55,
          ));
    }
  }
}
