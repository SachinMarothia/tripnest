import '../entities/user_entities.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  const GetCurrentUser(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUser();
  }
}