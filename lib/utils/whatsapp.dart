


  import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

void launchWhatsAppUri(String phoneNumber, String message) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: message,
    );
    await launchUrl(link.asUri());
  }