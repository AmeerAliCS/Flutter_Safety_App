import 'package:flutter/material.dart';
import 'package:safetyapp/components/rounded_icon.dart';

class CustomListTile extends StatelessWidget {

  CustomListTile({this.trailing, this.title, this.onTap});

  final String title;
  final Widget trailing;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      trailing: trailing,
      title: Text(
        title,
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.right,
      ),
      leading: Icon(Icons.arrow_back_ios),
    );
  }
}
