import '../../domain/entities/user_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.login(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('User not found after login.');
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('User not found after registration.');
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = remoteDataSource.getCurrentUser();

    if (firebaseUser == null) {
      return null;
    }

    return UserModel.fromFirebaseUser(firebaseUser);
  }
}
