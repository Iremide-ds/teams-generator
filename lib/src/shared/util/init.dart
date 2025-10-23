import 'package:firebase_core/firebase_core.dart';
import 'package:teams_gen/firebase_options.dart';
import 'package:teams_gen/src/core/service/data_cache.dart';

initServices() {}

Future<FirebaseApp> initFirebaseCore() {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<DatabaseManager> initDB() async {
  return await DatabaseManager.getInstance();
}
