import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterFunctionsScreen extends StatefulWidget {
  const CounterFunctionsScreen({super.key});

  @override
  State<CounterFunctionsScreen> createState() => _CounterFunctionsScreenState();
}

class _CounterFunctionsScreenState extends State<CounterFunctionsScreen> {
  int clickCounter = 0;
  late SharedPreferences _prefs;

  final List<Color> rainbowColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCounter();
  }

  void _loadCounter() {
    final savedCounter = _prefs.getInt('clickCounter') ?? 0;
    setState(() {
      clickCounter = savedCounter;
    });
  }

  Future<void> _saveCounter() async {
    await _prefs.setInt('clickCounter', clickCounter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Functions'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                clickCounter = 0;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$clickCounter',
                key: ValueKey<int>(clickCounter),
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: rainbowColors[clickCounter % rainbowColors.length],
                ),
              ),
            ),

            Text(
              'Click${clickCounter == 1 ? '' : 's'}',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            icon: Icons.refresh_rounded,
            onPressed: () {
              setState(() {
                clickCounter = 0;
              });
              _saveCounter();
            },
          ),

          SizedBox(height: 10),

          CustomButton(
            icon: Icons.exposure_plus_1_outlined,
            onPressed: () {
              setState(() {
                clickCounter++;
              });
              _saveCounter();
            },
          ),

          SizedBox(height: 10),

          CustomButton(
            icon: Icons.exposure_minus_1_outlined,
            onPressed: () {
              if (clickCounter == 0) return;
              setState(() {
                clickCounter--;
              });
              _saveCounter();
            },
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
