import 'package:flutter/material.dart';
import 'package:safetyapp/constants.dart';

class MarkerCasesDetails extends StatefulWidget {

  static const String id = 'marker_cases_datails';

  MarkerCasesDetails({
    @required this.title, @required this.details, @required this.phoneNumber,
  @required this.address, @required this.latitude, @required this.longitude
  });

  final String title;
  final String details;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;

  @override
  _MarkerCasesDetailsState createState() => _MarkerCasesDetailsState();
}

class _MarkerCasesDetailsState extends State<MarkerCasesDetails> {


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
