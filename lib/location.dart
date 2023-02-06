import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
   String? lat;
   String? long;
  //Getting Current Location
  Future<Position?> _getCurrentLocation() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled)
    {
      return Future.error('Location Services are disabled');
    }
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
    if(locationPermission  == LocationPermission.deniedForever){
      return Future.error('Location permissions are  permanently denied , we cannot request your location');
    }
    return await Geolocator.getCurrentPosition();
  }
  // Listen to Location Updates
  void _liveLocation(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat= position.latitude.toString();
      long = position.longitude.toString();
    });
  }

  Future<void>_openMap(String lat , String long)async{
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await launchUrlString(googleUrl)?await launchUrlString(googleUrl)
        :throw 'Couldn\'t launch$googleUrl}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location',style: TextStyle(fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: 220,
                color:Colors.grey[300],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Location',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor:MaterialStateColor.resolveWith((states) => Colors.teal)),
              onPressed:(){
                _getCurrentLocation().then((value) {
                  lat = '${value?.latitude}';
                  long = '${value?.longitude}';
                });
                _liveLocation();
                _openMap(lat!,long!);
              },
              child: Text('Get Current Location',
              style:TextStyle(fontSize: 30,height: 2,) ,
              ),
            ),
            const SizedBox(
              height: 30,
            ),

          ],
        ),
      ),
    );
  }
}
