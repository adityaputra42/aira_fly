import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'init_dependencies.dart';
import 'core/common/cubit/theme_cubit.dart';
import 'features/main/ui/cubit/main_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<MainCubit>()),
        BlocProvider(create: (context) => serviceLocator<ThemeCubit>()..loadTheme()),
      ],
      child: const App(),
    ),
  );
}
