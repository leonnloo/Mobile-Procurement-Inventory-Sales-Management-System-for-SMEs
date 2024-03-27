import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/resources/color_schemes.g.dart';
import 'authenticate/screens/start_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GRP-Team 14',
      // TO DO: change theme here
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true
      ),
      themeMode: ThemeMode.system,
      transitionDuration: const Duration(milliseconds: 500),
      home: const StartScreen(),
    );
  }
}
