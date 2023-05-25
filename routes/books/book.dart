import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';
import 'package:library_system/src/books/models/book.dart';
import 'package:library_system/src/books/service/book_service_impl.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  switch (context.request.method) {
    case HttpMethod.delete:
      return MongoClient.startConnection(context, _getBooks(context));
    case HttpMethod.post:
      return MongoClient.startConnection(context, _addBook(context));
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
    
    case HttpMethod.get:

      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getBooks(RequestContext context) async {
  try {
    final bookServiceImpl = context.read<BookServiceImpl>();

    final bookResponse = await bookServiceImpl.getAllBooks();

    return Response.json(
      body: bookResponse.map((e) => e.toMap()).toList(),
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

Future<Response> _addBook(RequestContext context) async {
  try {
    final bookServiceImpl = context.read<BookServiceImpl>();
    final requestJson = await context.request.json() as Map<String, dynamic>?;
    if (requestJson == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final bookRequest = Book.fromMap(requestJson);
    final bookResponse = await bookServiceImpl.addBook(bookRequest);
    return Response.json(body: bookResponse.toMap());
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'message': e.toString(),
      },
    );
  }
}
