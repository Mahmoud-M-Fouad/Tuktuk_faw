
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../component/function.dart';
import '../../../component/shared_prefernces.dart';
import '../../../component/theme.dart';
import '../../component/widget.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  var formKey = GlobalKey <FormState>();
  late bool isPassword = true;
  late bool _value = false;
  String myAddressToGetPass= "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAddressToGetPass = SharedClass.getString(key: "mail");
    emailController = TextEditingController(text:myAddressToGetPass);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("user").where('mail',isEqualTo: myAddressToGetPass).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        passController.text = snapshot.data?.docs[0]['pass'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("إستعادة كلمة السر" , style: headingStyle(color: Colors.indigo, fontSize: 22)),
                            buildImage(
                                radius:100,
                                w: 100,
                                h: 100,
                                imagePath:'images/pass.png'
                            ),
                            //const Image(image: AssetImage('images/pass.png')),
                            buildTextFormFieldToReadOly(
                              controller: emailController,
                              text: "البريد الأكترونى",
                              iconPre: Icons.mail,
                              obscureText: false,
                            ),
                            const SizedBox(height: 10,),
                            buildTextFormFieldToReadOly(
                              controller:passController,
                              text: "كلمة المرور",
                              iconPre: Icons.key_outlined, obscureText: isPassword,
                            ),
                            const SizedBox(height: 5,),
                            buildCheckBox(
                                text: "عرض كلمة المرور",
                                value: _value,
                                onChanged: (val){
                                  setState(() {
                                    _value = val;
                                    isPassword = !isPassword;
                                  });
                                }
                            ),
                            const SizedBox(height: 5,),
                            buildMaterialButton(
                                function: ()async
                                {
                                  setState(() {
                                    buildCopy(textCopy:passController.text, context: context);
                                  });
                                },
                                text: "نسخ كلمة السر", color: Colors.indigo
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("يوجد خطأ");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return  Center(
                          child: Column(
                            children: const  [
                              CircularProgressIndicator(),
                              SizedBox(height: 20,),
                              Text("تحميل ....")
                            ],
                          ),
                        );
                      }
                      return Container();

                    }

                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
