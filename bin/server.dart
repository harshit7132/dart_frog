import 'package:dart_frog/dart_frog.dart';
import 'dart:io';

void main() async {
  final server = await serve(
    // Dart Frog will automatically find the routes in lib/routes
    (context) async {
      return Response(statusCode: 200, body: 'Server is live');
    },
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8080'),
  );

  print('Server running on http://${server.address.host}:${server.port}');
}
