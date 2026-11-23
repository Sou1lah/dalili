import 'package:material_ui/material_ui.dart';

import '../data.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
    children: [
      ScreenHeading(
        title: tr(context, 'welcome'),
        subtitle: tr(context, 'homeSubtitle'),
      ),
      const SizedBox(height: 16),
      const SampleNotice(),
      const SizedBox(height: 18),
      Text(
        tr(context, 'procedures'),
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: procedures.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 142,
        ),
        itemBuilder: (context, index) =>
            ProcedureTile(procedure: procedures[index]),
      ),
    ],
  );
}
