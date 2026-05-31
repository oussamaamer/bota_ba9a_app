import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await initDependencies();

  // Initialize Supabase (uncomment when credentials are ready)
  // await Supabase.initialize(
  //   url: AppConstants.supabaseUrl,
  //   anonKey: AppConstants.supabaseAnonKey,
  // );

  // Initialize Hive (uncomment for offline cache - Phase 3)
  // await Hive.initFlutter();

  runApp(const BotabaApp());
}
