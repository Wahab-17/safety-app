import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:womensafteyhackfair/Dashboard/Dashboard.dart';
import 'package:womensafteyhackfair/Dashboard/Splsah/Splash.dart';
import 'package:womensafteyhackfair/background_services.dart';
import 'package:workmanager/workmanager.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize background work only on mobile platforms
  final bool isMobile = !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  if (isMobile) {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }
  
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amaan',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: isAppOpeningForFirstTime(),
          builder: (context, AsyncSnapshot<bool> snap) {
            if (snap.hasData) {
              if (snap.data == true) {
                return Dashboard();
              } else {
                return Splash();
              }
            } else {
              return Container(
                color: Colors.white,
              );
            }
          }),
    );
  }

  Future<bool> isAppOpeningForFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool("appOpenedBefore") ?? false;
    if (!result) {
      prefs.setBool("appOpenedBefore", true);
    }
    return result;
  }
}
