import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safetyapp/admin/admin_cases.dart';
import 'package:safetyapp/admin/admin_users.dart';
import 'package:safetyapp/auth/auth_provider.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/auth/root_page.dart';
import 'package:safetyapp/components/progress.dart';
import 'package:safetyapp/components/rounded_container_admin.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/pages/map_show_cases.dart';


class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  int requestCount = 0;
  int usersCount = 0;
  int casesCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUsersCount();
    getCasesCount();
    getRequestCasesCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      body: isLoading ? circularProgress() : MediaQuery.removePadding(
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

            SizedBox(height: 30.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedContainerAdmin(
                  title: 'Request',
                  body: requestCount.toString(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AdminCases.id);
                  },),

                SizedBox(width: 20.0,),

                RoundedContainerAdmin(
                  title: 'Users',
                  body: usersCount.toString(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AdminUsers.id);
                  },),

              ],
            ),
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedContainerAdmin(
                  title: 'Cases',
                  body: casesCount.toString(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(MapShowCases.id);
                  },),
                SizedBox(width: 20.0,),

              GestureDetector(
                onTap: () {
                  _signOut(context);
                },
                child: Container(
                  width: 140.0,
                  height: 100.0,
                  padding: EdgeInsets.all(2.0),
                  child: Center(child: SvgPicture.asset('assets/images/logout_icon.svg', color: Colors.red, height: 40.0,)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),

              ],
            )

          ],
        ),
      )
    );
  }

  void _signOut(BuildContext context) async {
    try{
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      await auth.logoutWithGoogle().then((value){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootPage()));
      });
    } catch(e){
      print('Error: $e');
    }
  }


  getUsersCount() async {
    await usersRef.getDocuments().then((val) {
      setState(() {
        usersCount = val.documents.length;
      });
    });
  }

  getCasesCount() async {
    await casesRef.getDocuments().then((val) {
      setState(() {
        casesCount = val.documents.length;
      });
    });

}

  getRequestCasesCount() async {
    await adminRef.getDocuments().then((val) {
      setState(() {
        requestCount = val.documents.length;
      });
    });
  }

}
