import 'package:url_launcher/url_launcher.dart';

import '../constants/product_info.dart';

Future<bool> openNafasSupportEmail({
  String subject = 'پشتیبانی اپلیکیشن نفس',
  String? body,
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: NafasProductInfo.supportEmail,
    queryParameters: {
      'subject': subject,
      if (body != null && body.trim().isNotEmpty) 'body': body,
    },
  );

  return launchUrl(uri, mode: LaunchMode.platformDefault);
}
