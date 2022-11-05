
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


import '../component/function.dart';
import '../screen/app/home_screen.dart';
import '../screen/authentication/login.dart';

Future<Position> _getUserCurrentLocation() async {
  await Geolocator.requestPermission().then((value) {
  }).onError((error, stackTrace){
    print(error.toString());
  });
  return await Geolocator.getCurrentPosition();

}
addData({
  required String name,
  required String phone,
  required String address,
  required String image,
  required bool free,
  required BuildContext context,
})async
{
  CollectionReference userRef = FirebaseFirestore.instance.collection("toktok");
  userRef.doc(getUserID()).set(
      {
        "name":name,
        "phone":phone,
        "address":address,
        "image":image,
        "free":free,
      }

  ).then((value){
    showAweSomeDialogYes(
      context: context,
      body:"تم إضافة بيانات التوكتوك بنجاح",
      colorBorder: Colors.green,
      dialogType: DialogType.success,
      funOk: (){
        navigatorToEnd(context: context, screen: const HomeScreen());
      },
    );
    _getUserCurrentLocation().then((value) async{
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await addLocation(context: context, lat: position.latitude, lon: position.longitude,
          name: name
      );
    });
  });
}

addFree({
  required bool free,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("toktok");
  userRef.doc(getUserID()).update(
      {
        "free":free,
      }
  );
}
addFreeFirstOnly({
  required bool free,
})async
{
  CollectionReference userRef = FirebaseFirestore.instance.collection("toktok");
  userRef.doc(getUserID()).set(
      {
        "free":free,
      }
  );
}

getFree()async{
return FirebaseFirestore.instance.collection("user",).doc(getUserID()).get();

}

updateData({
  required String name,
  required String phone,
  required String address,
  required String image,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("toktok");
  userRef.doc(getUserID()).update(
      {
        "name":name,
        "phone":phone,
        "address":address,
        "image":image,
      }
  );
}

deleteData({required BuildContext context})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("toktok");
  userRef.doc(getUserID()).delete().then((value) {
    showAweSomeDialogYes(
      context: context,
      body:"تم حذف بيانات التوكتوك بنجاح",
      colorBorder: Colors.green,
      dialogType: DialogType.success,
      funOk: (){
        navigatorToEnd(context: context, screen: const HomeScreen());
      },
    );
  });
}

addOwner({
  required BuildContext context,
  required String mail,
  required String name,
  required String pass,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("user");
  userRef.doc(getUserID()).set(
      {
        "mail":mail,
        "name":name,
        "pass":pass,
      }

  ).then((value){
    _getUserCurrentLocation().then((value) async{
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      await addLocationToCreateUser(context: context, lat: position.latitude, lon: position.longitude,
          name: name
      );
    });

  });
}

updateOwnerName({
  required BuildContext context,
  required String name,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("user");
  userRef.doc(getUserID()).update(
      {
        "name":name,
      }

  ).then((value){
    updateOwnerNameTok(
      context: context,
      name: name
    );
  });
}

updateOwnerNameTok({
  required String name,
  required BuildContext context,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("toktok");
  userRef.doc(getUserID()).update(
      {
        "name":name,
      }
  ).then((value){
    showAweSomeDialogYes(
      context: context,
      body: "تم تغيير أسم المستخدم بنجاح",
      colorBorder: Colors.green,
      dialogType: DialogType.success,
      funOk: (){
        navigatorToEnd(context: context, screen: const HomeScreen());
      },
    );
  });
}


updateOwnerPass({
  required BuildContext context,
  required String pass,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("user");
  //  1.default Id userRef.add({"age":"14", "name":"zezooo", "phone":"011223",}
  //  2. set Id
  userRef.doc(getUserID()).update(
      {
        "pass":pass,
      }
  );
}

 getOwner()async{
   return FirebaseFirestore.instance.collection("user",).doc(getUserID()).get();

}
getPassword({required String mail}){
  return FirebaseFirestore.instance.collection("user",).where('mail',isEqualTo: mail).snapshots();

}

getUser()
{
  return FirebaseAuth.instance.currentUser;
}
getUserID()
{
  return FirebaseAuth.instance.currentUser!.uid;
}


exitApp(
    {
      required BuildContext context,
      required var screen,
    })async
{
  await FirebaseAuth.instance.signOut();
  navigatorToEnd(context: context, screen: screen);
}

Future resetPassword({required String email}) async {
  var pass = await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  return pass;
}

Future changePassword({required BuildContext context,required String pass}) async
{
  await FirebaseAuth.instance.currentUser!.updatePassword(pass).then((value){
    updateOwnerPass(
      context: context,
      pass: pass
    );
    showAweSomeDialogYes(
      context: context,
      body:"تم تغيير كلمة السر بنجاح",
      colorBorder: Colors.green,
      dialogType: DialogType.success,
      funOk: (){
        navigatorToEnd(context: context, screen: const HomeScreen());
      },
    );
  });
}

addLocation({
  required BuildContext context,
  required double lat,
  required double lon,
  required String name,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("location");
  userRef.doc(getUserID()).set(
      {
        "lat":lat,
        "lon":lon,
        "name":name,
      }

  ).then((value){
    showAweSomeDialogYes(
      context: context,
      body:"تم إضافة الموقع الخاص بيك بنجاح",
      colorBorder: Colors.green,
      dialogType: DialogType.success,
      funOk: (){
        navigatorToEnd(context: context, screen: const HomeScreen());
      },
    );
  });
}

addLocationToCreateUser({
  required BuildContext context,
  required double lat,
  required double lon,
  required String name,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("location");
  userRef.doc(getUserID()).set(
      {
        "lat":lat,
        "lon":lon,
        "name":name,
      }

  ).then((value) {
    showAweSomeDialogYes(
      context: context,
      body:"تم إنشاء الحساب بنجاح",
      colorBorder: Colors.green,
      dialogType: DialogType.success,
      funOk: (){
        navigatorToEnd(context: context, screen: const LoginScreen());
      },
    );
  });
}


updateLocation({
  required double lat,
  required double lon,
})async {
  CollectionReference userRef = FirebaseFirestore.instance.collection("location");
  userRef.doc(getUserID()).update(
      {
        "lat":lat,
        "lon":lon,
      }

  );
}

getLocation({required String id})async {
  return FirebaseFirestore.instance.collection("location").doc(id).snapshots();
}