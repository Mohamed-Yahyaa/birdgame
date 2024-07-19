import 'package:flutter/material.dart';


class MyBarrier extends StatelessWidget {

  final size;

  MyBarrier({this.size});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border.all(width: 10,color: Colors.grey),
        borderRadius: BorderRadius.circular(15)

      ),
    );
  }
}