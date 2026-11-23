import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens/shell.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await DaliliAppState.restore();
  runApp(
    ChangeNotifierProvider.value(value: appState, child: const DaliliApp()),
  );
}

class DaliliApp extends StatelessWidget {
  const DaliliApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DaliliAppState>();
    final textDirection = state.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    return MaterialApp(
      title: 'Dalili.dz',
      debugShowCheckedModeBanner: false,
      locale: Locale(state.languageCode),
      supportedLocales: const [Locale('fr'), Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(
        textDirection: textDirection,
        child: child ?? const SizedBox.shrink(),
      ),
      theme: DaliliTheme.light,
      darkTheme: DaliliTheme.dark,
      themeMode: state.themeMode,
      home: const ShellScreen(),
    );
  }
}
