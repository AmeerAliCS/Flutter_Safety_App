import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String displayName;
  final String email;
  final String phoneNumber;
  bool isGoogleUser;
  final String photoUrl;
  final String latitude;
  final String longitude;
  final String tokenMessage;

  User(
      {this.userId,
      this.displayName,
      this.email,
      this.photoUrl,
      this.latitude,
      this.longitude,
      this.tokenMessage,
      this.phoneNumber,
      this.isGoogleUser});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      userId: doc['userId'],
      displayName: doc['displayName'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
      isGoogleUser: doc['isGoogleUser'],
      photoUrl: doc['photoUrl'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      tokenMessage: doc['tokenMessage'],
    );
  }
}
