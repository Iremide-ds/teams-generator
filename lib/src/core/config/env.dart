import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true, path: '.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseURL = _Env.supabaseURL;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _Env.supabaseAnonKey;
}
