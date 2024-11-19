import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class GPTService {
  static Future<String> sendMessage(String message) async {
    await dotenv.load();
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    final url = 'https://api.openai.com/v1/engines/davinci-codex/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = jsonEncode({
      'prompt': message,
      'max_tokens': 100,
      'n': 1,
      'stop': null,
      'temperature': 0.5
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to get response from GPT-4');
    }
  }
}
