import 'package:intl/intl.dart';

String thDateFormat(DateTime date) {
  DateTime dateTime = date;
  var thaiDateFormat = DateFormat('d MMM', 'th_TH');
  String formattedDate = thaiDateFormat.format(dateTime);
  String thaiYear = (dateTime.year + 543).toString(); // Convert to Buddhist year
  return '$formattedDate $thaiYear';
}
