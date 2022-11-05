import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toktok/firebase/firebase.dart';

import '../../component/shared_prefernces.dart';
import '../../component/theme.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  String address = '' ;
  final Completer<GoogleMapController> _controller = Completer();

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
    }).onError((error, stackTrace){
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();

  }


  final List<Marker> _markers =  <Marker>[];
  final List<Marker> _markersTok =  <Marker>[];
  late double latTok;
  late double lonTok;
  String street = 'فاو قبلى'  ;



  late BitmapDescriptor markerbitmap;
setIcon()async
{
    markerbitmap = await BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(),
    "images/tuktuk128s.png",
  );
   return markerbitmap;
}

setStreet()async
{
    List<Placemark> placemarks = await placemarkFromCoordinates(latTok ,lonTok);
    final add = placemarks.first;
    street = "${add.street}";
  }

cameraPositionTuk({required double lat,required double lon})async
{
    final GoogleMapController controller = await _controller.future;

    CameraPosition _kGooglePlex =  CameraPosition(
      target: LatLng(lat ,lon),
      zoom: 25,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIcon();


    //loadData();
  }
  late List<Marker> list;
  loadData(){
    _getUserCurrentLocation().then((value) async {
      _markers.add(
          Marker(
              markerId: const MarkerId('SomeId'),
              position: LatLng(value.latitude ,value.longitude),
              infoWindow:  InfoWindow(
                  title: address
              )
          )
      );

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex =  CameraPosition(
        target: LatLng(value.latitude ,value.longitude),
        zoom: 19,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {

      });
    });
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
                  //backgroundColor: Colors.deepOrange,
                  title: const Text('موقعى وموقع صاحب التوكتوك'),
                ),
                body: SafeArea(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("location")
                            .doc(SharedClass.getString(key: "userId")).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData&&snapshot.data!=null) {
                            latTok = snapshot.data?['lat'];
                            lonTok = snapshot.data?['lon'];
                            setStreet();
                            /*
                            cameraPositionTuk(
                              lat: latTok,
                              lon: lonTok,
                            );*/
                            list =  [
                              Marker(
                                  markerId: MarkerId(SharedClass.getString(key: "userId")),
                                  //position: LatLng(26.111728098792753, 32.40359719608184),
                                  position: LatLng(snapshot.data?['lat'],snapshot.data?['lon']),
                                  infoWindow: InfoWindow(
                                      title:"صاحب التوكتوك : ${snapshot.data?['name']}",
                                    snippet: " الآن فى $street",

                                  ),
                                /*icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueCyan,
                                ),*/
                                icon:markerbitmap
                              ),

                            ];
                            _markers.addAll(list);
                             CameraPosition _kGooglePlex =  CameraPosition(
                              //target: LatLng(26.111728098792753, 32.40359719608184),
                              target: LatLng(latTok, lonTok),
                              zoom: 25,
                            );
                            return GoogleMap(
                              initialCameraPosition: _kGooglePlex,
                              mapType: MapType.normal,
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                              markers: Set<Marker>.of(_markers),
                              onMapCreated: (GoogleMapController controller){
                                _controller.complete(controller);
                              },
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
                      Container(
                        height: MediaQuery.of(context).size.height * .2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                _getUserCurrentLocation().then((value) async {
                                  List<Placemark> placemarks2 = await placemarkFromCoordinates(value.latitude  ,value.longitude);
                                  final add2 = placemarks2.first;
                                  _markers.add(
                                      Marker(
                                          markerId: const MarkerId('SomeId'),
                                          position: LatLng(value.latitude ,value.longitude),
                                          infoWindow:  InfoWindow(
                                              title: "موقعى أنا",
                                            snippet: add2.street,

                                          )
                                      )
                                  );
                                  final GoogleMapController controller = await _controller.future;

                                  CameraPosition _kGooglePlex =  CameraPosition(
                                    target: LatLng(latTok ,lonTok),
                                    zoom: 25,
                                  );
                                  controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

                                  List<Placemark> placemarks = await placemarkFromCoordinates(latTok ,lonTok);
                                  final add = placemarks.first;
                                  address = add.locality.toString() +" "+add.administrativeArea.toString()+" "+add.subAdministrativeArea.toString()+" "+add.country.toString();
                                  setState(() {

                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: const Center(child: Text('الموقع الحالى للتوكتوك' , style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(address),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

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
        )
    );

  }


}
