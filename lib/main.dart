
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:myScheduleApp/src/ui/HomePage.dart';



void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Shipping/Booking Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
    );
  }
}

