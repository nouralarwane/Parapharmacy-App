import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsPage extends StatefulWidget {
  const PrefsPage({super.key});
  @override
  State<PrefsPage> createState() => PrefsState();
}

class PrefsState extends State<PrefsPage> {

  bool isSwitched = false;
  double fontSize = 17;
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // 4) charger au démarrage
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('Joe') ?? '';
      isSwitched = prefs.getBool('darkmode') ?? false;
      fontSize = prefs.getDouble('size') ?? 17;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Joe', username);
    await prefs.setBool('darkmode', isSwitched);
    await prefs.setDouble('size', fontSize);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Préférences sauvegardées')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isSwitched
          ? const Color.fromARGB(255, 74, 49, 49)
          : Colors.white,
      appBar: AppBar(
        foregroundColor: const Color.fromARGB(255, 111, 162, 187),
        title: Text("Settings Page"),
        backgroundColor: isSwitched
            ? const Color.fromARGB(255, 74, 49, 49)
            : Colors.white,
      ),

      body: DefaultTextStyle(
        style: TextStyle(fontSize: fontSize),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Switch to Night or Morning",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Switch(
                  activeThumbColor: Colors.blueAccent,
                  inactiveThumbColor: const Color.fromARGB(96, 59, 46, 46),
                  value: isSwitched,
                  onChanged: (bool valeur) {
                    setState(() {
                      isSwitched = valeur;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 30),
            Text(
              "Change the text size",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              min: 14,
              max: 25,
              value: fontSize,
              onChanged: (double valeur) {
                setState(() {
                  fontSize = valeur;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

