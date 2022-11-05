
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../component/theme.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text("أطلب توكتوك",style: headingStyle(color: Colors.white, fontSize: 20),),
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //const SizedBox(height:10 ,),
                  Padding(padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Image.asset('images/tuktuk.png',height: 250),
                  ),
                  Column(
                    children: [
                      Text("يجب وجود أنترنت",style: headingStyle(color: Colors.teal, fontSize: 18),),
                      Text("تطبيق للبحث على توكتوك فى أسرع وقت",style: headingStyle(color: Colors.teal, fontSize: 18),),
                      Text("من خلال التطبيق  ",style: headingStyle(color: Colors.black, fontSize: 16),),
                      Text("1. تسطتيع تسجيل بياناتك الخاص بالتوكتوك الخاص بيك",
                        style: headingStyle(color: Colors.black, fontSize: 14),),
                      Text("2. تسطتيع تعديل أو حذف البيانات الخاصة بالتوكتوك",
                        style: headingStyle(color: Colors.black, fontSize: 14),),
                      Text("3. تسطتيع تحدد لنفسك متاح أم مشغول الآن",
                        style: headingStyle(color: Colors.black, fontSize: 14),),
                      Text("4. تسطتيع تحديد الموقع الحالى لك",
                        style: headingStyle(color: Colors.black, fontSize: 14),),
                     // const SizedBox(height:10 ,),
                      const Divider(height: 5,color: Colors.teal,),

                      Text("1. أمكانة تظهر لك كل بيانات الخاصة ",style: headingStyle(color: Colors.black, fontSize: 14),),
                      Text("بكل صاحب توكتوك مسجل على التطبيق",style: headingStyle(color: Colors.black, fontSize: 14),),

                      Text("2. أمكانة تطلب أى توكتوك عن طريق الرقم الهاتف الخاص بيه",style: headingStyle(color: Colors.black, fontSize: 14),),
                      Text("3. أمكانة معرفة الموقع الحالى الخاص بكل توكتوك مسجل على التطبيق",style: headingStyle(color: Colors.black, fontSize: 14),),
                      const SizedBox(height:10 ,),
                      const Divider(height: 5,color: Colors.teal,),
                      Text("البيانات المطلوبة لتسجيل بيانات توكتوك",
                          style: headingStyle(color: Colors.black, fontSize: 16) ),
                      Text("أسم صاحب التوكتوك ، رقم الهاتف ، عنوانه ، صورة",
                          style: headingStyle(color: Colors.black, fontSize: 14) ),
                    ],
                  ),
                ],
              ),
            ),
          )
        )
    );
  }
}
