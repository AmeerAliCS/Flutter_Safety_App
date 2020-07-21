import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safetyapp/admin/admin_home.dart';
import 'package:safetyapp/auth/auth.dart';
import 'package:safetyapp/auth/auth_provider.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/pages/home_page.dart';
import 'login.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();

class RootPage extends StatefulWidget {

  static const String id = 'root_page';

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  login,
  notLogin,
  notKnow
}

class _RootPageState extends State<RootPage> {

  bool isAuth = false;
  bool isAdmin;
  final String adminId1 = 'H2jAJjx4VYPInfohh6PIPzbVM322';
  final String adminId2 = 'CJwiSbGjubZKdSF4o89PWWfEWkN2';
  AuthStatus checkLogged = AuthStatus.notKnow;
  final DateTime timestamp = DateTime.now();


  handleSignIn(GoogleSignInAccount account) {
    if(account != null){
      setState(() {
        isAuth = true;
      });
    } else{
      setState(() {
        isAuth = false;
      });
    }
  }


@override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account){
      setState(() {
        checkLogged = account != null ? AuthStatus.login : AuthStatus.notLogin;
      });
      handleSignIn(account);
    }, onError: (err){
      print('Error signing in: $err');
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account){
      setState(() {
        checkLogged = account != null ? AuthStatus.login : AuthStatus.notLogin;
      });
      handleSignIn(account);
    }, onError: (err){
//      print('Error signing in: $err');
    });

    Future.delayed(Duration(seconds: 3), () {
      if(googleSignIn.currentUser == null){
        setState(() {
          checkLogged = AuthStatus.notLogin;
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          if(!snapshot.hasData){
            if(checkLogged == AuthStatus.notKnow){
                return _buildWaitingScreen();
            }
             if(checkLogged == AuthStatus.login){
              return HomePage(currentUserId: googleSignIn.currentUser.id);
            }
             if(checkLogged == AuthStatus.notLogin){
              return Login();
            }
          }
          final bool isLoggedIn = snapshot.hasData;
          if(snapshot.data == adminId1 || snapshot.data == adminId2){
              isAdmin = true;
          }
          else{
              isAdmin = false;
          }
          if(isLoggedIn){
            if(isAdmin){
              return AdminHome();
            }
            else{
              return HomePage(currentUserId: snapshot.data);
            }
          }
          else{
            return Login();
          }
        }
        else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none){

          print('Error in network');
        }
        return _buildWaitingScreen();
      },
    );
  }

  Widget _buildWaitingScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kGreenColor),),
      ),
    );
  }
}
