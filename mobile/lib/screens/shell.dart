import 'package:material_ui/material_ui.dart';

import '../widgets.dart';
import 'ask.dart';
import 'home.dart';
import 'profile.dart';
import 'sources.dart';
import 'tracker.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    SourcesScreen(),
    AskScreen(),
    TrackerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _selectedIndex, children: _screens),
    bottomNavigationBar: _BottomTabs(
      selectedIndex: _selectedIndex,
      onSelected: (index) => setState(() => _selectedIndex = index),
    ),
  );
}

class _BottomTabs extends StatelessWidget {
  const _BottomTabs({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _icons = <IconData>[
    Icons.home_outlined,
    Icons.library_books_outlined,
    Icons.auto_awesome_rounded,
    Icons.checklist_rounded,
    Icons.person_outline_rounded,
  ];
  static const _labels = <String>[
    'home',
    'sources',
    'ask',
    'tracker',
    'profile',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 6, 0),
          child: Row(
            children: List<Widget>.generate(_labels.length, (index) {
              final selected = selectedIndex == index;
              final isAsk = index == 2;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelected(index),
                  child: SizedBox(
                    height: 64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isAsk)
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: 0.28),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(_icons[index], color: colors.onPrimary),
                          )
                        else
                          Icon(
                            _icons[index],
                            color: selected
                                ? colors.primary
                                : colors.onSurfaceVariant,
                            size: 22,
                          ),
                        const SizedBox(height: 2),
                        Text(
                          tr(context, _labels[index]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: selected || isAsk
                                    ? colors.primary
                                    : colors.onSurfaceVariant,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
