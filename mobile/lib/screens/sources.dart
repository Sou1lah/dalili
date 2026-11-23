import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../data.dart';
import '../widgets.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<DaliliAppState>().languageCode;
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
      children: [
        ScreenHeading(
          title: tr(context, 'sourceTitle'),
          subtitle: tr(context, 'sourcesSubtitle'),
        ),
        const SizedBox(height: 16),
        const SampleNotice(),
        const SizedBox(height: 14),
        for (final document in sampleDocumentsFor(languageCode))
          Card(
            margin: const EdgeInsetsDirectional.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder_copy_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tr(context, document.titleKey),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SourceChip(source: document.source),
                ],
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          tr(context, 'sourceDisclaimer'),
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
