import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/pages/home_cases.dart';
import 'package:safetyapp/pages/profile.dart';

class HomePage extends StatefulWidget {

  static const String id = 'home_page';

  HomePage({@required this.currentUserId});

  final currentUserId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  var pageController = PageController();
  int pageIndex = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          HomeCases(currentUserId: widget.currentUserId),
          Profile(profileId: widget.currentUserId)
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavyBar(
        iconSize: 30.0,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.white,
        selectedIndex: pageIndex,
        onItemSelected: onTap,
//        currentIndex: pageIndex,
//        onTap: onTap,
//        activeColor: kGreenColor,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: kGreenColor,
              inactiveColor: Colors.black45,
              title: Text('Home'),
              icon: Icon(Icons.home,)
          ),
          BottomNavyBarItem(
              activeColor: kGreenColor,
              inactiveColor: Colors.black45,
              title: Text('Profile'),
              icon: Icon(Icons.account_circle,)
          )
//          BottomNavigationBarItem(icon: Icon(Icons.home, size: 35,)),
//          BottomNavigationBarItem(icon: Icon(Icons.settings, size: 35,)),
        ],
      )
    );
  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex){
    pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut
    );
  }


}
