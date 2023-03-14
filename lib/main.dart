import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'graphics/background.dart';
import 'logic/index.dart';
import 'start/screen.dart';

void main() {
  runApp(const MagvetoApp());
}

class MagvetoApp extends StatelessWidget {
  const MagvetoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameProvider>(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.amber, brightness: Brightness.dark),
            useMaterial3: true),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MagvetoBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 25,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: Image.asset(
                            'assets/other/logo.png',
                            semanticLabel: "Magvető",
                            filterQuality: FilterQuality.medium,
                          ),
                          width: 350,
                        ),
                        Text("Nem hivatalos játékvezető app",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[100])),
                      ],
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: FilledButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const NewScreen())),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Új játék",
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Játék betöltése",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
