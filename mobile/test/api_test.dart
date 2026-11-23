import 'dart:convert';

import 'package:dalili_app/api.dart';
import 'package:dalili_app/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('DaliliApi', () {
    final api = DaliliApi();

    test('returns a sample answer with a source reference', () async {
      final answer = await api.ask('transcript', 'fr');

      expect(answer.found, isTrue);
      expect(answer.answer.split('\n'), hasLength(3));
      expect(answer.sources, hasLength(1));
      expect(answer.sources.single.page, 12);
      expect(answer.sources.single.file, contains('guide'));
    });

    test('returns no answer for weather questions', () async {
      final answer = await api.ask('weather tomorrow', 'en');

      expect(answer.found, isFalse);
      expect(answer.answer, isEmpty);
      expect(answer.sources, isEmpty);
    });

    test('decodes UTF-8 response bytes', () {
      final response = http.Response.bytes(
        utf8.encode('{"answer":"démarche"}'),
        200,
      );

      expect(DaliliApi.decodeResponse(response)['answer'], 'démarche');
    });

    test('parses missing and malformed fields safely', () {
      final answer = Answer.fromJson({
        'found': null,
        'answer': null,
        'sources': [
          {'file': 'guide.pdf', 'page': '12'},
          {'file': 'valid.pdf', 'page': 4},
          null,
        ],
      });

      expect(answer.found, isFalse);
      expect(answer.answer, isEmpty);
      expect(answer.sources, hasLength(1));
      expect(answer.sources.single.file, 'valid.pdf');
    });
  });
}
