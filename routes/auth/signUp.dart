import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method Not Allowed'}
    );
  }

  final body = await context.request.body();
  final data = jsonDecode(body);

  final email = data['email'];
  final password = data['password'];
  final role = data['role'];

  if (email == null || password == null || role == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Email, password, and role are required'},
    );
  }

  // Simulate user creation (In a real-world case, insert into DB)
  return Response.json(
    body: {'message': 'User registered successfully'},
  );
}
