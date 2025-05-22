// ignore_for_file: prefer_const_constructors

import 'package:dart_frog/dart_frog.dart';

import '../routes/auth/login.dart' as login_route;
import '../routes/auth/signUp.dart' as signup_route;
import '../routes/index.dart' as index_route;

///we need to pass the routes to all the dart files or pages so when we live our api on render or on any free platform like : render.com_url/auth/login or signup
///dart frog have auth navigate feature which will only use in local host when we live the api it does not use automatic navigation feature 
///so, we need to define manually not to depend on dart frog 


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

  ///the below code is to define routes because dart frog's auto navigation feature is not working when we live api on render.com
  if (path == '/') {
    return index_route.onRequest(context);
  }

  if (path == '/auth/login') {
    return login_route.onRequest(context);
  }

  if (path == '/auth/signup') {
    return signup_route.onRequest(context);
  }

  // fallback
  return Response.json(
    statusCode: 404,
    body: {'error': 'Route not found'},
  );
});
