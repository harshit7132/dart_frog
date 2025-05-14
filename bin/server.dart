import 'package:dart_frog/dart_frog.dart';
import '../routes/auth/login.dart' as login_route;
import '../routes/auth/signUp.dart' as signup_route;

Handler middleware(Handler handler) {
  return handler;
}

// Main function to start the Dart Frog server
void main() {
  // Start the Dart Frog server with the handler that defines routes
  serve(handler, '0.0.0.0', 8080);
}

Handler handler = Pipeline()
    .addMiddleware(middleware)
    .addHandler((context) async {
  final request = context.request;
  final path = request.uri.path;

  if (path == 'auth/login') {
    return login_route.onRequest(context);
  }

  if (path == 'auth/signup') {
    return signup_route.onRequest(context);
  }

  // fallback
  return Response.json(
    statusCode: 404,
    body: {'error': 'Route not found'},
  );
});
