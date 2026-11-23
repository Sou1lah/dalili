import 'package:material_ui/material_ui.dart';

import 'models.dart';

class ProcedureSample {
  const ProcedureSample({
    required this.id,
    required this.titleKey,
    required this.icon,
  });

  final String id;
  final String titleKey;
  final IconData icon;

  List<String> get stepKeys => const ['demoStep1', 'demoStep2', 'demoStep3'];
}

class SampleDocument {
  const SampleDocument({required this.titleKey, required this.source});

  final String titleKey;
  final SourceRef source;
}

const procedures = <ProcedureSample>[
  ProcedureSample(
    id: 'certificate',
    titleKey: 'certificate',
    icon: Icons.verified_outlined,
  ),
  ProcedureSample(
    id: 'transcript',
    titleKey: 'transcript',
    icon: Icons.article_outlined,
  ),
  ProcedureSample(
    id: 'reregistration',
    titleKey: 'reregistration',
    icon: Icons.autorenew_rounded,
  ),
  ProcedureSample(
    id: 'scholarship',
    titleKey: 'scholarship',
    icon: Icons.account_balance_wallet_outlined,
  ),
  ProcedureSample(
    id: 'housing',
    titleKey: 'housing',
    icon: Icons.apartment_rounded,
  ),
  ProcedureSample(id: 'appeal', titleKey: 'appeal', icon: Icons.gavel_outlined),
];

SourceRef sampleSourceFor(String languageCode) => SourceRef(
  file: switch (languageCode) {
    'ar' => 'مثال — دليل الطالب (للعرض فقط).pdf',
    'en' => 'SAMPLE — student guide (demo only).pdf',
    _ => 'EXEMPLE — guide étudiant (démo).pdf',
  },
  page: 12,
);

List<SampleDocument> sampleDocumentsFor(String languageCode) => [
  SampleDocument(
    titleKey: 'sourceGuideTitle',
    source: sampleSourceFor(languageCode),
  ),
  SampleDocument(
    titleKey: 'sourceChecklistTitle',
    source: SourceRef(
      file: switch (languageCode) {
        'ar' => 'مثال — قائمة الإدارة (افتراضية).pdf',
        'en' => 'SAMPLE — administration checklist (fictional).pdf',
        _ => 'EXEMPLE — liste administrative (fictive).pdf',
      },
      page: 4,
    ),
  ),
  SampleDocument(
    titleKey: 'sourceCalendarTitle',
    source: SourceRef(
      file: switch (languageCode) {
        'ar' => 'مثال — التقويم الطلابي (افتراضي).pdf',
        'en' => 'SAMPLE — student calendar (fictional).pdf',
        _ => 'EXEMPLE — calendrier étudiant (fictif).pdf',
      },
      page: 27,
    ),
  ),
];
