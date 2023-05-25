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
      return MongoClient.startConnection(context, _getCategoryByName(context));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getCategoryByName(RequestContext context) async {
  try {
    final categoryServiceImpl = context.read<CategoryServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;

    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final categoryResponse = await categoryServiceImpl
        .getCategoryByName(requestJson['title'].toString());

    print(requestJson['title'].toString());
    if (categoryResponse != null) {
      return Response.json(
        body: categoryResponse.toMap(),
      );
    } else {
      return Response(
          statusCode: HttpStatus.notFound, body: "Category Not Found");
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
