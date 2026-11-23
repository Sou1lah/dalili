import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../data.dart';
import '../widgets.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DaliliAppState>();
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
      children: [
        ScreenHeading(
          title: tr(context, 'trackerTitle'),
          subtitle: tr(context, 'trackerSubtitle'),
        ),
        const SizedBox(height: 16),
        const SampleNotice(),
        const SizedBox(height: 12),
        for (final procedure in procedures)
          _ProcedureProgressCard(procedure: procedure, state: state),
      ],
    );
  }
}

class _ProcedureProgressCard extends StatelessWidget {
  const _ProcedureProgressCard({required this.procedure, required this.state});

  final ProcedureSample procedure;
  final DaliliAppState state;

  @override
  Widget build(BuildContext context) {
    final steps = procedure.stepKeys;
    final completed = state.completedCount(procedure.id, steps.length);
    final progress = completed / steps.length;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr(context, procedure.titleKey),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text('${(progress * 100).round()}% ${tr(context, 'ready')}'),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress, minHeight: 6),
            const SizedBox(height: 8),
            for (var index = 0; index < steps.length; index++)
              InkWell(
                onTap: () => state.setStepComplete(
                  procedure.id,
                  index,
                  !state.isStepComplete(procedure.id, index),
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Checkbox(
                        value: state.isStepComplete(procedure.id, index),
                        onChanged: (value) => state.setStepComplete(
                          procedure.id,
                          index,
                          value ?? false,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tr(context, steps[index]),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
