import 'package:bloc/bloc.dart';

import '../../utils/secure_storage_helper.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  Future<void> loadTheme() async {
    final isDark = await SecureStorageHelper.instance.getTheme();
    emit(isDark);
  }

  Future<void> toggleTheme(bool value) async {
    await SecureStorageHelper.instance.setDarkTheme(value);
    emit(value);
  }
}
