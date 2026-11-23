import 'dart:convert';

import 'package:http/http.dart' as http;

import 'data.dart';
import 'models.dart';
import 'strings.dart';

class DaliliApi {
  static const baseUrl = 'http://10.0.2.2:8000';

  static Map<String, dynamic> decodeResponse(http.Response response) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is Map<String, dynamic>) return decoded;
    throw const FormatException('Expected a JSON object from the API.');
  }

  Future<Answer> ask(String question, String lang) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final normalizedQuestion = question.toLowerCase();
    final notFound =
        normalizedQuestion.contains('meteo') ||
        normalizedQuestion.contains('météo') ||
        normalizedQuestion.contains('weather');
    final source = sampleSourceFor(lang);
    final payload = notFound
        ? <String, dynamic>{
            'found': false,
            'answer': '',
            'sources': <Map<String, Object>>[],
          }
        : <String, dynamic>{
            'found': true,
            'answer':
                [
                      textFor(lang, 'demoStep1'),
                      textFor(lang, 'demoStep2'),
                      textFor(lang, 'demoStep3'),
                    ]
                    .asMap()
                    .entries
                    .map((entry) => '${entry.key + 1}. ${entry.value}')
                    .join('\n'),
            'sources': [
              {'file': source.file, 'page': source.page},
            ],
          };

    return Answer.fromJson(payload);
  }
}
