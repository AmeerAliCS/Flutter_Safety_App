import 'package:cloud_firestore/cloud_firestore.dart';

class Cases {
  final String title;
  final String phoneNumber;
  final String address;
  final String details;
  final String displayName;
  final String photoUrl;
  final String latitude;
  final String longitude;
  final String tokenMessage;
  final String userId;
  final String caseId;

  Cases({this.title, this.phoneNumber, this.address, this.details, this.displayName, this.latitude, this.longitude,
    this.tokenMessage, this.userId, this.caseId, this.photoUrl
  });

  factory Cases.fromFireStore(DocumentSnapshot doc){

    Map data = doc.data ;
    return Cases(
      title: data['title'],
      phoneNumber: data['phoneNumber'],
      address: data['address'] ,
      details: data['details'] ,
      displayName: data['displayName'] ,
      photoUrl: data['photoUrl'] ,
      userId: data['userId'] ,
      caseId: data['caseId'],
      latitude: data['latitude'] ,
      longitude: data['longitude'],
      tokenMessage: data['tokenMessage'],
    );
  }
}