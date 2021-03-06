import 'package:fastpnt/Screens/Home1.dart';
import 'package:fastpnt/Screens/MedcinFormulaire.dart';
import 'package:fastpnt/Screens/doctorsList.dart';
import 'package:fastpnt/Screens/login.dart';
import 'package:fastpnt/Screens/signIn.dart';
import 'package:fastpnt/Screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastpnt/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'Screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(MyApp());
}
String sp;
CollectionReference medcin = FirebaseFirestore.instance.collection("Medcin");
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: SignIn());
  }
}
