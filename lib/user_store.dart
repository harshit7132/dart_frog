import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert' as convert;

class UserStore {
  final PostgreSQLConnection connection;

  UserStore(this.connection);

  Future<void> openConnection() async {
    await connection.open();
  }

  Future<void> closeConnection() async {
    await connection.close();
  }

  Future<bool> addUser(String email, String password, String role) async {
    final hashedPassword = _hashPassword(password);

    // Check if the user already exists
    final result = await connection.query(
      'SELECT email FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );

    if (result.isNotEmpty) {
      return false; // User already exists
    }

    // Add user to the database
    await connection.query(
      'INSERT INTO users (email, password, role) VALUES (@email, @password, @role)',
      substitutionValues: {'email': email, 'password': hashedPassword, 'role': role},
    );
    return true;
  }

  Future<bool> verifyUser(String email, String password) async {
    // Retrieve user from the database
    final result = await connection.query(
      'SELECT password FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );

    if (result.isEmpty) {
      return false; // User does not exist
    }

    // Compare the stored password hash with the hashed input password
    final storedPasswordHash = result.first[0];
    return storedPasswordHash == _hashPassword(password);
  }

  Future<bool> checkAdmins() async {
    // Check if there is already an admin
    final result = await connection.query(
      'SELECT role FROM users WHERE role = @role',
      substitutionValues: {'role': 'admin'},
    );
    return result.isNotEmpty;
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
