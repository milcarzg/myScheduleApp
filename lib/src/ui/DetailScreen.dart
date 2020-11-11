import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myScheduleApp/src/models/BookingItem.dart';


class DetailScreen extends StatelessWidget {
  final BookingItem shipment;

  DetailScreen({Key key, @required this.shipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shipment.arrivalCountryCode),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        },)
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(shipment.timeZone),
      ),
    );
  }
}