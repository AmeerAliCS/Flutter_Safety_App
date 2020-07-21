import 'package:flutter/material.dart';
import 'package:safetyapp/constants.dart';

class AdminCasesDetails extends StatefulWidget {

  AdminCasesDetails({@required this.title, @required this.details, @required this.phoneNumber,
    @required this.address});

  final String title;
  final String details;
  final String phoneNumber;
  final String address;


  @override
  _AdminCasesDetailsState createState() => _AdminCasesDetailsState();
}

class _AdminCasesDetailsState extends State<AdminCasesDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: <Widget>[
            buildMarkerPic(),
            buildMarkerDetails(),
          ],
        ),
      ),
    );
  }

  Stack buildMarkerPic(){
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

  Container buildMarkerDetails(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          SizedBox(height: 10.0,),
          Text('عنوان الحالة', style: kCasesTextHeader),
          Text(widget.title, style: kCasesTextBody),
          SizedBox(height: 10.0,),
          Divider(),
          Text('تفاصيل الحالة', style: kCasesTextHeader),
          Text(widget.details, style: kCasesTextBody),
          SizedBox(height: 10.0,),
          Divider(),
          Text('رقم الهاتف', style: kCasesTextHeader),
          SelectableText(widget.phoneNumber, style: kCasesTextBody),
          SizedBox(height: 10.0,),
          Divider(),
          Text('العنوان', style: kCasesTextHeader),
          Text(widget.address, style: kCasesTextBody),

        ],
      ),
    );
  }

}
