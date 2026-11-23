import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'data.dart';
import 'models.dart';
import 'strings.dart';

String tr(BuildContext context, String key) =>
    textFor(context.read<DaliliAppState>().languageCode, key);

class ScreenHeading extends StatelessWidget {
  const ScreenHeading({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ],
  );
}

class SampleNotice extends StatelessWidget {
  const SampleNotice({super.key});

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: Padding(
      padding: const EdgeInsetsDirectional.all(14),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tr(context, 'sampleLabel'),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SourceChip extends StatelessWidget {
  const SourceChip({required this.source, super.key});

  final SourceRef source;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: const Icon(Icons.description_outlined, size: 18),
    label: Text(
      '${source.file} · ${tr(context, 'pageShort')} ${source.page}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    visualDensity: VisualDensity.compact,
  );
}

class VerificationNote extends StatelessWidget {
  const VerificationNote({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsetsDirectional.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      borderRadius: BorderRadiusDirectional.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.fact_check_outlined,
          size: 19,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tr(context, 'verifyNote'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        ),
      ],
    ),
  );
}

class ProcedureTile extends StatelessWidget {
  const ProcedureTile({required this.procedure, super.key});

  final ProcedureSample procedure;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadiusDirectional.circular(14),
              ),
              child: Icon(procedure.icon, color: colors.primary),
            ),
            const Spacer(),
            Text(
              tr(context, procedure.titleKey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              tr(context, 'sample'),
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class DirectionalIcon extends StatelessWidget {
  const DirectionalIcon(this.icon, {this.size = 22, super.key});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) => Transform.flip(
    flipX: Directionality.of(context) == TextDirection.rtl,
    child: Icon(icon, size: size),
  );
}
