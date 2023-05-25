import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/category/service/categpry_service_impl.dart';
import 'package:library_system/src/users/models/login_request.dart';
import 'package:library_system/src/users/service/user_service_impl.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getById(context, id));
    case HttpMethod.delete:
      return MongoClient.startConnection(context, _deleteById(context, id));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getById(RequestContext context, String id) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();

    final categoryResponse = await categoryServiceImpl.getCategoryById(id);

    if (categoryResponse != null) {
      return Response.json(
        body: categoryResponse.toMap(),
      );
    } else {
      return Response.json(body: {
        'message': 'Category not Found',
      },
      );
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

Future<Response> _deleteById(RequestContext context, String id) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();
    await categoryServiceImpl.removeCategory(id);
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
