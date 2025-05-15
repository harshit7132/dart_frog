

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:postgres/postgres.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

// Future<Response> onRequest(RequestContext context) async {
//   if (context.request.method != HttpMethod.post) {
//     return Response.json(
//       statusCode: 405,
//       body: {'error': 'Method Not Allowed'},
//     );
//   }

//   final body = await context.request.body();
//   final data = jsonDecode(body);

//   final email = data['email'];
//   final password = data['password'];

//   if (email == null || password == null) {
//     return Response.json(
//       statusCode: 400,
//       body: {'error': 'Email and password are required'},
//     );
//   }

//   // Connect to PostgreSQL
//   final connection = PostgreSQLConnection(
//     'localhost', 5432, 'user_management',
//     username: 'luffy7132',
//     password: 'password7132',
//   );

//   try {
//     await connection.open();

//     final results = await connection.query(
//       'SELECT s_no, role FROM users WHERE email = @e AND password = @p',
//       substitutionValues: {
//         'e': email,
//         'p': password,
//       },
//     );

//     await connection.close();

//     if (results.isEmpty) {
//       return Response.json(
//         statusCode: 401,
//         body: {'error': 'Invalid email or password'},
//       );
//     }

//     final user = results.first;
//     final userId = user[0];
//     final role = user[1];

//     // Generate JWT token
//     final jwt = JWT(
//       {
//         'id': userId,
//         'email': email,
//         'role': role,
//       },
//       issuer: 'luffy-7132',
//     );

//     final token = jwt.sign(SecretKey('your-secret-key'));

//     return Response.json(
//       body: {
//         'message': 'Login successful',
//         'token': token,
//       },
//     );
//   } catch (e) {
//     return Response.json(
//       statusCode: 500,
//       body: {'error': 'Database error', 'details': e.toString()},
//     );
//   }
// }


import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_api/db.dart';
import 'package:postgres/postgres.dart'; 

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(statusCode: 405, body: {'error': 'Method Not Allowed'});
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

  final conn = await Database.getConnection();

  final results = await conn.query(
    'SELECT id, email, password, role FROM users WHERE email = @email',
    substitutionValues: {'email': email},
  );

  if (results.isEmpty) {
    return Response.json(statusCode: 401, body: {'error': 'Invalid credentials'});
  }

  final row = results.first;
  final storedPassword = row[2] as String;

  // You should hash and verify password properly here!
  if (password != storedPassword) {
    return Response.json(statusCode: 401, body: {'error': 'Invalid credentials'});
  }

  // Generate JWT token
  final jwt = JWT(
    {
      'id': row[0],
      'email': row[1],
      'role': row[3],
    },
    issuer: 'your.app',
  );

  final token = jwt.sign(SecretKey('your-very-secret-key'), expiresIn: Duration(hours: 24));

  return Response.json(
    body: {
      'message': 'Login successful',
      'token': token,
    },
  );
}
