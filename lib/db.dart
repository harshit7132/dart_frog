import 'dart:io';
import 'package:postgres/postgres.dart';

class Database {
  static PostgreSQLConnection? _connection;

  static Future<PostgreSQLConnection> getConnection() async {
    if (_connection == null || _connection!.isClosed) {
      _connection = PostgreSQLConnection(
        Platform.environment['DB_HOST'] ?? 'localhost',
        int.parse(Platform.environment['DB_PORT'] ?? '5432'),
        Platform.environment['DB_NAME'] ?? 'user_management',
        username: Platform.environment['DB_USER'] ?? 'luffy7132',
        password: Platform.environment['DB_PASSWORD'] ?? 'password7132',
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
