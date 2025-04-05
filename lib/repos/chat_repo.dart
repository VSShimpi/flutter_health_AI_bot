import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:health_bot/models/chat_message_model.dart';
import 'package:health_bot/utils/constants.dart';

class HealthRepo {
  static Future<String> chatTextGenerationRepo(
      List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();

      final response = await dio.post(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${API_KEY}",
          data: {
            "contents": previousMessages.map((e) => e.toMap()).toList(),
            "systemInstruction": {
              "role": "user",
              "parts": [
                {"text": "Give me Some Suggestion for Improve focus in short"}
              ]
            },
            "generationConfig": {
              "temperature": 0.9,
              "topK": 40,
              "topP": 1,
              "maxOutputTokens": 8190,
              "responseMimeType": "text/plain"
            }
          });

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response
            .data['candidates'].first['content']['parts'].first['text'];
      }
      return '';
    } catch (e) {
      log(e.toString());
    }
    return '';
  }
}
