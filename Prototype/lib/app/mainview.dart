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
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          titleLarge: TextStyle(fontSize: 18),
          titleMedium: TextStyle(fontSize: 14),
        )
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
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.onPrimary, // Set the background color to white
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use min to shrink the column's size to fit its children
                  children: [
                    // Wrap the CircularProgressIndicator in a SizedBox to increase its size
                    SizedBox(
                      width: 60, // Specify the size of the CircularProgressIndicator
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 7, // Increase the stroke width to make the indicator bolder
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(height: 20), // Add some spacing between the indicator and the text
                    Text('Loading...', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
