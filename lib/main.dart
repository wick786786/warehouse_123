import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'src/helpers/sql_helper.dart';
import 'presentation/pages/homepage/home_page.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:warehouse_phase_1/src/core/constants.dart';
import 'presentation/pages/login_page.dart';
import 'package:window_manager/window_manager.dart';
void main() async {
  SqlHelper.initializeDatabaseFactory();
  
  //  WidgetsFlutterBinding.ensureInitialized();

  // // // Initialize the window manager
  //  await windowManager.ensureInitialized();

  // // // Configure window settings
  // // windowManager.waitUntilReadyToShow().then((_) async {
  // //   // Get the primary display size
  // //   //var display = await windowManager.getPrimaryDisplay();
  // //   //var screenSize = display.size;

  // //   // Set window size to match the screen size
  // //   //await windowManager.setSize();

  // //   // Make the window full screen, but allow minimize and close
  // //   await windowManager.setFullScreen(true);
  // //   await windowManager.setResizable(false);

  // //   // Show the window after configuration
  // //   await windowManager.show();
  // // });
  
  // final size = await windowManager.getBounds();
  // print('Screen Width: ${size.width}');
  // print('Screen Height: ${size.height}');
  // await windowManager.setMaximumSize(Size(1540.0,823.2));
  // await windowManager.setMinimumSize(Size(0,0));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');
  bool _isDarkMode = false;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? AppThemes.darkMode : AppThemes.lightMode,
      locale: _locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      home: MyHomePage(
        title: 'Warehouse Application',
        onLocaleChange: _setLocale,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}