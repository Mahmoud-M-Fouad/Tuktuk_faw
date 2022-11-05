
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:toktok/component/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:whatsapp_unilink/whatsapp_unilink.dart';
showAweSomeDialogYes({
  required BuildContext context,
  required DialogType dialogType,
  required String body,
  required Color colorBorder,
  required var funOk,
})

{
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    borderSide:  BorderSide(

      color: colorBorder,
      width: 2,
    ),
    width: 500,
    buttonsBorderRadius: const BorderRadius.all(

      Radius.circular(2),
    ),
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: true,
    animType: AnimType.bottomSlide,
    body:Text(body,style: headingStyle(color: Colors.black, fontSize: 18),),
    btnOkOnPress: funOk,
    btnOkText: "تم",
  ).show();
}

showAweSomeDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String body,
  required Color colorBorder,
  required var funCancel,
  required var funOk,
})

{
  return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      borderSide:  BorderSide(

        color: colorBorder,
        width: 2,
      ),
      width: 500,
      buttonsBorderRadius: const BorderRadius.all(

        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,
      body:Text(body,style: headingStyle(color: Colors.black, fontSize: 18),),
      btnCancelOnPress: funCancel,
      btnOkOnPress: funOk,
      btnOkText: "نعم",
      btnCancelText: "لا"
  ).show();
}

navigatorToEnd(
    {
      required BuildContext context,
      required var screen,
    })
{
  return Navigator.pushAndRemoveUntil<dynamic>(
    context,
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => screen,
    ),
        (route) => false,//if you want to disable back feature set to false
  );
}
navigatorTo(
    {
      required BuildContext context,
      required var screen,
    })
{
  return Navigator.push(
    context ,
    MaterialPageRoute(builder: (context) =>screen),
  );
}

showToast({
  required BuildContext context,
  required String msg,
  required Color color,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: Colors.indigo.shade100,
      duration: const Duration(seconds: 2),
      content: Text(msg, style:  TextStyle(color: color,fontSize: 18),textAlign: TextAlign.right,),
    ),
  );
}


showDialogMethod({
  required BuildContext context ,
  required Widget title ,
  required Widget content ,
  required Function cancelButton ,
  required String textCancel ,
  required var continueButton  ,
  required String textContinue
})
{
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
        backgroundColor: Colors.deepPurple.shade100,
        titleTextStyle: headingStyle(color: Colors.indigo, fontSize: 20),
        contentTextStyle: headingStyle(color: Colors.indigo.shade300, fontSize: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),

        title: title,
        titlePadding: const EdgeInsets.all(10),
        content: content,
        actions: [
          TextButton(onPressed:()
          {
            Navigator.pop(context);
          }
            , child: Text(textCancel,textAlign: TextAlign.end,
                style:TextStyle(fontSize: 20,color: Colors.red.shade700) ),),

          TextButton(onPressed:continueButton, child: Text(textContinue ,textAlign: TextAlign.start,
              style:TextStyle(fontSize: 20,color: Colors.green.shade500)
          ))
        ],
      );
    },
  );
}

Future<void> makePhoneCall({required String phoneNumber}) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

sendWatsAppMessage({required BuildContext context,required String phone , required String message})async
{
  String url ;

  if(Platform.isIOS)
  {
    url = "whatsapp://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
  }
  else{
    url = "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}";
  }
  await canLaunch(url)?launch(url)
      :showToast(context: context, msg: "هذا الجهاز ليس لديه واتس أب", color: Colors.red);
}

buildImageProfile({
  required double radius ,
  required String imagePath ,
} )
{
  return Padding(
    padding: const EdgeInsets.all(10),
    child: CircleAvatar(
      backgroundImage: AssetImage(imagePath),
      radius: radius,
    ),
  );
}
buildCopy({
  required String textCopy ,required BuildContext context
})
{
  FlutterClipboard.copy(textCopy).then(( value ) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('تم النسخ' , style: TextStyle(color: Colors.green,fontSize: 18),textAlign: TextAlign.right,),
      ),
    );
  });
}

buildPast({
  required String textCopy ,required String pasteValue
})
{
  FlutterClipboard.paste().then((value) {
    textCopy = value;
    pasteValue = value;
  });

}

showAweSomeDialogBody({
  required BuildContext context,
  required DialogType dialogType,
  required Widget body,
  required Color colorBorder,
  required var funOk,
})

{
  return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      borderSide:  BorderSide(

        color: colorBorder,
        width: 2,
      ),
      width: 500,
      buttonsBorderRadius: const BorderRadius.all(

        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,
      body:body,
      btnCancelOnPress: (){},
      btnOkOnPress: funOk,
      btnOkText: "نعم",
      btnCancelText: "لا"
  ).show();
}

launchWhatsApp({required String message}) async {
  final link = WhatsAppUnilink(
    phoneNumber: '+201063378834',
    text: message,
  );
  // Convert the WhatsAppUnilink instance to a string.
  // Use either Dart's string interpolation or the toString() method.
  // The "launch" method is part of "url_launcher".
  await launch('$link');
}