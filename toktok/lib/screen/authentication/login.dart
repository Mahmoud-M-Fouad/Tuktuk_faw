
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:toktok/screen/authentication/register.dart';

import '../../../component/function.dart';
import '../../../component/shared_prefernces.dart';
import '../../../component/theme.dart';
import '../../../component/widget.dart';
import '../app/home_screen.dart';
import 'forget_pass.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var formKeyForget = GlobalKey<FormState>();
  bool isPassword = true;
  bool _value = false;
  late String myEmail;
  late String myPassword;
  late UserCredential userCredential;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController userController = TextEditingController();

  signIn() async {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myEmail, password: myPassword);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showAweSomeDialogYes(
            context: context,
            body: "هذا الأميل غير مسجل من قبل",
            colorBorder: Colors.red,
            dialogType: DialogType.error,
            funOk: () {},
          );
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showAweSomeDialogYes(
            context: context,
            body: "كلمة السر خاطئة",
            colorBorder: Colors.red,
            dialogType: DialogType.error,
            funOk: () {},
          );
          print('Wrong password provided for that user.');
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return SingleChildScrollView(
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
                              Text("تسجيل دخول",
                                  style: headingStyle(
                                      color: Colors.indigo, fontSize: 22)),
                              buildImage(
                                  radius: 50,
                                  w: 100,
                                  h: 100,
                                  imagePath: 'images/login.png'),
                              Form(
                                key: formKeyForget,
                                child: buildTextFormField(
                                  controller: userController,
                                  text: "البريد الألكترونى",
                                  textInputType: TextInputType.emailAddress,
                                  iconPre: Icons.mail,
                                  validate: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length > 50 ||
                                        !value
                                            .toString()
                                            .contains('@gmail.com')) {
                                      return "أدخل بريد الكترونى مثل example@gmail.com ";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    myEmail = value;
                                  },
                                  obscureText: false,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildTextFormField(
                                controller: passController,
                                text: "كلمة المرور",
                                textInputType: TextInputType.emailAddress,
                                iconPre: Icons.key_outlined,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "أدخل كلمة المرور ";
                                  }
                                  if (value.length < 4) {
                                    return "كلمة المرور ضعيفة  ";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  myPassword = value;
                                },
                                obscureText: isPassword,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              buildCheckBox(
                                  text: "عرض كلمة المرور",
                                  value: _value,
                                  onChanged: (val) {
                                    setState(() {
                                      _value = val;
                                      isPassword = !isPassword;
                                    });
                                  }),
                              const SizedBox(
                                height: 5,
                              ),
                              buildMaterialButton(
                                  function: () async {
                                    var user = await signIn();
                                    if (user != null) {
                                      showAweSomeDialogYes(
                                        context: context,
                                        body: "تم تسجيل الدخول بنجاح",
                                        colorBorder: Colors.green,
                                        dialogType: DialogType.success,
                                        funOk: () {
                                          SharedClass.setBool(
                                              key: "owner", b: true);
                                          navigatorToEnd(
                                              context: context,
                                              screen: const HomeScreen());
                                        },
                                      );
                                    }
                                  },
                                  text: "تسجيل دخول",
                                  color: Colors.indigo),
                              //const SizedBox(height: 25,),
                              const SizedBox(
                                height: 25,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildText(
                                      text: "هل نسيت كلمة السر؟ ",
                                      color: Colors.indigo,
                                      fontSize: 16),
                                  TextButton(
                                    onPressed: () async {
                                      final FormState? form =
                                          formKeyForget.currentState;
                                      if (form!.validate()) {
                                        form.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: myEmail,
                                            password: "ForgetPassScreen",
                                          );
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            showAweSomeDialogYes(
                                              context: context,
                                              body:
                                                  "هذا الأميل غير مسجل من قبل",
                                              colorBorder: Colors.red,
                                              dialogType: DialogType.error,
                                              funOk: () {},
                                            );
                                          } else if (e.code ==
                                              'wrong-password') {
                                            SharedClass.setString(
                                                key: "mail", str: myEmail);
                                            navigatorTo(
                                                context: context,
                                                screen:
                                                    const ForgetPassScreen());
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      }
                                    },
                                    child: buildText(
                                        text: "نست كلمة السر",
                                        color: Colors.green,
                                        fontSize: 18),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildText(
                                      text: "هل تريد أنشاء حساب جديد؟ ",
                                      color: Colors.indigo,
                                      fontSize: 16),
                                  TextButton(
                                    onPressed: () {
                                      navigatorTo(
                                          context: context,
                                          screen: const RegisterScreen());
                                    },
                                    child: buildText(
                                        text: "إنشاء حساب جديد",
                                        color: Colors.green,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    title: Text('أتصل بالأنترنت من فضلك',
                      style: headingStyle(color: Colors.white, fontSize: 18),
                    ),
                    centerTitle: true,
                  ),
                  body: SafeArea(
                      child:Center(
                        child: Image.asset('images/no_internet.png',)
                      )
                  ),
                ),
              );
            }
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          ),
        )
    );
  }
}
