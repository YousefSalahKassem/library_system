import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/users/models/login_request.dart';
import 'package:library_system/src/users/service/user_service_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, getUserByName(context));
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> getUserByName(RequestContext context) async {
  try {
    final userServiceImpl = context.read<UserServiceImpl>();
    final params = context.request.uri.queryParameters;
    var name = params['name'];
    final userResponse = await userServiceImpl.getUserByName(name!);

    if (userResponse != null) {
      return Response.json(
        body: userResponse
            .map((e) => e.toMap()
              ..remove('password')
              ..remove('token'))
            .toList(),
      );
    } else {
      return Response.json(statusCode: 404, body: {
        'message': 'User Not Found',
      });
    }
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
