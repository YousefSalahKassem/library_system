import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/authors/models/author.dart';
import 'package:library_system/src/authors/service/author_service_impl.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getAuthors(context));
    case HttpMethod.post:
      return MongoClient.startConnection(context, _addAuthor(context));

    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getAuthors(RequestContext context) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();

    final authorResponse = await authorServiceImpl.getAllAuthors();

    return Response.json(
      body: authorResponse.map((e) => e.toMap()).toList(),
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

Future<Response> _addAuthor(RequestContext context) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final authorRequest = Author.fromMap(requestJson);
    final authorResponse = await authorServiceImpl.addAuthor(authorRequest);
    return Response.json(body: authorResponse.toMap());
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
