import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'src/helpers/sql_helper.dart';
import 'presentation/pages/home_page.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'themes/theme.dart';
import 'package:adb_client/src/core/constants.dart';
import 'presentation/pages/login_page.dart';
void main() {
  SqlHelper.initializeDatabaseFactory();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', 'US');
  bool _isDarkMode = false; // Track the theme mode
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
       theme: _isDarkMode ? AppThemes.darkMode : AppThemes.lightMode, // Choose theme
      locale: _locale,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MyHomePage(
        title:'Warehouse Application',
        onLocaleChange: _setLocale,
         onThemeToggle: _toggleTheme, // Pass theme toggle callback
      ),
      
    );
  }
  
}