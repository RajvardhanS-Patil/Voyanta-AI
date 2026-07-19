import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiClientManager {
  static late final GenerativeModel model;

  static void initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing GEMINI_API_KEY in .env file');
    }

    model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }
}
