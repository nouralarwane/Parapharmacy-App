import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => HistoryState();
}

class HistoryState extends State<HistoryPage> {
  final String action = "Visite de l'historique";
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique de l'application")),

      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Les pages visitées et actions effectuées!!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),

          // ListView.builder(itemBuilder: itemBuilder),
        ],
      ),
    );
  }
}
