import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

String timeAgoSinceDate(String datetime) {
  DateTime date = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(datetime.replaceAll("T", " ").replaceAll("Z", ""), true).toLocal();
  final date2 = DateTime.now().toLocal();
  final difference = date2.difference(date);

  if (difference.inSeconds < 5) {
    return 'Just now';
  } else if (difference.inSeconds <= 60) {
    return '${difference.inSeconds} sec ago';
  } else if (difference.inMinutes <= 1) {
    return '1 minute ago';
  } else if (difference.inMinutes <= 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours <= 1) {
    return '1 hour ago';
  } else if (difference.inHours <= 23) {
    return '${difference.inHours} hrs ago';
  } else if (difference.inDays <= 1) {
    return '1 day ago';
  } else if (difference.inDays <= 6) {
    return '${difference.inDays} days ago';
  } else if ((difference.inDays / 7).ceil() <= 1) {
    return '1 week ago';
  } else if ((difference.inDays / 7).ceil() <= 4) {
    return '${(difference.inDays / 7).ceil()} weeks ago';
  } else if ((difference.inDays / 30).ceil() <= 1) {
    return '1 month ago';
  } else if ((difference.inDays / 30).ceil() <= 30) {
    return '${(difference.inDays / 30).ceil()} months ago';
  } else if ((difference.inDays / 365).ceil() <= 1) {
    return '1 year ago';
  }
  return '${(difference.inDays / 365).floor()} years ago';
}
