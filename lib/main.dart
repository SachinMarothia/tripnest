import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripmate/app/app.dart';
import 'package:tripmate/firebase_options.dart';
import 'package:tripmate/injection_container.dart';

import 'app/theme/theme_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initializeDependencies();

  final themeCubit = sl<ThemeCubit>();

  await themeCubit.loadTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(create: (_) => sl<AuthBloc>()),
      ],
      child: const TripMateApp(),
    ),
  );
}
