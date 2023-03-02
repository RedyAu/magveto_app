import 'package:flutter/material.dart';

import 'start/screen.dart';

void main() {
  runApp(const MagvetoApp());
}

class MagvetoApp extends StatelessWidget {
  const MagvetoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.amber, brightness: Brightness.dark),
          useMaterial3: true),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 25,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Magvető",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50, color: Colors.amber)),
                    Text("Nem hivatalos segítő app",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20, color: Colors.grey[100])),
                  ],
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NewScreen())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Új játék",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Spacer(flex: 1),
            ElevatedButton(
              onPressed: () {},
              child: Text("Játék betöltése"),
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
