import 'package:date_time_picker/date_time_picker.dart';

class BookingItem {
  String departureTime;
  String timeZoneOrigin;
  String originCountryCode;
  String arrivalCountryCode;
  String timeZoneArrival;
  String size;
  String weight;
  String unit;


  BookingItem({this.departureTime, this.timeZoneOrigin, this.originCountryCode,
    this.arrivalCountryCode, this.timeZoneArrival,
    this.size, this.weight, this.unit});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['departureTime'] = departureTime;
    m['timeZoneOrigin'] = timeZoneOrigin;
    m['originCountryCode'] = originCountryCode;
    m['arrivalCountryCode'] = arrivalCountryCode;
    m['timeZoneArrival'] = timeZoneArrival;
    m['size'] = size;
    m['weight'] = weight;
    m['unit'] = unit;

    return m;
  }

  toGMT(String time, String timeZone) {
    String timeDifference = timeZone.substring(3);
    var offsetH = int.tryParse(timeZone.substring(4,6));
    var offsetM = int.tryParse(timeZone.substring(7,9));
    DateTime temp = DateTime.parse(time);
    DateTime temp2;
    if (timeDifference.startsWith('-')){ //if TimeZone before GMT we add time
      temp2 = temp.add(new Duration(hours: offsetH, minutes: offsetM));
    } else { // if TimeZone after GMT we substract time
      temp2 = temp.subtract(new Duration(hours: offsetH, minutes: offsetM));
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(temp2).toString();
  }
}