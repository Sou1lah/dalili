import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaliliAppState extends ChangeNotifier {
  DaliliAppState._(this._preferences);

  static const _languageKey = 'language';
  static const _themeKey = 'theme';
  static const _completedStepsKey = 'completed_steps';

  final SharedPreferences _preferences;
  String _languageCode = 'fr';
  ThemeMode _themeMode = ThemeMode.light;
  final Set<String> _completedSteps = {};

  String get languageCode => _languageCode;
  ThemeMode get themeMode => _themeMode;

  static Future<DaliliAppState> restore() async {
    final preferences = await SharedPreferences.getInstance();
    final state = DaliliAppState._(preferences);
    state._languageCode = switch (preferences.getString(_languageKey)) {
      'ar' => 'ar',
      'en' => 'en',
      _ => 'fr',
    };
    state._themeMode = preferences.getString(_themeKey) == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    state._completedSteps.addAll(
      preferences.getStringList(_completedStepsKey) ?? const [],
    );
    return state;
  }

  Future<void> setLanguage(String languageCode) async {
    if (!const {'fr', 'ar', 'en'}.contains(languageCode) ||
        languageCode == _languageCode) {
      return;
    }
    _languageCode = languageCode;
    notifyListeners();
    await _preferences.setString(_languageKey, languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _preferences.setString(_themeKey, mode.name);
  }

  bool isStepComplete(String procedureId, int stepIndex) =>
      _completedSteps.contains('$procedureId:$stepIndex');

  int completedCount(String procedureId, int stepCount) => List<int>.generate(
    stepCount,
    (index) => index,
  ).where((index) => isStepComplete(procedureId, index)).length;

  Future<void> setStepComplete(
    String procedureId,
    int stepIndex,
    bool complete,
  ) async {
    final key = '$procedureId:$stepIndex';
    if (complete) {
      _completedSteps.add(key);
    } else {
      _completedSteps.remove(key);
    }
    notifyListeners();
    await _preferences.setStringList(
      _completedStepsKey,
      _completedSteps.toList(),
    );
  }
}
