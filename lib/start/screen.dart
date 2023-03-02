import 'package:flutter/material.dart';

import '../logic/index.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen>
    with SingleTickerProviderStateMixin {
  List<Player> players = [];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Új játék'),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Card(
                  margin: EdgeInsets.all(8),
                  child: Center(
                    child: Text("Add Players"),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(8),
                  child: Center(
                    child: Text("Manage Teams"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TabPageSelector(
              controller: tabController,
              color: Colors.grey[500],
              selectedColor: Colors.amber,
              borderStyle: BorderStyle.none,
              indicatorSize: 15,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        child: Column(
          children: [
            FilledButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Indítás", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
  }
}