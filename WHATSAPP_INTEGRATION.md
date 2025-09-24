# WhatsApp Integration

This app includes WhatsApp integration for customer support. Users can contact support directly through WhatsApp from various screens.

## Configuration

To configure the WhatsApp support number, edit the `lib/config/app_config.dart` file:

```dart
class AppConfig {
  // Change this to your actual WhatsApp support number
  static const String whatsappSupportNumber = '573001234567';
  
  // Customize the default messages for different contexts
  static const Map<String, String> defaultMessages = {
    'appointment': 'Hola, necesito ayuda con mi cita de fumigación.',
    'chatbot': 'Hola, necesito ayuda con el chatbot de fumigación.',
    'tecnico': 'Hola, soy técnico y necesito ayuda.',
    'general': 'Hola, necesito ayuda con mi servicio de fumigación.',
  };
}
```

## Phone Number Format

The phone number should be formatted with the country code but without the '+' sign:
- Colombia: `573001234567`
- Mexico: `525512345678`
- Spain: `34123456789`

## Features

- **User Screens**: WhatsApp button available in:
  - Appointment Form Screen
  - Chatbot Screen
- **Technician Screen**: WhatsApp button available in the main technician screen
- **Error Handling**: Graceful error handling with user feedback
- **Fallback Support**: Attempts to open WhatsApp app directly if web version fails

## Usage

The WhatsApp button appears as a chat icon in the app bar. When tapped, it will:
1. Open WhatsApp with the configured phone number
2. Pre-fill a contextual message based on the screen
3. Show an error message if WhatsApp cannot be opened

## Dependencies

This feature requires the `url_launcher` package, which is already included in `pubspec.yaml`.

