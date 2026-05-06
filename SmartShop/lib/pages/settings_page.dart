import 'package:flutter/material.dart';
import 'package:smartshop/pages/prefs_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingState();
}

class SettingState extends State<SettingsPage> {
  bool isSwitched = false;
  double fontSize = 14;

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

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrefsPage()),
                );
              },
              label: Text("Préferences"),
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
    );
  }
}
