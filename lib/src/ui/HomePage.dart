import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:myScheduleApp/src/models/BookingItem.dart';
import 'package:myScheduleApp/src/models/BookingList.dart';
import 'package:myScheduleApp/src/ui/AddBookingDialog.dart';
import 'package:myScheduleApp/src/ui/DetailScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final BookingList list = new BookingList();
  final LocalStorage storage = new LocalStorage('booking_app');
  bool initialized = false;
  TextEditingController controller = new TextEditingController();

  _addBooking(String departureTime, String timeZone, String originCountryCode, String arrivalCountryCode) {
    setState(() {
      final booking = new BookingItem(departureTime: departureTime, timeZone: timeZone,
          originCountryCode: originCountryCode, arrivalCountryCode: arrivalCountryCode);
      list.items.add(booking);
      _saveToStorage();
    });
  }

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
                        timeZone: item['timeZone'],
                        originCountryCode: item['originCountryCode'],
                        arrivalCountryCode: item['arrivalCountryCode'],
                      ),
                    ),
                  );
                }

                initialized = true;
              }

              List<Widget> widgets = list.items.map((item) {
                return ListTile(
                  title: Row(
                      children: <Widget>[
                        Expanded(flex: 1 ,child: Text(item.originCountryCode)),
                        Expanded(flex: 2 ,child: Text(item.departureTime)),
                        Expanded(flex: 1 ,child: Text(item.arrivalCountryCode)),
                      ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(shipment: item),
                      ),
                    );
                  },
                );
              }).toList();

              return Column(
                children: <Widget>[
                  ListTile(
                    onTap: null,
                    title: Row(
                        children: <Widget>[
                          Expanded(flex: 1 ,child: Text("From")),
                          Expanded(flex: 2 ,child: Text("Departure")),
                          Expanded(flex: 1 ,child: Text("To")),
                        ]
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: widgets,
                      itemExtent: 50.0,
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
    _addBooking(booking.departureTime,booking.timeZone,booking.originCountryCode, booking.arrivalCountryCode);
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