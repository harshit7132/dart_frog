// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:postgres/postgres.dart';

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
//   final role = data['role'];

//   if (email == null || password == null || role == null) {
//     return Response.json(
//       statusCode: 400,
//       body: {'error': 'Email, password, and role are required'},
//     );
//   }

//   // Connect to PostgreSQL
//   final connection = PostgreSQLConnection(
//     'localhost', // or your DB host
//     5432, // default PostgreSQL port
//     'user_management',
//     username: 'luffy7132',
//     password: 'password7132',
//   );

//   try {
//     await connection.open();

//     await connection.query(
//   'INSERT INTO users (email, password, role) VALUES (@e, @p, @r)',
//   substitutionValues: {
//     'e': email,
//     'p': password,
//     'r': role,
//   },
// );


//     await connection.close();

//     return Response.json(
//       body: {'message': 'User registered successfully'},
//     );
//   } catch (e) {
//     return Response.json(
//       statusCode: 500,
//       body: {'error': 'Database error', 'details': e.toString()},
//     );
//   }
// }

import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:my_api/db.dart';
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
  final role = data['role'];

  if (email == null || password == null || role == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Email, password, and role are required'},
    );
  }

  try {
    final connection = await Database.getConnection();
 
    final hashedPassword = BCrypt.hashpw(password.toString(), BCrypt.gensalt());

    await connection.query(
      'INSERT INTO users (email, password, role) VALUES (@e, @p, @r)',
      substitutionValues: {'e': email, 'p': hashedPassword, 'r': role},
    );     

    return Response.json(body: {'message': 'User registered successfully'});
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Database error', 'details': e.toString()},
    );
  }
}
