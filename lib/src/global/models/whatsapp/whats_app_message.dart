class WhatsAppMessage {
  final String phoneNumber; // Número de teléfono del destinatario
  final String message; // Mensaje a enviar
  final DateTime?
      timestamp; // Hora opcional de envío (para mensajes programados)

  WhatsAppMessage(
      {required this.phoneNumber, required this.message, this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
