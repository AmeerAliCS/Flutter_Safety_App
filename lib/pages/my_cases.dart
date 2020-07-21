import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safetyapp/auth/login.dart';
import 'package:safetyapp/components/rounded_button.dart';
import 'package:safetyapp/constants.dart';

class MyCases extends StatefulWidget {

  static const String id = 'my_cases';

  MyCases({@required this.currentUserId});
  final currentUserId;

  @override
  _MyCasesState createState() => _MyCasesState();
}

class _MyCasesState extends State<MyCases> {

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: casesRef.document(widget.currentUserId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(!snapshot.hasData){
              return new Center(
                  child: Text('No Cases')
              );
            }

            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: <Widget>[
                  buildUserCasesPic(),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      SizedBox(height: 10.0,),
                      Text('عنوان الحالة', style: kCasesTextHeader),
                      Text(snapshot.data['title'], style: kCasesTextBody),
                      SizedBox(height: 10.0,),
                      Divider(),
                      Text('تفاصيل الحالة', style: kCasesTextHeader),
                      Text(snapshot.data['details'], style: kCasesTextBody),
                      SizedBox(height: 10.0,),
                      Divider(),
                      Text('رقم الهاتف', style: kCasesTextHeader),
                      SelectableText(snapshot.data['phoneNumber'], style: kCasesTextBody),
                      SizedBox(height: 10.0,),
                      Divider(),
                      Text('العنوان', style: kCasesTextHeader),
                      Text(snapshot.data['address'], style: kCasesTextBody),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: RoundedButton(
                                title: 'حذف',
                                colour: kGreenColor,
                                onPressed: (){
                                  print('تم الحذف');
                                  casesRef.document(widget.currentUserId).delete().then((value){
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              );
          },
        ),
      ),
    );
  }


  Stack buildUserCasesPic(){
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Image.asset('assets/images/marker_small_pic.png'),
        ),

        Positioned(
          left: 10,
          top: 20,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }


}
