import 'BookingItem.dart';

class BookingList {
  List<BookingItem> items;

  BookingList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}