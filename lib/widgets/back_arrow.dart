import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            padding: EdgeInsets.all(18.0),
            margin: EdgeInsets.only(top: 48.0),
            child: Icon(Icons.arrow_back, color: Colors.white)));
  }
}
