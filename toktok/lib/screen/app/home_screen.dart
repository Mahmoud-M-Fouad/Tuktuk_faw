import 'dart:convert';



import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:toktok/screen/drawerScreen/darwerUser.dart';

import '../../component/function.dart';
import '../../component/shared_prefernces.dart';
import '../../component/theme.dart';
import '../../component/widget.dart';
import '../../firebase/firebase.dart';
import '../drawerScreen/about_app.dart';
import '../drawerScreen/about_tok.dart';
import '../drawerScreen/profile.dart';
import '../drawerScreen/setting_auth.dart';
import '../drawerScreen/addLocation.dart';
import 'current_location.dart';
import 'detec_person.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userRef = FirebaseFirestore.instance.collection("toktok").snapshots();
  var refAddress =  FirebaseFirestore.instance.collection("address").snapshots();
  String dropdownvalue = 'فاو';
  List<String> items =[];
  String myAddress ="فاو";
  late bool isFree = true ;
  late bool isHasDataToFree = false ;
  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
    }).onError((error, stackTrace){
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();

  }
  getLocationAuto()
  {
    if(getUser()!=null)
    {
      _getUserCurrentLocation().then((value) async{
        var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        await updateLocation(lat: position.latitude, lon: position.longitude
        );
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationAuto();


  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text( "أطلب توكتوك",style: headingStyle(color: Colors.white, fontSize: 20,),),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SharedClass.getBool(key: "owner")?
              SizedBox(
                height: 1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("toktok",).doc(getUserID()).snapshots(),
                  builder: (context, snapshot) {
                      if (snapshot.hasData&&snapshot.data!.exists) {
                        isFree = snapshot.data?['free'] ?? true;
                        isHasDataToFree = true;
                        return  Container();
                      }
                      if (snapshot.hasError) {
                        return const Text("يوجد خطأ");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("تحميل ....");
                      }
                      return Container(height: 15,);
                  },
                ),
              ):Column(),
              SizedBox(
                height: 80,
                child: StreamBuilder(
                  stream: refAddress,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      items.clear();
                      var len = snapshot.data!.docs[0].data().length;
                      for(int i=1;i<=len!;i++)
                      {
                        items.add(snapshot.data?.docs[0]['p'"$i"]);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color:Colors.teal.shade300,//Colors.green.shade600,
                            border: Border.all(
                                width: 3.0, color: Colors.indigo.shade700),
                            borderRadius: const BorderRadius.all(Radius.circular(
                              15.0,
                            ) //
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  buildIcon(icon: Icons.house_outlined, color: Colors.black87),
                                  const SizedBox(width: 10,),
                                  buildText(text: "عنوانك", color: Colors.black87, fontSize: 20),
                                ],
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    color:Colors.white,
                                    border: Border.all(color: Colors.indigo, width:3),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                    dropdownColor: Colors.teal.shade200,
                                    value: dropdownvalue,
                                    elevation: 0,
                                    underline: Container(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20,),
                                    ),

                                    icon: const Icon(Icons.keyboard_arrow_down,color: Colors.deepPurple,),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items,style: headingStyle(color: Colors.purple, fontSize: 16),),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        myAddress = newValue!;

                                        setState(() {
                                          if(myAddress=='فاو')
                                          {
                                            userRef = FirebaseFirestore.instance.collection("toktok").snapshots();
                                          }
                                          else
                                          {
                                            userRef = FirebaseFirestore.instance.collection("toktok").where('address',isEqualTo: myAddress).snapshots();
                                          }

                                        });
                                      });
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text("يوجد خطأ");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Center(
                        child: Column(
                          children:   const [
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: userRef,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      getLocationAuto();
                      return ListView.separated(
                        shrinkWrap: true,
                        physics:  const BouncingScrollPhysics(),
                        //scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {

                          return buildListView(
                              index: index,
                              list: snapshot.data?.docs[index]

                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 2,
                          );
                        },
                        itemCount: snapshot.data!.docs.length ?? 0,
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
                  },
                ),
              ),
            ],
          ),
          drawer: SharedClass.getBool(key: "owner")?
          StreamBuilder(
          stream: FirebaseFirestore.instance.collection("user").doc(getUserID()).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData&&snapshot.data!=null) {
                return buildDrawer(
                  context: context,
                  valueBox: isFree,
                  accountName: snapshot.data?['name'],
                  accountEmail: FirebaseAuth.instance.currentUser!.email.toString(),
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
          },
        ):
          buildDrawerUser(
            context: context,
            accountName: "توكتوك فاو",
            accountEmail: "أطلب توكتوك فى أسرع وقت",
          )

        ));
  }

  buildListView({
    required int index,
    required var list,
  }) {
    return Column(
      children: [
        buildContainerListView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: (){
                  setState(() {
                    makePhoneCall(phoneNumber: list['phone']);
                  });
                }, icon: const Icon(Icons.phone,color: Colors.green,)),

                IconButton(onPressed: (){
                  setState(() {
                    SharedClass.setString(key: "userId", str: list.id);
                    navigatorTo(context: context, screen: const CurrentLocationScreen());
                  });
                }, icon: const Icon(Icons.location_on,color: Colors.purple,)),
              ],

            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    buildIcon(icon: Icons.person, color: Colors.deepPurple),
                    buildText(
                        text: "  ${list['name']}",
                        color: Colors.black87,
                        fontSize: 14),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    buildIcon(icon: Icons.home_work_outlined, color: Colors.deepPurple),
                    buildText(
                        text: "  ${list['address']}",
                        color: Colors.black87,
                        fontSize: 14),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    buildIcon(icon: Icons.phone_android, color: Colors.deepPurple),
                    buildText(
                        text: "  ${list['phone']}",
                        color: Colors.black87,
                        fontSize: 14),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

              ],
            ),
            Stack(
              alignment:AlignmentDirectional.bottomStart,
              children: [
                CircleAvatar(
                  radius:42,
                  backgroundImage: MemoryImage(
                    base64Decode(list['image'],),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: buildIcon(icon: Icons.circle, color:
                  list['free']?
                  Colors.green:Colors.red
                  ),
                ),

              ],
            ),


          ],
        )),
      ],
    );
  }

  buildContainerListView({
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            border: Border.all(width: 5, color: Colors.indigo),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child),
    );
  }
  late bool isFree2 = true;
  buildDrawer(
      {
        required String accountName,
        required String ?accountEmail,
        required BuildContext context,
        required bool valueBox,
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

          isHasDataToFree?
          ListTile(
            trailing: Checkbox(
              value: valueBox,
              onChanged: (val)
              {
                setState(() {
                  valueBox = val!;
                  isFree2 = val!;

                });
                setState(() {
                  addFree(free: isFree2!);
                });
              },
            ),
            leading: isFree2?
            buildIcon(icon: Icons.check_circle,color: Colors.teal)
                : buildIcon(icon: Icons.wrong_location,color: Colors.red),
            title: Row(
              children: [
                isFree2?
                Text("متاح الآن",style: headingStyle(color: Colors.black, fontSize: 16),):
                Text(" غير متاح الآن",style: headingStyle(color: Colors.black, fontSize: 16),),
              ],
            ),

            onTap: () {
              //navigatorTo(context: context, screen: const HomeScreen());
            },
          ):Container(),
          ListTile(
            leading: buildIcon(icon: Icons.app_blocking,color: Colors.teal),
            title: Text("التطبيق",style: headingStyle(color: Colors.black, fontSize: 16),),
            onTap: () {
              //Navigator.pop(context);AboutScreen
              navigatorTo(context: context, screen:AboutScreen());
            },
          ),
          ListTile(
            leading: buildIcon(icon: Icons.motorcycle,color: Colors.teal),
            title: Text("بيانات التوكتوك",style: headingStyle(color: Colors.black, fontSize: 16),),
            onTap: () {
              navigatorTo(context: context, screen: const AboutTokScreen());
            },
          ),

          ListTile(
            leading: buildIcon(icon: Icons.location_on,color: Colors.teal),
            title: Text("موقعى الأن",style: headingStyle(color: Colors.black, fontSize: 16),),
            //subtitle: Text(DateFormat("yyyy-MM-dd    hh:mm:s a").format(DateTime.now()),style: headingStyle(color: Colors.black, fontSize: 16),),
            onTap: () async{
              SharedClass.setString(key: "name", str: accountName);
              navigatorTo(context: context, screen: const AddLocationScreen());

            },

          ),

          ListTile(
            leading: buildIcon(icon: Icons.settings,color: Colors.teal),
            title: Text("الأعدادات",style: headingStyle(color: Colors.black, fontSize: 16),),
            onTap: () {
              navigatorTo(context: context, screen: const SettingScreen());
            },

          ),
          ListTile(
            leading: buildIcon(icon: Icons.contact_phone,color: Colors.teal),
            title: Text("اتصل بنا",style: headingStyle(color: Colors.black, fontSize: 16),),
            onTap: () {
              navigatorTo(context: context, screen: const ProfileScreen());
            },

          ),

          ListTile(
            leading: buildIcon(icon: Icons.exit_to_app,color: Colors.teal),
            title: Text("تسجيل خروج",style: headingStyle(color: Colors.black, fontSize: 16),),
            onTap: () {
              exitApp(context: context, screen: const DetePersonScreen());
              //navigatorToEnd(context: context, screen: const DetPersonScreen());
            },
          ),


        ],
      ),
    );
  }
}
