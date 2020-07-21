import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safetyapp/auth/auth_provider.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/alert_dialog.dart';
import 'package:safetyapp/components/custom_list_tile.dart';
import 'package:safetyapp/components/progress.dart';
import 'package:safetyapp/components/rounded_icon.dart';
import 'package:safetyapp/constants.dart';
import 'package:safetyapp/model/user.dart';
import 'package:safetyapp/pages/about_app.dart';
import 'package:safetyapp/pages/edit_profile.dart';
import 'package:safetyapp/pages/my_cases.dart';

class Profile extends StatefulWidget {

  Profile({@required this.profileId});
  final profileId;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  User user;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[

            StreamBuilder<DocumentSnapshot>(
                stream: usersRef.document(widget.profileId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
                  if(!snapshot.hasData){
                    return circularProgress();
                  }
                  user = User.fromDocument(snapshot.data);
                  return Column(
                    children: <Widget>[
                      buildProfileHeader(),
                      SizedBox(height: 30.0,),
                      buildProfileBody()
                    ],
                  );
                }
            ),
            ],
        ),
      ),
    );
  }

   Stack buildProfileHeader() {

    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Color(0xFF2D3436).withOpacity(0.2), BlendMode.darken),
            child: Container(
              width: double.infinity,
              child: Image.asset('assets/images/bg_profile.png'),
            ),
          ),
        ),

        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 61,
                  backgroundColor: kGreenColor,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 58,
                    backgroundImage: user.photoUrl != '' ? NetworkImage(user.photoUrl) : AssetImage('assets/images/no_image.png'),
                  ),
                ),

                SizedBox(height: 5.0,),
                Text(user.displayName, style: TextStyle(fontSize: 22, color: Colors.white)),
                Text(user.email, style: TextStyle(fontSize: 16,color: Colors.white)),
                SizedBox(height: 10.0,),

                buildEditButton(),


              ],
            ),
          ),
        ),

      ],
    );
  }

  ClipRRect buildProfileBody(){
    return ClipRRect(
//      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[

            CustomListTile(
              trailing: RoundedIcon(colour: Colors.green,iconUrl: 'assets/images/my_cases_icon.svg'),
              title: 'حالتي',
              onTap: (){
                checkUserHasData();
              },
            ),

            Divider(
              color: Colors.grey,
              endIndent: 70,
            ),


            CustomListTile(
              trailing: RoundedIcon(colour: Colors.orange,iconUrl: 'assets/images/about_app_icon.svg'),
              title: 'حول التطبيق',
              onTap: (){
                Navigator.of(context).pushNamed(AboutApp.id);
              },
            ),

            Divider(
              color: Colors.grey,
              endIndent: 70,
            ),

            CustomListTile(
              trailing: RoundedIcon(colour: Colors.red,iconUrl: 'assets/images/logout_icon.svg'),
              title: 'تسجيل الخروج',
              onTap: () => _signOut(context),
            ),

          ],
        ),
      ),
    );
  }

  Container buildEditButton(){
    return Container(
      width: 160.0,
      height: 44.0,
      child: SizedBox(
        width: 235.0,
        child: FlatButton(
          onPressed: (){
            Navigator.of(context).pushNamed(EditProfile.id, arguments: widget.profileId);
          },
          child: Text('تعديل', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kGreenColor,
        border: Border.all(
            color: kGreenColor
        ),
          borderRadius: BorderRadius.circular(20.0)
      ),
    );
  }

  checkUserHasData() async {
    DocumentSnapshot casesCollection = await casesRef.document(widget.profileId).get();
    if(!casesCollection.exists){
      alertDialog(
          context: context,
          title: 'لا توجد حالة',
          description: 'لا توجد لديك حالة'
      );
    }
    else{
      Navigator.of(context).pushNamed(MyCases.id, arguments: widget.profileId);
    }

  }

  void _signOut(BuildContext context) async {
    try{
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      await auth.logoutWithGoogle();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => true);
    } catch(e){
      print('Error: $e');
    }
  }
}
