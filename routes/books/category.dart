import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/books/service/book_service_impl.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return MongoClient.startConnection(context, _getBookByCategory(context));
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getBookByCategory(RequestContext context) async {
  try {
    final bookServiceImpl = context.read<BookServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;

    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final categoryResponse = await bookServiceImpl
        .searchByCategory(requestJson['name'].toString());

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
