import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teams_gen/firebase_options.dart';
import 'package:teams_gen/src/core/config/env.dart';
import 'package:teams_gen/src/core/service/data_cache.dart';

initServices() {}

Future<FirebaseApp> initFirebaseCore() {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<Supabase> initSupabase({bool debugMode = false}) {
  return Supabase.initialize(
    url: Env.supabaseURL,
    anonKey: Env.supabaseAnonKey,
    debug: debugMode,
  );
}

Future<DatabaseManager> initDB() async {
  return await DatabaseManager.getInstance();
}
