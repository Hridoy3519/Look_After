
import 'package:flutter/material.dart';
import 'package:look_after/screens/home_screen/appbar.dart';
import 'package:look_after/screens/home_screen/goPremium.dart';
class HomeScreen extends StatelessWidget {
  static const String path = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GoPremium(),
        ],
      ),
    );
  }
}