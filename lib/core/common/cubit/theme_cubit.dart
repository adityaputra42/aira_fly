import 'package:bloc/bloc.dart';

import '../../utils/pref_helper.dart';

class ThemeCubit extends Cubit<bool> {
  final PrefHelper pref;
  ThemeCubit({required this.pref}) : super(false);

  /// Load theme saat aplikasi start
  Future<void> loadTheme() async {
    final isDark = pref.getTheme();
    emit(isDark);
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    final newTheme = !state;
    await pref.setDarkTheme(newTheme);
    emit(newTheme);
  }
}
