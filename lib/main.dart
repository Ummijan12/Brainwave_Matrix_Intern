import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo_internship/providers/theme_provider.dart';
import 'package:todo_internship/providers/todo_provider.dart';
import 'package:todo_internship/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
        ),

        appBarTheme: AppBarTheme(
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple[700],
        ),
        // In your theme configuration
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurple),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            elevation: WidgetStateProperty.all<double>(8),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Montserrat',
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        // In your theme configuration
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurple),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            elevation: WidgetStateProperty.all<double>(8),
          ),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
