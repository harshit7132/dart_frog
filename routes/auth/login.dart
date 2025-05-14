import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';
import '../../lib/user_store.dart';

const jwtSecret = 'your_secret_key_here'; // Use env variable in real apps

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.body();
  final data = jsonDecode(body);

  final email = data['email'];
  final password = data['password'];

  if (email == null || password == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Email and password are required'},
    );
  }

  // Initialize connection
  final userStore = UserStore(PostgreSQLConnection('localhost', 5432, 'dartfrogdb', username: 'dartfroguser', password: 'password123'));
  await userStore.openConnection();

  // Verify user credentials
  final verified = await userStore.verifyUser(email.toString(), password.toString());
  if (!verified) {
    await userStore.closeConnection();
    return Response.json(
      statusCode: 401,
      body: {'error': 'Invalid credentials'},
    );
  }

  // Create JWT token
  final jwt = JWT({'email': email});
  final token = jwt.sign(SecretKey(jwtSecret), expiresIn: const Duration(hours: 1)); // 1 hour expiration

  // Check the role of the user
  final result = await userStore.connection.query(
    'SELECT role FROM users WHERE email = @email',
    substitutionValues: {'email': email},
  );

  final role = result.first[0];
  if (role == 'admin') {
    await userStore.closeConnection();
    return Response.json(body: {'msg': 'Welcome Admin', 'token': token});
  }

  await userStore.closeConnection();
  return Response.json(body: {'msg': 'Welcome User', 'token': token});
}
