

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../component/function.dart';
import '../../component/shared_prefernces.dart';
import '../../component/theme.dart';
import '../../component/widget.dart';
import '../authentication/login.dart';
import 'home_screen.dart';


class DetePersonScreen extends StatefulWidget {
  const DetePersonScreen({Key? key}) : super(key: key);

  @override
  State<DetePersonScreen> createState() => _DetePersonScreenState();
}

class _DetePersonScreenState extends State<DetePersonScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("الصفحة الرئيسية", style: headingStyle(color: Colors.white, fontSize: 22,)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("تكاتك فاو قبلى", style: headingStyle(color: Colors.deepPurple, fontSize: 22,)),
                        const SizedBox(height: 5,),
                        const Divider(height: 10,color: Colors.orange,),
                        const SizedBox(height: 5,),
                        Lottie.asset('assets/tok.json',fit: BoxFit.fill,height: 200,),
                        const SizedBox(height: 5,),
                        buildMaterialButton(
                            function: ()async
                            {
                              SharedClass.setBool(key: "owner", b: true);
                              navigatorTo(context: context, screen: const LoginScreen());
                              //addOwner(context: context,owner: true);

                            },
                            text: "تسجيل دخول كصاحب توكتوك", color: Colors.indigo
                        ),
                      ],
                    ),
                    //
                    const SizedBox(height: 5,),
                    const Divider(height: 10,color: Colors.orange,),
                    const SizedBox(height: 5,),
                    Column(
                      children: [
                        Lottie.asset('assets/calling.json',fit: BoxFit.cover,height: 200),
                        const SizedBox(height: 5,),
                        buildElevatedButton(
                          text: "أطلب توكتوك",
                          color: Colors.indigo,
                          icon: Icons.phone,
                          function: () async {
                            SharedClass.setBool(key: "owner", b: false);
                            navigatorToEnd(
                                context: context, screen: const HomeScreen());
                            //addOwner(context: context,owner: false);
                            //getOwner(id: FirebaseAuth.instance.currentUser!.uid);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
