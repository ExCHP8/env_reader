import 'package:env_reader/env_reader.dart';
import 'package:example/src/env_model.dart';
import 'package:flutter/material.dart';

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load(
    source: EnvLoader.asset('assets/env/.env'),
    password: "MyStrongPassword",
  );
  runApp(
    const MaterialApp(
      title: "Env Reader",
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Env.read<String>("MY_STRING") ?? "Oops"),
            Text(EnvModel.apiKey),
          ],
        ),
      ),
    );
  }
}
