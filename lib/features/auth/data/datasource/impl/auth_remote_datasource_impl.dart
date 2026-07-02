import 'package:myfschool/core/error/exceptions.dart';
import 'package:myfschool/core/network/api_client.dart';
import 'package:myfschool/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:myfschool/features/auth/data/models/login_request.dart';
import 'package:myfschool/features/auth/data/models/login_response.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await ApiClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const ParsingException('Login response must be a JSON object');
    }

    return LoginResponse.fromJson(responseData);
  }
}
