import 'package:flutter/material.dart';
import 'package:game_fun_bonfire/pages/clima_page.dart';
import 'package:game_fun_bonfire/themes/theme.dart';
import 'package:game_fun_bonfire/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const ClimaPage(),
    );
  }
}
