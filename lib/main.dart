import 'package:flutter/material.dart';
import 'package:post_list_pagination_search/core/theming/app_theme.dart';
import 'package:post_list_pagination_search/di/service_locator.dart';

void main() {
  setupDependencies();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [
          lightSimpleTheme,
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [
          darkSimpleTheme,
        ],
      ),
      home: const SizedBox(),
    );
  }
}
