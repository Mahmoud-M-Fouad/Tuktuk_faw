import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toktok/component/widget.dart';

import '../../component/shared_prefernces.dart';
import '../../component/theme.dart';
import '../../firebase/firebase.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({Key? key}) : super(key: key);

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  @override
  Widget build(BuildContext context) {
    Future<Position> _getUserCurrentLocation() async {
      await Geolocator.requestPermission().then((value) {
      }).onError((error, stackTrace){
        print(error.toString());
      });
      return await Geolocator.getCurrentPosition();

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
                  title: const Text('موقعى وموقع صاحب التوكتوك'),
                ),
                body: SafeArea(
                  child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'images/map.png',
                            ),
                          ),
                          buildElevatedButton(
                              color: Colors.indigo,
                              text: "أضافة موقعى الحالى",
                              function: ()async
                              {
                                _getUserCurrentLocation().then((value) async{
                                  var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                  await addLocation(context: context, lat: position.latitude, lon: position.longitude,
                                  name: SharedClass.getString(key: "name")
                                  );
                                });


                              },
                              icon: Icons.location_on
                          ),
                        ],
                      ))

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
