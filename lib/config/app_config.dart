class AppConfig {
  // WhatsApp support phone number (with country code, no + sign)
  // Example: '573001234567' for Colombia
  static const String whatsappSupportNumber = '573001234567';
  
  // Default support messages for different contexts
  static const Map<String, String> defaultMessages = {
    'appointment': 'Hola, necesito ayuda con mi cita de fumigación.',
    'chatbot': 'Hola, necesito ayuda con el chatbot de fumigación.',
    'tecnico': 'Hola, soy técnico y necesito ayuda.',
    'general': 'Hola, necesito ayuda con mi servicio de fumigación.',
  };
}

