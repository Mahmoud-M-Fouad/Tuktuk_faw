import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../component/function.dart';
import '../../component/theme.dart';
import '../../component/widget.dart';
import '../../firebase/firebase.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var formKey = GlobalKey<FormState>();
  late String myName;

  late String myName2;

  late String myPassword;

  late String myPassword1;

  late String myPassword2;

  bool isPassword = true;
  bool _value = false;
  var ref = FirebaseFirestore.instance
      .collection(
        "user",
      )
      .doc(getUserID())
      .get();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController passController1 = TextEditingController();
    TextEditingController passController2 = TextEditingController();
    updateUserName() async {
      try {
        updateOwnerName(context: context, name: myName2);
      } catch (e) {
        print(e);
      }
      setState(() {});
    }

    return Directionality(
        textDirection: TextDirection.rtl,
        child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    "الأعدادات",
                    style: headingStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                body: FutureBuilder(
                  future: ref,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      myName = snapshot.data?['name'];
                      nameController.text = snapshot.data?['name'];
                      myPassword = snapshot.data?['pass'];
                      passController.text = snapshot.data?['pass'];
                      return Form(
                        key: formKey,
                        child: Column(
                          children: [
                            buildTextFormFieldToReadOly(
                                text: "أسم المستخدم",
                                controller: nameController,
                                iconPre: Icons.person,
                                obscureText: false),
                            buildTextFormFieldToReadOly(
                                text: "كلمة المرور",
                                controller: passController,
                                iconPre: Icons.key,
                                obscureText: isPassword),
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
                              height: 15,
                            ),
                            //---------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildMaterialButton(
                                    function: () {
                                      setState(() {
                                        showAweSomeDialogBody(
                                            context: context,
                                            dialogType: DialogType.info,
                                            body: buildRowToEdit(
                                              nameController: nameController,
                                              passController1: passController1,
                                              passController2: passController2,
                                              name: true,
                                            ),
                                            colorBorder: Colors.indigo,
                                            funOk: () {
                                              if (nameController
                                                  .text.isNotEmpty) {
                                                updateUserName();
                                              } else {
                                                showToast(
                                                  context: context,
                                                  msg:
                                                      "خطأ ، تأكد من صح البيانات",
                                                  color: Colors.red,
                                                );
                                              }
                                            });
                                      });
                                    },
                                    text: "تغيير أسم المستخدم",
                                    color: Colors.indigo),
                                buildMaterialButton(
                                    function: () {
                                      setState(() {
                                        showAweSomeDialogBody(
                                            context: context,
                                            dialogType: DialogType.info,
                                            body: buildRowToEdit(
                                              nameController: nameController,
                                              passController1: passController1,
                                              passController2: passController2,
                                              name: false,
                                            ),
                                            colorBorder: Colors.indigo,
                                            funOk: () {
                                              setState(() {
                                                if (passController1.text == passController2.text &&
                                                    passController2.text.isNotEmpty && passController1.text.isNotEmpty&&
                                                    passController2.text.length > 5) {
                                                  changePassword(
                                                      context: context,
                                                      pass: myPassword2);
                                                } else {
                                                  if (passController1.text == passController2.text &&
                                                      passController1.text.length < 6) {
                                                    showToast(
                                                      context: context,
                                                      msg: "كلمة السر ضعيفة",
                                                      color: Colors.red,
                                                    );
                                                  } else {
                                                    showToast(
                                                      context: context,
                                                      msg: "خطأ ، تأكد من صح البيانات",
                                                      color: Colors.red,
                                                    );
                                                  }
                                                }
                                              });
                                            }

                                            );
                                      });
                                    },
                                    text: "تغيير كلمة السر",
                                    color: Colors.indigo),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text("يوجد خطأ");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text("تحميل ....")
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  title: Text(
                    'أتصل بالأنترنت من فضلك',
                    style: headingStyle(color: Colors.white, fontSize: 18),
                  ),
                  centerTitle: true,
                ),
                body: SafeArea(
                    child: Center(
                        child: Image.asset(
                  'images/no_internet.png',
                ))),
              );
            }
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          ),
        ));
  }

  buildRowToEdit({
    required TextEditingController nameController,
    required TextEditingController passController1,
    required TextEditingController passController2,
    required bool name,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          name
              ? buildTextFormField(
                  controller: nameController,
                  iconPre: Icons.person,
                  text: "أسم المستخدم",
                  obscureText: false,
                  onChanged: (val) {
                    myName2 = val;
                  },
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return "أدخل الأسم من فضلك";
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                )
              :
              //---------------
              Column(
                  children: [
                    buildTextFormField(
                      controller: passController1,
                      text: "كلمة المرور الجديدة",
                      textInputType: TextInputType.emailAddress,
                      iconPre: Icons.key,
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
                        myPassword1 = value;
                      },
                      obscureText: false,
                    ),
                    buildTextFormField(
                      controller: passController2,
                      text: "تأكيد كلمة المرور الجديدة",
                      textInputType: TextInputType.emailAddress,
                      iconPre: Icons.key,
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
                        myPassword2 = value;
                        //print(myPassword2);
                      },
                      obscureText: false,
                    ),
                  ],
                ),
          //---------------------------
        ],
      ),
    );
  }
}
