import 'dart:io';
import 'package:postgres/postgres.dart';

class Database {
  static final _connection = PostgreSQLConnection(
    Platform.environment['DB_HOST'] ?? 'localhost',
    int.parse(Platform.environment['DB_PORT'] ?? '5432'),
    Platform.environment['DB_NAME'] ?? 'your_db_name',
    username: Platform.environment['DB_USER'] ?? 'your_username',
    password: Platform.environment['DB_PASSWORD'] ?? 'your_password',
  );

  static Future<PostgreSQLConnection> getConnection() async {
    if (_connection.isClosed) {
      await _connection.open();
    }
    return _connection;
  }
}
