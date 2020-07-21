import 'package:flutter/material.dart';
import 'package:safetyapp/auth/auth.dart';
import 'package:safetyapp/auth/auth_provider.dart';
import 'package:safetyapp/auth/root_page.dart';
import 'package:safetyapp/services/route_generator.dart';


void main() {
  runApp(AuthProvider(
    auth: Auth(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00B894)
      ),
      home: RootPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  ));
}

//void main() => runApp(
//  DevicePreview(
//    enabled: !kReleaseMode,
//    builder: (context) => HomePage()
//  ),
//);
