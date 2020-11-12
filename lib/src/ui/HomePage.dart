import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:myScheduleApp/src/models/BookingItem.dart';
import 'package:myScheduleApp/src/models/BookingList.dart';
import 'package:myScheduleApp/src/ui/AddBookingDialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final BookingList list = new BookingList();
  final LocalStorage storage = new LocalStorage('booking_app');
  List<String> status =  ['Ready for Pick-up', 'in Transit', 'Out for Delivery', 'Delivered'];
  bool initialized = false;
  TextEditingController controller = new TextEditingController();

  _addBooking(String departureTime, String timeZone, String timeZoneArrival, String originCountryCode,
      String arrivalCountryCode, String size, String weight,String unit) {
    setState(() {
      final booking = new BookingItem(departureTime: departureTime, timeZoneOrigin: timeZone,
          timeZoneArrival: timeZoneArrival,
          originCountryCode: originCountryCode, arrivalCountryCode: arrivalCountryCode,
      size: size, weight: weight, unit:  unit);
      list.items.add(booking);
      _saveToStorage();
    });
  }

  //TODO: move all storage calls to separate class
  _saveToStorage() {
    storage.setItem('bookings', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('bookings') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shipping/Booking Demo'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          constraints: BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var items = storage.getItem('bookings');

                if (items != null) {
                  list.items = List<BookingItem>.from(
                    (items as List).map(
                          (item) => BookingItem(
                            departureTime: item['departureTime'],
                            timeZoneOrigin: item['timeZoneOrigin'],
                            timeZoneArrival: item['timeZoneArrival'],
                            originCountryCode: item['originCountryCode'],
                            arrivalCountryCode: item['arrivalCountryCode'],
                            size: item['size'],
                            weight: item['weight'],
                            unit: item['unit'],
                      ),
                    ),
                  );
                }

                initialized = true;
              }

              List<Widget> widgets = list.items.map((item) {
                return Card(
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget> [
                            Expanded(flex: 2 , child:
                              Column(children: <Widget> [
                                Text(item.originCountryCode),
                                Text(item.toGMT(item.departureTime, item.timeZoneOrigin)),
                              ]),
                            ),
                            Expanded(flex: 2 , child:
                              Column(children: <Widget> [
                                Text(item.arrivalCountryCode),
                                // no specification about delivery time so its just +30 days from departure
                                Text(item.toGMT((DateTime.now().add(new Duration(days: 30))).toString(), item.timeZoneArrival)),
                              ]),
                            ),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Text('Status : ' + status[new Random().nextInt(status.length)],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget> [
                            Expanded(child:
                              Text('Size : ' + item.size, textAlign: TextAlign.center), ),
                            Expanded(child:
                              Text('Weight : ' + item.weight + ' ' + item.unit, textAlign: TextAlign.center),),
                          ],
                        ),
                      ]
                    ),
                  ),
                );
              }).toList();

              return Column(
                children: <Widget>[
                  ListTile(
                    onTap: null,
                    title: Row(
                        children: <Widget>[
                          Expanded(flex: 2 ,child: Text("From", textAlign: TextAlign.center,)),
                          Expanded(flex: 2 ,child: Text("To", textAlign: TextAlign.center,)),
                        ]
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: widgets,
                    ),
                  ),
                  ListTile(
                      leading: FlatButton(
                        onPressed: () {
                          _openAddBookingDialog();
                        },
                        child: Text("BOOK"),
                      ),
                      trailing:
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _clearStorage,
                        tooltip: 'Clear storage',
                      )
                  ),
                ],
              );
            },
          )),
    );
  }
  void _saveBooking(BookingItem booking) {
    _addBooking(booking.departureTime,booking.timeZoneOrigin, booking.timeZoneArrival,
        booking.originCountryCode, booking.arrivalCountryCode, booking.size,
    booking.weight, booking.unit);
    controller.clear();
  }

  Future _openAddBookingDialog() async {
    BookingItem save = await Navigator.of(context).push(new MaterialPageRoute<BookingItem>(
        builder: (BuildContext context) {
          return new AddBookingDialog();
        },
        fullscreenDialog: true
    ));
    if (save != null) {
      _saveBooking(save);
    }
  }
}