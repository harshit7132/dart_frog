import 'package:postgres/postgres.dart';
import 'dart:async';

class DbHelper {
  final _connection = PostgreSQLConnection(
    'localhost', // host
    5432, // port
    'dartfrogdb', // database name
    username: 'dartfroguser', // username
    password: 'password123', // password
  );

  // Establish connection
  Future<void> connect() async {
    await _connection.open();
  }

  // Check if user exists by email
  Future<bool> checkUserExists(String email) async {
    final result = await _connection.query(
      'SELECT email FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );
    return result.isNotEmpty;
  }

  // Close connection
  Future<void> close() async {
    await _connection.close();
  }
}
