import '../entities/user_entities.dart';

abstract class AuthRepository {
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();
}

