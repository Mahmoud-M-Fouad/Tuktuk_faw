

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toktok/screen/app/detec_person.dart';
import 'package:toktok/screen/app/home_screen.dart';

import 'component/shared_prefernces.dart';
import 'firebase/firebase.dart';

late bool isLogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var userLogin = FirebaseAuth.instance.currentUser;
  isLogin = getUser()==null?false:true;
  await SharedClass.inti();
  print(isLogin);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'توكتوك فاو',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: isLogin?const HomeScreen():const DetePersonScreen(),
    );
  }
}

