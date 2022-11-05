

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toktok/component/theme.dart';
import 'package:toktok/component/widget.dart';


import '../../component/function.dart';
import '../app/detec_person.dart';



buildDrawerUser(
    {
      required String accountName,
      required String ?accountEmail,
      required BuildContext context,
    })
{
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(accountName),
          accountEmail: Text(accountEmail!),

          currentAccountPicture: const CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('images/toktok.jpg'),
          ),
        ),
       Column(
         children: [
           Text("تطبيق للبحث على توكتوك فى أسرع وقت",style: headingStyle(color: Colors.teal, fontSize: 18),),
           Text("يجب توفير الأنترنت للحصول على اخر التعديلات",style: headingStyle(color: Colors.black, fontSize: 14),),
           Text("1. تسطتيع معرفة مكان كل توكتوك على الخريطة",style: headingStyle(color: Colors.black, fontSize: 14),),
           Text("2. تسطتيع تتصل بأى صاحب توكتوك عن طريق الموبيل",style: headingStyle(color: Colors.black, fontSize: 14),),
           const Divider(height: 5,),
           Padding(padding: const EdgeInsets.only(left: 20,right: 20),
             child: Image.asset('images/tuktuk.png',height: 250),
           ),
         ],
       ),
        const Divider(height: 5,),


        ListTile(
          leading: buildIcon(icon: Icons.exit_to_app,color: Colors.teal),
          title: Text("الرجوع للصفحة الرئيسية",style: headingStyle(color: Colors.black, fontSize: 16),),
          onTap: () {
           navigatorToEnd(context: context, screen: const DetePersonScreen());
          },
        ),
      ],
    ),
  );
}