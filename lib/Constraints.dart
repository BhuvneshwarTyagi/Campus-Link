import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Color Regbg=const Color.fromRGBO(12, 12, 12, 1);
Color Regcon= const Color.fromRGBO(40, 40, 40, 1);
Color RegText= const Color.fromRGBO(179, 179, 179, 1);
double heading = 25;
double range= 8;
String university_filter="nul";
String college_filter="nul";
String course_filter="nul";
String branch_filter="nul";
String year_filter="nul";
String section_filter="nul";
String subject_filter = 'nul';
int all=0;
Position tecloc= Position.fromMap({'latitude': 0.0, 'longitude': 0.0});
Map<String,dynamic> usermodel={};
