import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final uri = context.request.uri;

  // Manually handle the /auth/login route
  if (uri.path == 'auth/login') {
    return Response.json(body: {'message': 'Login route accessed!'});
  }

  // You can add more manual route checks like this:
  if (uri.path == 'auth/signup') {
    return Response.json(body: {'message': 'Sign Up route accessed!'});
  }

  // Handle other routes or fallback
  return Response.json(body: {'message': 'Server is live'});
}
