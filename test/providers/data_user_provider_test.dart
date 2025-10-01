import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/src/providers/data_user_provider.dart';
import 'package:lexxi/domain/auth/model/user.dart';

void main() {
  group('DataUserProvider Tests', () {
    late DataUserProvider provider;

    setUp(() {
      provider = DataUserProvider();
    });

    test('Setter de userViewModel debe actualizar el valor y notificar',
        () async {
      // Arrange
      final user = User(
        id: 1,
        name: 'Test',
        email: 'test@test.com',
      );
      var notified = false;

      provider.addListener(() {
        notified = true;
      });

      // Act
      provider.userViewModel = user;

      // Assert
      expect(notified, isTrue);
      expect(provider.userViewModel.value.id, 1);
    });
  });
}
