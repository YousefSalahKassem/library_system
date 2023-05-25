import 'package:dart_frog/dart_frog.dart';
import 'package:library_system/config/mongo_client.dart';

Future<Response> onRequest(RequestContext context) {
  return MongoClient.startConnection(context, onRequestIndex(context));
}

Future<Response> onRequestIndex(RequestContext context) async {
  return Response(body: 'Welcome to Dart Frog!');
}
