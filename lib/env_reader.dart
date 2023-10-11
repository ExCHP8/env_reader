/// A simple utility for reading and parsing environment variables from a .env file.
///
/// This library provides a way to load environment variables from a .env file
/// and parse them into a map, allowing you to easily access environment values
/// in your Flutter application.
///
/// Example:
/// ```dart
/// // Loading env data
/// String asset = await rootBundle.loadString('assets/env/.env');
/// await Env.load(EnvLoader.string(asset), 'MySecretKey');
///
/// // Using env data
/// String? api = Env.read<String>("API_KEY");
/// int port = Env.read<int>("PORT") ?? 8080;
/// bool isDebug = Env.read<bool>("DEBUG") ?? false;
/// ```
library env_reader;

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:encryptor/encryptor.dart';
import 'package:http/http.dart';
import 'package:universal_file/universal_file.dart';

part 'src/env_loader.dart';

/// A utility class for reading environment variables from .env source.
class Env {
  /// The instance of [EnvReader] used to read environment variables.
  static EnvReader instance = EnvReader();

  /// Loads environment variables from .env source.
  ///
  /// The [source] parameter specifies where's the .env took place.
  ///
  /// ```dart
  /// String asset = await rootBundle.loadString('assets/env/.env');
  /// await Env.load(EnvLoader.string(asset), 'MySecretKey');
  /// ```
  static Future<void> load(EnvLoader source, [String? key]) =>
      instance.load(source, key);

  /// Reads an environment variable value of type [T] from the loaded environment.
  ///
  /// Returns the value associated with the specified [key], or `null` if the key
  /// is not found or there was an error while reading the environment.
  ///
  /// ```dart
  /// // example
  /// String? api = Env.read("API_KEY");
  /// int port = Env.read<int>("PORT") ?? 8080;
  /// ```
  static T? read<T extends Object>(String key) => instance.read<T>(key);
}

/// A class for loading and parsing environment variables from .env source.
class EnvReader {
  /// Decrypted value of its loaded environment configuration.
  ///
  /// ```dart
  /// String? env = EnvReader().value;
  /// ```
  String? value;

  /// Loads environment variables from .env source.
  ///
  /// The [source] parameter specifies where's the .env file took place.
  ///
  ///  ```dart
  /// String asset = await rootBundle.loadString('assets/env/.env');
  /// await Env.load(EnvLoader.string(asset), 'MySecretKey');
  /// ```
  Future<void> load(EnvLoader source, [String? key]) async {
    try {
      if (source is EnvFileLoader) {
        String data = await (source.source).readAsString();
        value = key != null ? Encryptor.decrypt(key, data) : data;
      } else if (source is EnvMemoryLoader) {
        String data = String.fromCharCodes(source.source);
        value = key != null ? Encryptor.decrypt(key, data) : data;
      } else if (source is EnvNetworkLoader) {
        Response response = await get(source.source);
        value =
            key != null ? Encryptor.decrypt(key, response.body) : response.body;
      } else {
        value = key != null
            ? Encryptor.decrypt(key, source.source.toString())
            : source.source.toString();
      }
    } catch (e) {
      log("\n\n\u001b[1m[ENV_READER]\u001b[31m 💥 Unable to load data\u001b[0m 💥\n$e\n\n");
    }
  }

  /// Parses environment variables into a json structured map.
  ///
  /// ```dart
  /// Map<String, dynamic> json = Env.instance.toJson();
  /// ```
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    final lines = (value ?? "").trim().split('\n');

    for (final line in lines) {
      if (line.trim().startsWith('#')) {
        continue;
      }

      try {
        final parts = line.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();

          if (int.tryParse(value) != null) {
            data[key] = int.parse(value);
          } else if (double.tryParse(value) != null) {
            data[key] = double.parse(value);
          } else if (value == 'true' || value == 'false') {
            data[key] = value == 'true';
          } else {
            data[key] = value;
          }
        }
      } catch (e) {
        log("\n\n\u001b[1m[ENV_READER]\u001b[31m 💥 Parsing failed\u001b[0m 💥\n$e\n\n");
      }
    }
    return data;
  }

  /// Reads an environment variable value of type [T] from the loaded environment.
  ///
  /// Returns the value associated with the specified [key], or `null` if the key
  /// is not found or there was an error while reading the environment.
  ///
  /// ```dart
  /// // example
  /// final env = EnvReader();
  /// String? api = env.read("API_KEY");
  /// int port = env.read<int>("PORT") ?? 8080;
  /// ```
  T? read<T extends Object>(String key) {
    try {
      return toJson()[key];
    } catch (e) {
      return null;
    }
  }
}
