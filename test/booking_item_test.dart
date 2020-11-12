import 'package:flutter_test/flutter_test.dart';
import 'package:myScheduleApp/src/models/BookingItem.dart';

void main() {

  // simple test to check correct conversion to GMT
  test('toGMT India test', () {
    var result = BookingItem().toGMT('2020-11-13 12:32', 'UTC-05:30');
    expect(result, '2020-11-13 18:02');
  });
}