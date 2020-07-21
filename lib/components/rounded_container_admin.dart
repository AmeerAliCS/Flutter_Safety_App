import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedContainerAdmin extends StatelessWidget {

  RoundedContainerAdmin({this.title, this.body, this.onPressed});
  final String title;
  final String body;
  final Function onPressed;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 140.0,
        height: 100.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0,),
              Text(body, style: TextStyle(fontSize: 26,),),

            ],
          ),
        ),

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
    );
  }
}
