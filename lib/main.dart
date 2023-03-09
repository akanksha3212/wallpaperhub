import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:wallpaper/home.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:page_transition/page_transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize witho Admob.requestTrackingAuthorization();ut device test ids.
  Admob.requestTrackingAuthorization();
  Admob.initialize();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'Wallpaper Bazaar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: Colors.white,
    ),
    home: Home(),
    );}
  }




