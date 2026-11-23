class SourceRef {
  const SourceRef({required this.file, required this.page});

  final String file;
  final int page;
}

class Answer {
  const Answer({
    required this.found,
    required this.answer,
    required this.sources,
  });

  final bool found;
  final String answer;
  final List<SourceRef> sources;

  factory Answer.fromJson(Map<String, dynamic> json) {
    final rawSources = json['sources'];
    final sources = <SourceRef>[];

    if (rawSources is List) {
      for (final item in rawSources) {
        if (item is! Map) continue;
        final file = item['file'];
        final page = item['page'];
        if (file is String && page is num) {
          sources.add(SourceRef(file: file, page: page.toInt()));
        }
      }
    }

    return Answer(
      found: json['found'] == true,
      answer: json['answer'] is String ? json['answer'] as String : '',
      sources: List.unmodifiable(sources),
    );
  }
}
