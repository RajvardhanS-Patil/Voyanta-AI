import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class GroqClientManager {
  static late final Dio dio;

  static void initialize() {
    final apiKey = dotenv.env['GROQ_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing GROQ_API_KEY in .env file');
    }

    dio = Dio(BaseOptions(
      baseUrl: 'https://api.groq.com/openai/v1',
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }
}
