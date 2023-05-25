import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/category/models/category.dart';
import 'package:library_system/src/category/service/categpry_service_impl.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getCategories(context));
    case HttpMethod.post:
      return MongoClient.startConnection(context, _addCategory(context));

    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getCategories(RequestContext context) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();

    final categoryResponse = await categoryServiceImpl.getAllCategories();

    return Response.json(
      body: categoryResponse.map((e) => e.toMap()).toList(),
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

Future<Response> _addCategory(RequestContext context) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final categoryRequest = Category.fromMap(requestJson);
    final categoryResponse = await categoryServiceImpl.addCategory(categoryRequest);
    return Response.json(body: categoryResponse.toMap());
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
