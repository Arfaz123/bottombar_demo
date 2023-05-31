import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() => runApp( MyApp());

BuildContext? testContext;

class MyApp extends StatelessWidget {
  const MyApp({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: "Counter",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home:  Counter(),

  );
}
class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int counter = 0;
  List<String> counterHistory = [];

  void incrementCounter() {
    setState(() {
      counter++;
      counterHistory.add(counter.toString());
    });
    saveCounter();
  }

  void resetCounter() {
    setState(() {
      counter = 0;
      counterHistory = [];
    });
    saveCounter();
  }

  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', counter);
    prefs.setStringList('counterHistory', counterHistory);
  }

  @override
  void initState() {
    super.initState();
    loadCounter();
  }

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
      counterHistory = prefs.getStringList('counterHistory') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Count: $counter',
            style: const TextStyle(fontSize: 36),
          ),
          const  SizedBox(height: 20),
          const Text(
            'Counter History:',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: counterHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Count: ${counterHistory[index]}',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: resetCounter,
            tooltip: 'Reset',
            child:const  Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
