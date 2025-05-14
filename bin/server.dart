import 'package:dart_frog/dart_frog.dart';
import 'dart:io';

void main() async {
  final server = await serve(
    (context) async {
      final path = context.request.url.path;

      // Handle login route
      if (path == 'auth/login' && context.request.method == 'POST') {
        return await handleLogin(context);
      }

      // Handle signUp route
      if (path == 'auth/signUp' && context.request.method == 'POST') {
        return await handleSignUp(context);
      }

      // If the route is not found
      return Response(statusCode: 200, body: 'dart api live ');
    },
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8080'),
  );

  print('Server running on http://${server.address.host}:${server.port}');
}

Future<Response> handleLogin(RequestContext context) async {
  final body = await context.request.body();
  // Handle login logic
  return Response.json(body: {'message': 'Login successful'});
}

Future<Response> handleSignUp(RequestContext context) async {
  final body = await context.request.body();
  // Handle sign-up logic
  return Response.json(body: {'message': 'Sign Up successful'});
}
