import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedIcon extends StatelessWidget {

  RoundedIcon({this.colour, this.iconUrl});

  final iconUrl;
  final Color colour;

  @override
  Widget build(BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: colour,
          width: 35.0,
          height: 35.0,
          child: Center(
            child: SvgPicture.asset(iconUrl, height: 25.0,),
          ),
        ),
      );
    }
  }

