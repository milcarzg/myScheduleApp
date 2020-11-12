import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_provider/country_provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myScheduleApp/src/models/BookingItem.dart';

class AddBookingDialog extends StatefulWidget {
  @override
  AddBookingDialogState createState() => new AddBookingDialogState();
}

class AddBookingDialogState extends State<AddBookingDialog> {
  String tempDeparture = DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now());
  String tempTimezoneOrigin = 'UTC-04:00';
  String tempTimezoneArrival = 'UTC-05:00';
  String tempOrigin = 'DK';
  String tempArrival = 'CA';
  String unit = 'kg';
  String size = '20';
  String weight = '1000';
  Country country;
  int selectedUnit = 1;
  int selectedSize = 1;

  //search countryTimeZone by country code
  void _searchCountryTimeZone(String code, bool origin) async {
    country =
        await CountryProvider.getCountryByCode(code, filter: CountryFilter());
    if (country != null) {
      print(country.timezones.first);
      if (origin == true) {
        tempTimezoneOrigin = country.timezones.first;
      } else {
        tempTimezoneArrival = country.timezones.first;
      }
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
                Navigator.of(context).pop(new BookingItem(
                    departureTime: tempDeparture,
                    timeZoneOrigin: tempTimezoneOrigin,
                    timeZoneArrival: tempTimezoneArrival,
                    originCountryCode: tempOrigin,
                    arrivalCountryCode: tempArrival,
                    unit: unit,
                    size: size,
                    weight: weight));
              },
              child: new Text('SAVE',
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue: 'Enter weight',
                      onChanged: (text) {
                        weight = text;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('kg'),
                          Radio(
                            value: 1,
                            groupValue: selectedUnit,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedUnit(val);
                            },
                          ),
                          Text('oz'),
                          Radio(
                            value: 2,
                            groupValue: selectedUnit,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedUnit(val);
                            },
                          ),
                        ],
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('20'),
                          Radio(
                            value: 1,
                            groupValue: selectedSize,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedSize(val);
                            },
                          ),
                          Text('40'),
                          Radio(
                            value: 2,
                            groupValue: selectedSize,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedSize(val);
                            },
                          ),
                        ],
                      )),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        _searchCountryTimeZone(code.code, true);
                        tempOrigin = code.code;
                      },
                    ),
                  ]),
              Text('Departure Date', textAlign: TextAlign.end,),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child:
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate:
                      DateTime.now(), // validated - not allowing date before now
                  lastDate: DateTime(2100),
                  autovalidate: true,
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  onChanged: (val) {
                    tempDeparture = val;
                  },
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        _searchCountryTimeZone(code.code, false);
                        tempArrival = code.code;
                      },
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: move to some util class for possible later reuse on different pages

  void setSelectedUnit(int val) {
    setState(() {
      selectedUnit = val;
      if (val == 1) {
        unit = 'kg';
      } else if (val == 2) {
        unit = 'oz';
      }
    });
  }

  //TODO: move to some util class for possible later reuse on different pages
  void setSelectedSize(int val) {
    setState(() {
      selectedSize = val;
      if (val == 1) {
        size = '20';
      } else if (val == 2) {
        size = '40';
      }
    });
  }
}
