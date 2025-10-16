import 'package:teams_gen/src/core/service/data_cache.dart';

initServices() {}

Future<DatabaseManager> initDB() async {
  return await DatabaseManager.getInstance();
}
