import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/auth/repositories/login_repository.dart';

@injectable
class RegisterUseCase {
  final LoginRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> call(RegisterModel data) {
    return _repository.registerUser(data);
  }
}
