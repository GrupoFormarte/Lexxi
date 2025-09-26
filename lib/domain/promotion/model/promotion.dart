class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String fileType; // Nuevo campo para el tipo de archivo
  final String buttonText;
  final DateTime startDate;
  final DateTime endDate;

  PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileType,
    required this.buttonText,
    required this.startDate,
    required this.endDate,
  });

  // Constructor para crear una instancia desde JSON
  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileType: json['fileType'] ?? 'image', // Predeterminado a 'image'
      buttonText: json['buttonText'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  // Método para convertir una instancia en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'buttonText': buttonText,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  // Método estático para obtener la promoción activa o una por defecto
  static PromotionModel getActivePromotion(List<dynamic> jsonList) {
    DateTime now = DateTime.now();

    for (var json in jsonList) {
      PromotionModel promotion = PromotionModel.fromJson(json);

      if (now.isAfter(promotion.startDate) &&
          now.isBefore(promotion.endDate)) {
        return promotion;
      }
    }

    // Retornar promoción por defecto si no hay ninguna activa
    return PromotionModel.defaultPromotion();
  }

  // Promoción por defecto
  static PromotionModel defaultPromotion() {
    return PromotionModel(
      id: 'default',
      title: '¡No hay promociones activas!',
      description: 'Vuelve pronto para descubrir nuestras próximas ofertas.',
      fileUrl: '', // Sin imagen ni video
      fileType: 'none', // No hay contenido multimedia
      buttonText: 'Cerrar',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
  }
}