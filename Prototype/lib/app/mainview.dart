import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/app/home/home.dart';
import 'package:prototype/resources/color_schemes.g.dart';
import 'package:prototype/util/user_session.dart'; // Make sure this path is correct
import 'authenticate/screens/start_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
Widget build(BuildContext context) {
  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'GRP-Team 14',
    themeMode: ThemeMode.light,
    theme: ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      colorScheme: lightColorScheme,
      useMaterial3: true,
    ),
    transitionDuration: const Duration(milliseconds: 500),
    home: FutureBuilder<bool>(
      future: UserSession.isUserLoggedIn(), // Assuming this is your method to check login status
      builder: (context, snapshot) {
        // Check if the future has completed
        if (snapshot.connectionState == ConnectionState.done) {
          // If we can determine the login status
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen(); // Or wherever you want to route after login
          } else {
            return const StartScreen(); // Your login or start screen
          }
        } else {
          // Show a loading spinner while checking login status
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
}
