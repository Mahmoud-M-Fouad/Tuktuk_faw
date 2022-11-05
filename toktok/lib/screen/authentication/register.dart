

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../component/function.dart';
import '../../../component/theme.dart';
import '../../../component/widget.dart';


import '../../firebase/firebase.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey <FormState>();
  bool isPassword = true;
  late String myUsername;
  late String myPassword;
  late String myPassword2;
  late String myEmail;
  bool _value = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passController2 = TextEditingController();
  TextEditingController userController = TextEditingController();
  late UserCredential credential;
  signUp()async {
    final FormState? form = formKey.currentState;
    if (form!.validate())
    {
      form.save();
      if(myPassword!=myPassword2)
        {
          showAweSomeDialogYes(
            context: context,
            body:"كلمة السر غير متطابقة",
            colorBorder: Colors.red,
            dialogType: DialogType.error,
            funOk: (){},
          );
        }
      else
        {
          try {
            credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: myEmail,
              password: myPassword,
            );

            //navigatorTo(context: context, screen: const VerificationEmailScreen());
            return credential;
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              //print('The password provided is too weak.');
              showAweSomeDialogYes(
                context: context,
                body:"كلمة السر ضعيفة",
                colorBorder: Colors.red,
                dialogType: DialogType.error,
                funOk: (){},
              );

            } else if (e.code == 'email-already-in-use') {
              showAweSomeDialogYes(
                context: context,
                body:"هذا الأميل مسجل من قبل",
                colorBorder: Colors.red,
                dialogType: DialogType.error,
                funOk: (){},
              );
              /*if(userCredential.user!.emailVerified==false)
            {
              User? user = FirebaseAuth.instance.currentUser;
              await user!.sendEmailVerification();
            }
          print('The account already exists for that email.');

           */
            }



          } catch (e) {
            print(e);
          }
        }

    }

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("إنشاء حساب جديد" , style: headingStyle(color: Colors.indigo, fontSize: 22)),
                        buildImage(
                            radius: 50,
                            w: 100,
                            h: 100,
                            imagePath:'images/login.png'
                        ),
                        buildTextFormField(
                          controller: userController,
                          text: "أدخل الأسم",
                          textInputType: TextInputType.emailAddress,
                          iconPre: Icons.person,
                          validate: (value)
                          {
                            if (value == null || value.isEmpty ) {
                              return "اسم االمستخدم غير صالح ";
                            }
                            if (value.length >22) {
                              return "الأسم كبير للغاية";
                            }
                            return null;
                          },
                          onChanged: (value)
                          {
                            myUsername = value;
                          },
                          obscureText: false,
                        ),
                        const SizedBox(height: 5,),
                        buildTextFormField(
                          controller: emailController,
                          text: "البريد الألكترونى",
                          textInputType: TextInputType.emailAddress,
                          iconPre: Icons.mail_outline,
                          validate: (value)
                          {
                            if (value == null || value.isEmpty  ||!value.toString().contains('@gmail.com')
                                ||value.toString().startsWith('@')||value.toString().endsWith('@')
                            ) {
                              return "أدخل بريد الكترونى مثل example@gmail.com ";
                            }
                            return null;
                          },
                          onChanged: (value)
                          {
                            myEmail = value;
                          },
                          obscureText: false,
                        ),
                        const SizedBox(height: 10,),
                        buildTextFormField(
                          controller: passController,
                          text: "كلمة المرور",
                          textInputType: TextInputType.text,
                          iconPre: Icons.key_outlined,
                          validate: (value)
                          {
                            if (value == null || value.isEmpty) {
                              return "أدخل كلمة المرور ";
                            }
                            if (value.length < 4) {
                              return "كلمة المرور ضعيفة  ";
                            }
                            return null;
                          },
                          onChanged: (value)
                          {
                            myPassword = value;
                          },
                          obscureText: isPassword,
                        ),
                        buildTextFormField(
                          controller: passController2,
                          text: "تأكيد كلمة المرور",
                          textInputType: TextInputType.text,
                          iconPre: Icons.key_outlined,
                          validate: (value)
                          {
                            if (value == null || value.isEmpty) {
                              return "أدخل تأكيد كلمة المرور ";
                            }
                            if (value.length < 4) {
                              return "كلمة المرور ضعيفة  ";
                            }
                            return null;
                          },
                          onChanged: (value)
                          {
                            myPassword2 = value;
                          },
                          obscureText: isPassword,
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
                              var user =  await signUp();
                              if(user !=null)
                                {
                                  addOwner(
                                      context: context,
                                      mail: FirebaseAuth.instance.currentUser!.email.toString(),
                                      name: myUsername,
                                      pass: myPassword
                                  );
                                  /*
                                  if(FirebaseAuth.instance.currentUser!.emailVerified)
                                    {

                                      print('mail verified');
                                    }
                                  else
                                    {
                                      FirebaseAuth.instance.currentUser!.sendEmailVerification();
                                    }

                                   */
                                }
                            },
                            text: "إنشاء الحساب",
                          color: Colors.indigo
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}


