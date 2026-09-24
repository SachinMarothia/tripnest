import '../entities/user_entities.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  const RegisterUser(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}