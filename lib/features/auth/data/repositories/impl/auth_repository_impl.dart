import 'package:dio/dio.dart';
import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/error/failures.dart';
import 'package:myfschool/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:myfschool/features/auth/data/repositories/auth_repository.dart';
import 'package:myfschool/features/auth/domain/entities/auth_user.dart';

import '../../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        LoginRequest(username: username, password: password),
      );

      return AuthUser(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException {
      throw const ParsingFailure();
    } on ParsingException {
      throw const ParsingFailure();
    } catch (error) {
      throw UnknownFailure(error.toString());
    }
  }

  Failure _mapDioException(DioException error) {
    final message = _extractBackendMessage(error.response?.data);

    if (_isConnectionError(error)) {
      return NetworkFailure(message);
    }

    final statusCode = error.response?.statusCode;

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return AuthFailure(message);
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerFailure(message);
    }

    return UnknownFailure(message);
  }

  bool _isConnectionError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  String? _extractBackendMessage(Object? data) {
    if (data is! Map<String, dynamic>) return null;

    final message = data['message'] ?? data['error'];

    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final nestedData = data['data'];

    if (nestedData is Map<String, dynamic>) {
      return _extractBackendMessage(nestedData);
    }

    return null;
  }
}
