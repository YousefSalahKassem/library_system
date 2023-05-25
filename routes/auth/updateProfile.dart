import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/users/models/create_user_request.dart';
import 'package:library_system/src/users/models/login_request.dart';
import 'package:library_system/src/users/service/user_service_impl.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return MongoClient.startConnection(context, _updateProfile(context));
    case HttpMethod.get:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _updateProfile(RequestContext context) async {
  try {
    final userServiceImpl = context.read<UserServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
        final authorizationHeader =
        context.request.headers[HttpHeaders.authorizationHeader];
    final token = authorizationHeader?.split('Bearer ')[1];
    final userResponse = await userServiceImpl.getUserProfile(token!);
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }
    final user = await userServiceImpl.getUserProfile(token);
    final userUpdated = await userServiceImpl.updateUser(
      user?.id.$oid??'',
       CreateUserReq(
        name: requestJson['name'].toString(),
        email: user?.email??'',
        password: user?.password??'',
        token: user?.token??'',
        ));

    return Response.json(
      body: userUpdated.toMap()..remove('password')..remove('token'),
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
