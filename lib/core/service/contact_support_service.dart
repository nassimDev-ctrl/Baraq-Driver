import 'package:url_launcher/url_launcher.dart';

abstract final class ContactSupportService {
  static const supportPhone = '+963947844086';
  static const supportPhoneDigits = '963947844086';

  /// Forces LTR rendering so "+" stays before the country code in RTL UI.
  static String get displayPhone => '\u200E$supportPhone';

  static Future<bool> openWhatsApp() async {
    final webUri = Uri.parse('https://wa.me/$supportPhoneDigits');
    if (await _launch(webUri)) return true;

    final appUri = Uri.parse('whatsapp://send?phone=$supportPhoneDigits');
    return _launch(appUri);
  }

  static Future<bool> openPhoneCall() async {
    final uri = Uri(scheme: 'tel', path: supportPhone);
    return _launch(uri);
  }

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
