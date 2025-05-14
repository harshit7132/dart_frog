import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
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

  // Simulate logic (e.g., you can later add DB or file write logic here)
  if (role.toLowerCase() == 'admin') {
    // Simulate check that only one admin is allowed
    return Response.json(
      statusCode: 409,
      body: {'error': 'One admin already exists (simulated)'},
    );
  }

  return Response.json(body: {'message': 'User registered successfully (no DB)'});
}
