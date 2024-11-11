import 'package:intl/intl.dart';

String formatDate(String dateString) {
  final dateTime = DateTime.parse(dateString);
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}
