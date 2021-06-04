import 'package:flutter/material.dart';
class MyBoutton extends StatelessWidget {
  final Function onPressed;
  final String name;
  MyBoutton({ this.name, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      child: RaisedButton(

      color:Colors.blueGrey[400],
        child: Text(name),
        onPressed: onPressed(),
      ),
    );
  }
}
