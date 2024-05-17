import 'package:timeago/timeago.dart' as timeago;

String formatToTimeAgo(DateTime dateTime) {
  return timeago.format(dateTime);
}