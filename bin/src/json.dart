// ignore_for_file: avoid_print
part of '../env_reader.dart';

/// A function to generate dart model out of .env file
void insertJson({required ArgResults from}) {
  String? model = from["model"]?.toString();
  bool isFlutter = from["sdk"] == 'flutter';
  if (model != null) {
    // Fetching arguments
    String path = model.replaceAll(RegExp(r'/[^/]+$'), "/");
    String name = model
        .split("/")
        .last
        .split(".")
        .first
        .split("_")
        .map((e) => capitalize(e))
        .join("");
    String input = from["input"]!.toString();
    bool obfuscate = from['obfuscate'];
    String data = File(input).readAsStringSync();
    bool nullSafety = from["null-safety"];

    // Parsing .env toJson
    Map<String, dynamic> json = toJson(data);

    // Generating model
    String cast = json.entries.map((e) {
      Type type = e.value.runtimeType;
      String name = dartNamed(e.key);
      if (obfuscate) {
        String variable = nullSafety
            ? "Env.read<$type>('${e.key}') ?? ${type == bool ? 'false' : type == int ? '0' : type == double ? '0.0' : "'${e.key}'"}"
            : "Env.read<$type>('${e.key}')";

        return """
  /// Value of `${e.key}` in environment variable. This is equal to
  /// ```dart
  /// $variable;
  /// ```
  static $type${nullSafety ? "" : "?"} $name = $variable;
""";
      } else {
        return """
  /// Value of `${e.key}` in environment variable. This is equal to
  /// ```dart
  /// $type $name = Env.read<$type>('${e.key}') ?? ${type == bool ? 'false' : type == int ? '0' : type == double ? '0.0' : "'${e.key}'"};
  /// print($name); // ${e.value}
  /// ```
  static const $type $name = ${type == String ? "'${e.value}'" : e.value ?? 'e.key'};
""";
      }
    }).join("\n");
    String write = """
// Env Reader Auto-Generated Model File
// Created at ${DateTime.now()}
// 🍔 [Buy me a coffee](https://www.buymeacoffee.com/nialixus) 🚀
${obfuscate ? "import 'package:env_reader/env_reader${isFlutter ? '' : '_core'}.dart';\n" : ''}
${obfuscate ? "/// This class represents environment variables parsed from the .env file.\n/// Each static variable corresponds to an environment variable,${nullSafety ? "\n/// with default values provided for safety\n/// `false` for [bool], `0` for [int], `0.0` for [double] and `VARIABLE_NAME` for [String]." : ""}" : "/// Class wrapper for duplicated values copied directly from env file"}
class $name {
$cast
}
""";

    // Writing file to disk
    Directory(path).createSync(recursive: true);
    File(model).writeAsStringSync(write);
    print(
        "\x1B[32m$input\x1B[0m successfully generated into \x1B[34m$model\x1B[0m 🎉");
  }
}

/// Parse environment variables into a json structured map.
Map<String, dynamic> toJson(String value) {
  final data = <String, dynamic>{};
  final lines = value.trim().split('\n');

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
      /* do nothing */
    }
  }
  return data;
}

/// A function to capitalize first letter of [String].
String capitalize(String text) {
  if (text.length < 2) return text.toUpperCase();
  return text[0].toUpperCase() + text.toLowerCase().substring(1);
}

/// A function to generate dart naming style of [String].
String dartNamed(String input) {
  List<String> words = input.split('_');
  String firstWord = words.first.toLowerCase();
  String restOfWords = words.sublist(1).map((word) => capitalize(word)).join();
  return '$firstWord$restOfWords';
}
