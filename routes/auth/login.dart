import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method Not Allowed'},
    );
  }

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

  // Simulate successful login (In a real-world case, verify credentials)
  return Response.json(
    body: {'message': 'Login successful'},
  );
}
