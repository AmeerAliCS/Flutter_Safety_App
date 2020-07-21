import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/progress.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/pages/marker_cases_details.dart';

class MapShowCases extends StatefulWidget {

  static const String id = 'map_show_cases';

  @override
  _MapShowCasesState createState() => _MapShowCasesState();
}

class _MapShowCasesState extends State<MapShowCases> {

  Completer<GoogleMapController> _controller = Completer();
  bool isLoading = false;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    getMarkerData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? circularProgress() :  Stack(
        children: <Widget>[
          buildGoogleMap(context),
          buildBottomCard(),
          Positioned(
            left: 10,
            top: 30,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: kGreenColor),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  getMarkerData() async{
    await casesRef.getDocuments().then((docs){
      for(int i= 0; i < docs.documents.length; i++) {
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(docs.documents[i].data['caseId']),
            position: LatLng(double.parse(docs.documents[i].data['latitude']), double.parse(docs.documents[i].data['longitude'])),
            infoWindow: InfoWindow(title: docs.documents[i].data['title']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose,
            ),
          ));
        });
      }
    });
  }

  Widget buildGoogleMap(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(33.289226, 44.234382), zoom: 6),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },

        markers: Set.from(_markers),

      ),
    );

  }

  addMarker({String title, String details, String phoneNumber, String address, double latitude, double longitude
  , String caseId}){
    _markers.add(Marker(
      markerId: MarkerId(caseId),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: title),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRose,
      ),
    ));
  }



  Widget buildBottomCard(){
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 110.0,
          child: StreamBuilder<QuerySnapshot>(
            stream: casesRef.snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if (snapshot.hasError){
                return new Center(
                    child:Text('Error: ${snapshot.error}')
                );
              }
              if(!snapshot.hasData){
                return new Center(
                    child:circularProgress()
                );
              }

              else{
                var documents = snapshot.data.documents;
                if(documents.length>0){
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: documents.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: boxes(
                            title: documents[index].data['title'],
                            details: documents[index].data['details'],
                            phoneNumber: documents[index].data['phoneNumber'],
                            address: documents[index].data['address'],
                            image: documents[index].data['photoUrl'],
                            latitude: double.parse(documents[index].data['latitude']),
                            longitude: double.parse(documents[index].data['longitude']),
                            caseId: documents[index].data['caseId']
                          ),
                        );
                      }
                  );
                }
              }


              return null;
            },
          ),
        )
    );
  }

  Widget boxes({String title, String details, String phoneNumber, String address,
    double latitude, double longitude, String image, String caseId}){
    return GestureDetector(
      onTap:() {
        gotoLocation(latitude: latitude, longitude: longitude);

        Future.delayed(Duration(seconds: 2), () {
          
          Navigator.push(context, MaterialPageRoute(builder: (context) => MarkerCasesDetails(
            title: title,
            details: details,
            phoneNumber: phoneNumber,
            address: address,
            latitude: latitude,
            longitude: longitude,
          )));

          
        });
      },
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: image == '' ? AssetImage('assets/images/no_image.png') : NetworkImage(image)
                    ),
                  )
                ),

                Container(
                  width: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Center(child: Text(title, style: TextStyle(fontSize: 18),)),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> gotoLocation({double latitude, double longitude}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude, longitude), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }

}
