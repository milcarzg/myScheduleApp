class BookingItem {
  String departureTime;
  String timeZone;
  String originCountryCode;
  String arrivalCountryCode;
  String size;
  String weight;
  bool units;

  BookingItem({this.departureTime, this.timeZone, this.originCountryCode, this.arrivalCountryCode,
    this.size, this.weight, this.units});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['departureTime'] = departureTime;
    m['timeZone'] = timeZone;
    m['originCountryCode'] = originCountryCode;
    m['arrivalCountryCode'] = arrivalCountryCode;
    m['size'] = size;
    m['weight'] = weight;
    m['units'] = units;

    return m;
  }
}