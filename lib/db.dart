import 'dart:io';
import 'package:postgres/postgres.dart';

class Database {
  static PostgreSQLConnection? _connection;

  static Future<PostgreSQLConnection> getConnection() async {
    if (_connection == null || _connection!.isClosed) {
      final host = Platform.environment['DB_HOST'] ?? 'localhost';
      final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
      final dbName = Platform.environment['DB_NAME'] ?? 'user_management';
      final username = Platform.environment['DB_USER'] ?? 'luffy7132';
      final password = Platform.environment['DB_PASSWORD'] ?? 'password7132';

      _connection = PostgreSQLConnection(
        host,
        port,
        dbName,
        username: username,
        password: password,
        useSSL: true,  // enable SSL
      );

      await _connection!.open();
    }

    return _connection!;
  }

  static Future<void> closeConnection() async {
    if (_connection != null && !_connection!.isClosed) {
      await _connection!.close();
    }
  }
}
