import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/promotion/model/promotion.dart';

void main() {
  group('PromotionModel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        '_id': 'promo1',
        'title': 'Oferta Especial',
        'description': 'Descuento del 50%',
        'fileUrl': 'https://example.com/image.jpg',
        'fileType': 'image',
        'buttonText': 'Ver más',
        'startDate': '2024-01-01T00:00:00.000Z',
        'endDate': '2024-12-31T23:59:59.000Z',
      };

      // Act
      final promotion = PromotionModel.fromJson(json);

      // Assert
      expect(promotion.id, 'promo1');
      expect(promotion.title, 'Oferta Especial');
      expect(promotion.description, 'Descuento del 50%');
      expect(promotion.fileUrl, 'https://example.com/image.jpg');
      expect(promotion.fileType, 'image');
      expect(promotion.buttonText, 'Ver más');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final promotion = PromotionModel(
        id: 'promo2',
        title: 'Nueva Promoción',
        description: 'Gran descuento',
        fileUrl: 'https://example.com/video.mp4',
        fileType: 'video',
        buttonText: 'Comprar',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
      );

      // Act
      final json = promotion.toJson();

      // Assert
      expect(json['_id'], 'promo2');
      expect(json['title'], 'Nueva Promoción');
      expect(json['description'], 'Gran descuento');
      expect(json['fileType'], 'video');
      expect(json['buttonText'], 'Comprar');
    });

    test('fromJson debe usar valores por defecto cuando faltan campos', () {
      // Arrange
      final json = {
        'startDate': '2024-01-01T00:00:00.000Z',
        'endDate': '2024-12-31T23:59:59.000Z',
      };

      // Act
      final promotion = PromotionModel.fromJson(json);

      // Assert
      expect(promotion.id, '');
      expect(promotion.title, '');
      expect(promotion.description, '');
      expect(promotion.fileUrl, '');
      expect(promotion.fileType, 'image');
      expect(promotion.buttonText, '');
    });

    test('defaultPromotion debe retornar promoción por defecto', () {
      // Act
      final promotion = PromotionModel.defaultPromotion();

      // Assert
      expect(promotion.id, 'default');
      expect(promotion.title, '¡No hay promociones activas!');
      expect(promotion.description,
          'Vuelve pronto para descubrir nuestras próximas ofertas.');
      expect(promotion.fileUrl, '');
      expect(promotion.fileType, 'none');
      expect(promotion.buttonText, 'Cerrar');
    });

    test('getActivePromotion debe retornar promoción activa', () {
      // Arrange
      final now = DateTime.now();
      final jsonList = [
        {
          '_id': 'promo1',
          'title': 'Promoción Activa',
          'description': 'Descripción',
          'fileUrl': 'url',
          'fileType': 'image',
          'buttonText': 'Click',
          'startDate': now.subtract(Duration(days: 1)).toIso8601String(),
          'endDate': now.add(Duration(days: 1)).toIso8601String(),
        }
      ];

      // Act
      final promotion = PromotionModel.getActivePromotion(jsonList);

      // Assert
      expect(promotion.id, 'promo1');
      expect(promotion.title, 'Promoción Activa');
    });

    test('getActivePromotion debe retornar default si no hay activas', () {
      // Arrange
      final past = DateTime.now().subtract(Duration(days: 10));
      final jsonList = [
        {
          '_id': 'promo1',
          'title': 'Promoción Expirada',
          'description': 'Descripción',
          'fileUrl': 'url',
          'fileType': 'image',
          'buttonText': 'Click',
          'startDate': past.subtract(Duration(days: 5)).toIso8601String(),
          'endDate': past.toIso8601String(),
        }
      ];

      // Act
      final promotion = PromotionModel.getActivePromotion(jsonList);

      // Assert
      expect(promotion.id, 'default');
      expect(promotion.title, '¡No hay promociones activas!');
    });

    test('getActivePromotion debe retornar default si lista vacía', () {
      // Arrange
      final jsonList = [];

      // Act
      final promotion = PromotionModel.getActivePromotion(jsonList);

      // Assert
      expect(promotion.id, 'default');
    });
  });
}
