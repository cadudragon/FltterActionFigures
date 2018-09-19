import 'package:flutter/material.dart';

class AdressTag extends StatelessWidget{
  final String adress;

  AdressTag(this.adress);

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
              child: Text(adress),
            )
    );
  }
  
}