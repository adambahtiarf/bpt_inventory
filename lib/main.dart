import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/constant/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Constants.kbURL,
    anonKey: Constants.kbAnonKey,
  );
  await _runApp();
}

Future<void> _runApp() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const App());
}

final kLogger = Logger();
final kGIns = GetIt.instance;
