import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _languages = <String, String>{
    'fr': 'french',
    'ar': 'arabic',
    'en': 'english',
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DaliliAppState>();
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
      children: [
        ScreenHeading(
          title: tr(context, 'profileTitle'),
          subtitle: tr(context, 'profileSubtitle'),
        ),
        const SizedBox(height: 18),
        Text(
          tr(context, 'language'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.languageCode,
                isExpanded: true,
                items: _languages.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(tr(context, entry.value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) unawaited(state.setLanguage(value));
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          tr(context, 'appearance'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
              avatar: const Icon(Icons.light_mode_outlined, size: 18),
              label: Text(tr(context, 'lightTheme')),
              selected: state.themeMode == ThemeMode.light,
              onSelected: (_) => unawaited(state.setThemeMode(ThemeMode.light)),
            ),
            ChoiceChip(
              avatar: const Icon(Icons.dark_mode_outlined, size: 18),
              label: Text(tr(context, 'darkTheme')),
              selected: state.themeMode == ThemeMode.dark,
              onSelected: (_) => unawaited(state.setThemeMode(ThemeMode.dark)),
            ),
          ],
        ),
      ],
    );
  }
}
