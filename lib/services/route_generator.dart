import 'package:flutter/material.dart';
import 'package:safetyapp/admin/admin_cases.dart';
import 'package:safetyapp/admin/admin_users.dart';
import 'package:safetyapp/auth/root_page.dart';
import 'package:safetyapp/pages/about_app.dart';
import 'package:safetyapp/pages/add_cases.dart';
import 'package:safetyapp/pages/edit_profile.dart';
import 'package:safetyapp/pages/map_show_cases.dart';
import 'package:safetyapp/pages/my_cases.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {

      case RootPage.id:
        return MaterialPageRoute(builder: (_) => RootPage());
        break;

      case EditProfile.id:
        return MaterialPageRoute(builder: (_) => EditProfile(profileId: args));
        break;

      case AddCases.id:
        return MaterialPageRoute(builder: (_) => AddCases(currentUserId: args));
        break;

      case MapShowCases.id:
        return MaterialPageRoute(builder: (_) => MapShowCases());
        break;

      case AdminUsers.id:
        return MaterialPageRoute(builder: (_) => AdminUsers());
        break;

      case AdminCases.id:
        return MaterialPageRoute(builder: (_) => AdminCases());
        break;

      case MyCases.id:
        return MaterialPageRoute(builder: (_) => MyCases(currentUserId: args,));
        break;

      case AboutApp.id:
        return MaterialPageRoute(builder: (_) => AboutApp());
        break;

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
