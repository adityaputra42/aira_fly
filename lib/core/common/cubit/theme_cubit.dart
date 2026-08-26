import 'package:bloc/bloc.dart';

import '../../utils/pref_helper.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  /// Load theme saat aplikasi start
  Future<void> loadTheme() async {
    final isDark = PrefHelper.instance.getTheme();
    emit(isDark);
  }

  /// Toggle theme
  Future<void> toggleTheme() async {
    final newTheme = !state;
    PrefHelper.instance.setDarkTheme(newTheme);
    emit(newTheme);
  }
}
