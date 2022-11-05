import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

import '../../component/function.dart';
import '../../component/theme.dart';
import '../../component/widget.dart';
import '../../firebase/firebase.dart';
import '../app/add.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutTokScreen extends StatefulWidget {
  const AboutTokScreen({Key? key}) : super(key: key);

  @override
  State<AboutTokScreen> createState() => _AboutTokScreenState();
}

class _AboutTokScreenState extends State<AboutTokScreen> {
  double locationMessageLat = 5;//26.111728098792753;
  double locationMessageLon = 5;//32.40359719608184;
  GeoCode geoCode = GeoCode();
  void getCurrentLocation()async
  {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      locationMessageLat = position.latitude;
      locationMessageLon = position.longitude;
    });
  }
  var ref = FirebaseFirestore.instance
      .collection(
        "toktok",
      )
      .doc(getUserID())
      .get();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
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
                    "توكتوكى",
                    style: headingStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: ref,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        //child: Text("stri"),
                                        radius: 90,
                                        backgroundImage: MemoryImage(
                                          base64Decode(snapshot.data?['image']),
                                        ),
                                      ),
                                      const Divider(
                                        height: 10,
                                        color: Colors.transparent,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              buildIcon(
                                                  icon: Icons.person,
                                                  color: Colors.deepPurple),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                snapshot.data?['name'],
                                                style: headingStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              buildIcon(
                                                  icon: Icons.place_outlined,
                                                  color: Colors.deepPurple),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                snapshot.data?['address'],
                                                style: headingStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 10,
                                          ),
                                          Row(
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              buildIcon(
                                                  icon: Icons.phone_android,
                                                  color: Colors.deepPurple),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                snapshot.data?['phone'],
                                                style: headingStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              //itemCount: list?.isEmpty == null?0:list.length,
                              itemCount: 1,
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text("يوجد خطأ");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("تحميل ....");
                          }
                          return Container(
                            height: 15,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Padding(padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Image.asset('images/tuktuk.png',height: 250),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildMaterialButton(
                            color: Colors.indigo,
                            text: " بيانات التوكتوك",
                            function: () {
                              showAweSomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  colorBorder: Colors.green,
                                  body: "هل تريد بيانات التوكتوك",
                                  funOk: () {
                                    navigatorTo(
                                        context: context,
                                        screen: const AddScreen());
                                  },
                                  funCancel: () {});
                            }),
                        buildMaterialButton(
                            color: Colors.indigo,
                            text: "حذف التوكتوك",
                            function: () {
                              showAweSomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  colorBorder: Colors.green,
                                  body: "هل تريد حذف التوكتوك",
                                  funOk: () {
                                    deleteData(context: context);
                                  },
                                  funCancel: () {});
                            }),
                      ],
                    ),
                  ],
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
}

buildContainerListView({
  required Widget child,
}) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.teal.shade100,
          border: Border.all(width: 5, color: Colors.indigo),
          borderRadius: BorderRadius.circular(20),
        ),
        child: child),
  );
}

buildPhoneInListView({
  required var onPressed,
  required var list,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.phone_android,
            color: Colors.teal,
          )),
      buildText(text: "$list", color: Colors.black87, fontSize: 16),
    ],
  );
}
