import 'package:flutter/material.dart';

class Featurebox extends StatelessWidget {
  final String textHeading;
  final String textBody;
  final Color color;
  const Featurebox({super.key, required this.color, required this.textHeading, required this.textBody});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(textHeading,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Cera-Pro",color: Colors.black),),
          Text(textBody,style: TextStyle(fontSize: 15,fontFamily: "Cera-Pro",color: Colors.black),),
        ],
      ),
    );
  }
}
