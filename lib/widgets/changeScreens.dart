import 'package:flutter/material.dart';
class ChangeScreens extends StatelessWidget {
  @override
  final Function onPressed;
  final String name;
  final String witchacount;
  ChangeScreens({this.name,this.onPressed,this.witchacount});
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Text(witchacount),
        SizedBox(width: 10,),
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>onPressed()));
            },
            child:Text(name,style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight:FontWeight.bold ),)
        )
      ],
    );
  }
}
