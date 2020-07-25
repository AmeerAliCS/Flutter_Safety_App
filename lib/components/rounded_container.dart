import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedContainer extends StatelessWidget {

  RoundedContainer({this.title, this.imageUrl, this.onPressed, this.padding});
  final String imageUrl;
  final String title;
  final double padding;
  final Function onPressed;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150.0,
        height: 150.0,
          child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(padding),
                    child: SvgPicture.asset(imageUrl),
                  ),

                  Container(
                    child: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),

                ],
              ),
          ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
