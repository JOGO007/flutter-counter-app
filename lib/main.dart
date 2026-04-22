import 'package:flutter/material.dart';
import 'package:hello_world_app/presentation/screens/counter/counter_functions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final theme = _prefs.getString('themeMode');

    setState(() {
      _themeMode = (theme == 'dark') ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Switch(
              value: _themeMode == ThemeMode.dark,
              onChanged: (val) async {
                setState(() {
                  _themeMode = val ? ThemeMode.dark : ThemeMode.light;
                });

                await _prefs.setString('themeMode', val ? 'dark' : 'light');
              },
            ),
          ],
        ),
        body: CounterFunctionsScreen(),
      ),
    );
  }
}
