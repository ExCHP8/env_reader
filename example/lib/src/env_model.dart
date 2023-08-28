// Auto-generated by Env Reader
// Generated @ 2023-08-28 13:36:33.840264
// 🍔 [Buy me a coffee](https://www.buymeacoffee.com/nialixus) 🚀
import 'package:env_reader/env_reader.dart';

/// Auto-generated environment model class.
///
/// This class represents environment variables parsed from the .env file.
/// Each static variable corresponds to an environment variable,
/// with default values provided for safety
/// `false` for [bool], `0` for [int], `0.0` for [double] and `VARIABLE_NAME` for [String].
class EnvModel {
  /// Value of `MY_STRING` in environment variable. This is equal to
  /// ```dart
  /// Env.read<String>('MY_STRING') ?? "MY_STRING";
  /// ```
  static String myString = Env.read<String>('MY_STRING') ?? "MY_STRING";

  /// Value of `MY_INT` in environment variable. This is equal to
  /// ```dart
  /// Env.read<int>('MY_INT') ?? 0;
  /// ```
  static int myInt = Env.read<int>('MY_INT') ?? 0;

  /// Value of `MY_BOOL` in environment variable. This is equal to
  /// ```dart
  /// Env.read<bool>('MY_BOOL') ?? false;
  /// ```
  static bool myBool = Env.read<bool>('MY_BOOL') ?? false;

  /// Value of `MY_DOUBLE` in environment variable. This is equal to
  /// ```dart
  /// Env.read<double>('MY_DOUBLE') ?? 0.0;
  /// ```
  static double myDouble = Env.read<double>('MY_DOUBLE') ?? 0.0;

  /// Value of `API_KEY` in environment variable. This is equal to
  /// ```dart
  /// Env.read<String>('API_KEY') ?? "API_KEY";
  /// ```
  static String apiKey = Env.read<String>('API_KEY') ?? "API_KEY";

  /// Value of `DEBUG` in environment variable. This is equal to
  /// ```dart
  /// Env.read<bool>('DEBUG') ?? false;
  /// ```
  static bool debug = Env.read<bool>('DEBUG') ?? false;

  /// Value of `PORT` in environment variable. This is equal to
  /// ```dart
  /// Env.read<int>('PORT') ?? 0;
  /// ```
  static int port = Env.read<int>('PORT') ?? 0;

  /// Value of `DATABASE_URL` in environment variable. This is equal to
  /// ```dart
  /// Env.read<String>('DATABASE_URL') ?? "DATABASE_URL";
  /// ```
  static String databaseUrl =
      Env.read<String>('DATABASE_URL') ?? "DATABASE_URL";
}