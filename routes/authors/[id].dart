import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/authors/service/author_service_impl.dart';
import 'package:library_system/src/category/service/categpry_service_impl.dart';


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
    final authorServiceImpl = context.read<AuthorServiceImpl>();

    final authorResponse = await authorServiceImpl.getAuthorById(id);

    if (authorResponse != null) {
      return Response.json(
        body: authorResponse.toMap(),
      );
    } else {
      return Response.json(body: {
        'message': 'Author not Found',
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
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    await authorServiceImpl.removeAuthor(id);
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
