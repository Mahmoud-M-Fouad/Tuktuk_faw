import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../component/theme.dart';
import '../../component/function.dart';
import '../../component/widget.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    late String myMessage;
    buildRowToMessage({
      required TextEditingController messageController,
    }) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            buildTextFormField(
              controller: messageController,
              iconPre: Icons.message,
              text: "أدخل الرسالة",
              obscureText: false,
              onChanged: (val) {
                myMessage = val;
              },
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return "أدخل الرسالة من فضلك";
                }
                return null;
              },
              textInputType: TextInputType.text,
            ),
            //---------------
          ],
        ),
      );
    }

    Uri toLaunch = Uri(scheme: 'https', host: 'github.com', path: 'Mahmoud-M-Fouad');
    String pasteValue='';
    TextEditingController messageController = TextEditingController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade400,
          elevation: 0,
          title: Text("Emad M El Samery",style: headingStyle(color: Colors.white,fontSize: 20),),
          centerTitle: true,
        ),
        backgroundColor: Colors.teal.shade300,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildImageProfile(
                    imagePath:'images/profile.png',
                    radius: 100,
                  ),
                  const SizedBox(height: 20,),
                  Text("Mobile Developer",style: headingStyle(color: Colors.white,fontSize: 18),),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: () {
                      makePhoneCall(phoneNumber: "01063378834");
                    },
                    onLongPress: ()
                    {
                      buildCopy(textCopy: "01063378834", context: context);
                    },
                    child: buildColumnShow(
                        icon: Icons.phone, list: "01063378834"),
                  ),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: () {
                      makeMail(mail: "hodaa.m.fouad@gmail.com");
                    },
                    onLongPress: ()
                    {
                      buildCopy(textCopy: "hodaa.m.fouad@gmail.com", context: context);
                    },
                    child: buildColumnShow(
                        icon: Icons.mail, list: "hodaa.m.fouad@gmail.com"),
                  ),
                  const SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          toLaunch = Uri(scheme: 'https', host: 'facebook.com', path: 'profile.php?id=100008683122059');
                          launchInBrowser(
                            url: toLaunch,//"https://github.com/Mahmoud-M-Fouad",
                            //https://www.facebook.com/profile.php?id=100008683122059
                          );
                        },
                        child:const ImageIcon(
                          AssetImage("images/face.png"),
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          toLaunch = Uri(scheme: 'https', host: 'github.com', path: 'Mahmoud-M-Fouad');
                          launchInBrowser(
                            url: toLaunch,//"https://github.com/Mahmoud-M-Fouad",

                          );
                        },
                        child:const ImageIcon(
                          AssetImage("images/github.png"),
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showAweSomeDialogBody(
                              context: context,
                              dialogType: DialogType.info,
                              body: buildRowToMessage(
                                messageController: messageController,
                              ),
                              colorBorder: Colors.indigo,
                              funOk: () async{
                                if (messageController.text.isNotEmpty) {
                                  launchWhatsApp(
                                    message: myMessage
                                  );
                                }
                              });
                        },
                        child:const ImageIcon(
                          AssetImage("images/whatsapp.png"),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePhoneCall({required String phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  Future<void> makeMail({required String mail}) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      path: mail,
    );
    await launchUrl(launchUri);
  }
  Future<void> launchInBrowser({required Uri url}) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
  buildColumnShow({required IconData icon, required var list}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.yellowAccent.shade700,
        ),
        const SizedBox(width: 20,),
        Text(
          "$list",
          style: headingStyle(color: Colors.white,fontSize: 16),
          textAlign: TextAlign.right,
          maxLines: 2,
        ),
      ],
    );
  }


}
