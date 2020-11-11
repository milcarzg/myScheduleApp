import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_provider/country_provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:myScheduleApp/src/models/BookingItem.dart';

class AddBookingDialog extends StatefulWidget {
  @override
  AddBookingDialogState createState() => new AddBookingDialogState();
}

class AddBookingDialogState extends State<AddBookingDialog> {
  String tempDeparture = DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now());
  String tempTimezone = "UTC-04:00";
  String tempOrigin = 'DK';
  String tempArrival = 'CA';
  Country country;


  //search countryTimeZone by country code
  void _searchCountryTimeZone(String code) async {
    print('search: ' + code);
    country =
    await CountryProvider.getCountryByCode(code,
        filter: CountryFilter());
    if (country!= null) {
      print(country.timezones.first);
      tempTimezone = country.timezones.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New booking'),
        actions: [
          new FlatButton(
              onPressed: () {
                if (tempDeparture!= null &&
                    tempTimezone!= null &&
                    tempOrigin != null &&
                    tempArrival != null) {
                  Navigator
                      .of(context)
                      .pop(new BookingItem(departureTime: tempDeparture,
                      timeZone: tempTimezone,
                      originCountryCode: tempOrigin,
                      arrivalCountryCode: tempArrival));
                }
              },
              child: new Text('SAVE',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Departure Country'),
                  CountryListPick(
                    appBar: AppBar(
                      title: Text('Choose Departure country'),
                    ),
                    theme: CountryTheme(
                      isShowFlag: true,
                      isShowTitle: true,
                      isShowCode: false,
                      isDownIcon: false,
                      showEnglishName: true,
                    ),
                    initialSelection: '+45',
                    onChanged: (CountryCode code) {
                      _searchCountryTimeZone(code.code);
                      tempOrigin = code.code;
                    },
                  ),
                ]
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime.now(), // validated - not allowing date before today
              lastDate: DateTime(2100),
              autovalidate: true,
              icon: Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              onChanged: (val) {
                tempDeparture = val;
                print('onChanged' + val);
              },
              onSaved: (val) => print('onSaved' + val),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Arrival Country'),
                  CountryListPick(
                    appBar: AppBar(
                      title: Text('Choose Arrival country'),
                    ),
                    theme: CountryTheme(
                      isShowFlag: true,
                      isShowTitle: true,
                      isShowCode: false,
                      isDownIcon: false,
                      showEnglishName: true,
                    ),
                    initialSelection: '+1',
                    onChanged: (CountryCode code) {
                      tempArrival = code.code;
                    },
                  ),

                ]
            ),

          ],
        ),
      ),
    );
  }
}