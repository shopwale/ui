import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:url_launcher/url_launcher.dart';

dynamic formatNumber(dynamic number) {
  return NumberFormat.simpleCurrency(
    name: "INR",
    decimalDigits: 2,
  ).format(number).replaceFirst(".00", "");
}

String getDate(String date, {bool showHour = true, String format = ""}) {
  DateTime parsedDate = DateTime.parse(date);
  if (showHour) {
    return DateFormat(format != "" ? format : "d MMM y, hh:mm aaa")
        .format(parsedDate.toLocal());
  } else {
    return DateFormat(format != "" ? format : 'd MMMM y')
        .format(parsedDate.toLocal());
  }
}

String timeElapsed(String date) {
  final Duration myDuration = DateTime.now().difference(DateTime.parse(date));
  if (myDuration.inMinutes < 60) {
    return "${myDuration.inMinutes} Mins";
  }
  if (myDuration.inHours < 24) {
    return "${myDuration.inHours} Hrs";
  }
  return "${myDuration.inDays} Days";
}

Future<void> makeSocialMediaRequest(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openDialPad(String? phoneNumber) async {
  if (phoneNumber!.isNotEmpty) {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    print(url.toString());
    await makeSocialMediaRequest(url);
  }
}
