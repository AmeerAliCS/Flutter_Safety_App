import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/alert_dialog.dart';
import 'package:safetyapp/components/rounded_container.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/pages/add_cases.dart';
import 'package:safetyapp/pages/map_show_cases.dart';

class HomeCases extends StatefulWidget {

  static const String id = 'home_cases';

  HomeCases({@required this.currentUserId});
  final currentUserId;


  @override
  _HomeCasesState createState() => _HomeCasesState();
}

class _HomeCasesState extends State<HomeCases> {

  String latitude;
  String longitude;
  bool userHasData = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(kGreenColor.withOpacity(0.8), BlendMode.darken),
                    child: Container(
                      width: double.infinity,
                      child: Image.asset('assets/images/bg_home_iraq.png'),
                    ),
                  ),
                ),

              ],
            ),


            SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedContainer(
                  padding: 2.0,
                  title: 'عرض الحالات',
                  imageUrl: 'assets/images/show_cases.svg',
                  onPressed: () {
                    Navigator.of(context).pushNamed(MapShowCases.id);
                  },),

                SizedBox(width: 20.0,),

                RoundedContainer(
                  padding: 10.0,
                  title: 'اضافة حالة',
                  imageUrl: 'assets/images/add_cases.svg',
                  onPressed: () {
                    checkUserHasData();
                  },),

              ],
            )

          ],
        ),
      ),
    );
  }

  getNotifications(){
    _firebaseMessaging.getToken().then((token) {
      usersRef.document(widget.currentUserId).updateData({
        'tokenMessage' : token
      });
    });

    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((settings){
      print("Settings registered: $settings");
    });
  }

  checkUserHasData() async {
    DocumentSnapshot casesCollection = await casesRef.document(widget.currentUserId).get();
    DocumentSnapshot adminCollection = await adminRef.document(widget.currentUserId).get();
    if(casesCollection.exists){
          alertDialog(
          context: context,
          title: 'توجد حالة سابقة',
          description: 'يجب حذف الحالة القديمة لاضافة حالة جديدة'
        );
    }
    else if(adminCollection.exists){
      alertDialog(
          context: context,
          title: 'حالتك قيد الانتظار',
          description: 'يرجى الانتظار لحين الموافقة على حالتك'
      );
    }

    else{
      Navigator.of(context).pushNamed(AddCases.id, arguments: widget.currentUserId);
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position.latitude != null && position.longitude != null){
      usersRef.document(widget.currentUserId).updateData({
        'latitude' : '${position.latitude.toString()}',
        'longitude' : '${position.longitude.toString()}',
      });
    }
  }
//
//  void sendTokenToServer(String fcmToken) {
//    print('Token: $fcmToken');
//    // send key to your server to allow server to use
//    // this token to send push notifications
//  }
}


