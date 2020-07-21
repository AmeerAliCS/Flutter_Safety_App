import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safetyapp/auth/login.dart';

abstract class BaseAuth{
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword (String _email, String _password);
  Future<String> createUserWithEmailAndPassword (String _email, String _password);
  Future<String> currentUser();
  Future<void> signOut();
  loginWithGoogle();
  logoutWithGoogle();
  String displayName;

}

final GoogleSignIn googleSignIn = GoogleSignIn();

class Auth implements BaseAuth {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();
  String name;

  @override
   set displayName(String _displayName) {
    name = _displayName;
  }

  @override
  String get displayName => name;


  createUserInFirestoreByGoogle() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      usersRef.document(user.id).setData({
        'userId': user.id,
        'displayName': user.displayName,
        'email': user.email,
        'phoneNumber' : '',
        'isGoogleUser' : true,
        'photoUrl': user.photoUrl,
        'latitude' : '',
        'longitude' : '',
        'tokenMessage' : '',
        'timestamp': timestamp
      });
    }

  }

  createUserInFirestoreByEmail() async {
    final user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot doc = await usersRef.document(user.uid).get();

    if (!doc.exists) {
      usersRef.document(user.uid).setData({
        'userId': user.uid,
        'displayName': displayName,
        'email': user.email,
        'phoneNumber' : '',
        'isGoogleUser' : false,
        'photoUrl': '',
        'latitude' : '',
        'longitude' : '',
        'tokenMessage' : '',
        'timestamp': timestamp
      });
    }

  }

  Stream<String> get onAuthStateChanged{
    return firebaseAuth.onAuthStateChanged.map((user) => user?.uid);
  }

  @override
  Future<String> signInWithEmailAndPassword (String _email, String _password) async {
    final user = await firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
    return '$user';
  }

  @override
  Future<String> createUserWithEmailAndPassword (String _email, String _password) async {
    final user = await firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
    await createUserInFirestoreByEmail();
    print(displayName);
    return '$user';
  }

  @override
  Future<String> currentUser () async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  loginWithGoogle() async {
    await googleSignIn.signIn();
    await createUserInFirestoreByGoogle();
  }

  logoutWithGoogle() async {
    await googleSignIn.signOut();
  }




}