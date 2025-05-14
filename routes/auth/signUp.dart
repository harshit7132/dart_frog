import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import '../../lib/user_store.dart';

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

  // Initialize PostgreSQL connection
  final userStore = UserStore(PostgreSQLConnection('localhost', 5432, 'dartfrogdb', username: 'dartfroguser', password: 'password123'));
  await userStore.openConnection();

  // Check if the user already exists
  final userCreated = await userStore.addUser(email.toString(), password.toString(), role.toString());

  if (!userCreated) {
    await userStore.closeConnection();
    return Response.json(
      statusCode: 409,
      body: {'error': 'User already exists'},
    );
  }

  // Check if there's already an admin
  if (role.toLowerCase() == 'admin') {
    final isAdminExists = await userStore.checkAdmins();
    if (isAdminExists) {
      await userStore.closeConnection();
      return Response.json(
        statusCode: 409,
        body: {'error': 'One admin already exists'},
      );
    }
  }

  await userStore.closeConnection();
  return Response.json(body: {'message': 'User registered successfully'});
}
