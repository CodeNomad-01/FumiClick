import 'package:url_launcher/url_launcher.dart';

class WhatsAppUtil {
  /// Opens WhatsApp with a specific phone number
  /// [phoneNumber] should include country code without '+' (e.g., "573001234567")
  /// [message] is optional and will be pre-filled in the chat
  static Future<void> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    // Remove any non-numeric characters from phone number
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Create WhatsApp URL
    String whatsappUrl = 'https://wa.me/$cleanPhoneNumber';
    
    // Add message if provided
    if (message != null && message.isNotEmpty) {
      final encodedMessage = Uri.encodeComponent(message);
      whatsappUrl += '?text=$encodedMessage';
    }
    
    // Try to launch WhatsApp
    final uri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: try to open WhatsApp app directly
        final whatsappAppUrl = Uri.parse('whatsapp://send?phone=$cleanPhoneNumber');
        if (await canLaunchUrl(whatsappAppUrl)) {
          await launchUrl(whatsappAppUrl, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('No se pudo abrir WhatsApp');
        }
      }
    } catch (e) {
      throw Exception('Error al abrir WhatsApp: $e');
    }
  }
  
  /// Opens WhatsApp with a default support message
  static Future<void> openWhatsAppSupport({
    required String phoneNumber,
    String defaultMessage = 'Hola, necesito ayuda con mi servicio de fumigación.',
  }) async {
    await openWhatsApp(
      phoneNumber: phoneNumber,
      message: defaultMessage,
    );
  }
}

