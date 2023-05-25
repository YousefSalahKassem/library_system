import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/authors/service/author_service_impl.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getAuthorByName(context));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getAuthorByName(RequestContext context) async {
  try {
    final authorServiceImpl = context.read<AuthorServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;

    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final authorResponse = await authorServiceImpl
        .getAuthorByName(requestJson['name'].toString());

    print(requestJson['name'].toString());
    if (authorResponse != null) {
      return Response.json(
        body: authorResponse.toMap(),
      );
    } else {
      return Response(
          statusCode: HttpStatus.notFound, body: "Author Not Found");
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
