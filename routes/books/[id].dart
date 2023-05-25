import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/books/service/book_service_impl.dart';


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
    final bookServiceImpl = context.read<BookServiceImpl>();

    final bookResponse = await bookServiceImpl.getBookById(id);

    if (bookResponse != null) {
      return Response.json(
        body: bookResponse.toMap(),
      );
    } else {
      return Response.json(body: {
        'message': 'Book not Found',
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
    final bookServiceImpl = context.read<BookServiceImpl>();
    await bookServiceImpl.deleteBook(id);
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

