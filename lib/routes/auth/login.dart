import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

const jwtSecret = 'your_secret_key_here'; // In real apps, use environment variables.

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

  // Dummy verification (simulate a check)
  if (email == 'admin@example.com' && password == 'admin123') {
    final jwt = JWT({'email': email, 'role': 'admin'});
    final token = jwt.sign(SecretKey(jwtSecret), expiresIn: const Duration(hours: 1));
    return Response.json(body: {'msg': 'Welcome Admin', 'token': token});
  }

  if (email == 'user@example.com' && password == 'user123') {
    final jwt = JWT({'email': email, 'role': 'user'});
    final token = jwt.sign(SecretKey(jwtSecret), expiresIn: const Duration(hours: 1));
    return Response.json(body: {'msg': 'Welcome User', 'token': token});
  }

  return Response.json(
    statusCode: 401,
    body: {'error': 'Invalid credentials'},
  );
}
