// ignore_for_file: avoid_slow_async_io

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  final port = int.parse(Platform.environment['PORT'] ?? '8080'); // Dynamically set the port for Render

  final handler = const Pipeline()
      .addMiddleware(logRequests())  // Custom logging middleware
      .addHandler(_router);

  serve(handler, 'localhost', port);  // Start server on the specified port
}

// Define routes
final _router = Router()
  ..get('/auth/login', _loginHandler);

// Define your route handler
Future<Response> _loginHandler(RequestContext context) async {
  try {
    // Read the contents of login.dart (make sure the path is correct)
    final file = File('routes\auth\login.dart');
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      // Return the content of login.dart as the response
      return Response.json(body: {'loginContent': fileContent});
    } else {
      return Response.json(body: {'error': 'File not found'}, statusCode: 404);
    }
  } catch (e) {
    // Handle error if file reading fails
    return Response.json(body: {'error': 'Failed to read file: $e'}, statusCode: 500);
  }
}

// Define routes
final _router1 = Router()
  ..get('/auth/signup', _signUpHandler);

// Define your sign up route handler
Future<Response> _signUpHandler(RequestContext context) async {
  try {
    // Read the contents of login.dart (make sure the path is correct)
    final file = File('routes\auth\signUp.dart');
    if (await file.exists()) {
      final fileContent = await file.readAsString();
      // Return the content of login.dart as the response
      return Response.json(body: {'signUpcontant': fileContent});
    } else {
      return Response.json(body: {'error': 'signUp File not found'}, statusCode: 404);
    }
  } catch (e) {
    // Handle error if file reading fails
    return Response.json(body: {'error': 'Failed to read file: $e'}, statusCode: 500);
  }
}

// Custom logging middleware
Middleware logRequests() {
  return (handler) {
    return (context) async {
      final request = context.request;
      print('Request: ${request.method} ${request.uri}');

      final response = await handler(context);

      print('Response: ${response.statusCode}');
      return response;
    };
  };
}
