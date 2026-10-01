import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 1',
      home: const CounterPage(),
    );
  }
}

class HelloPage extends StatelessWidget {
  const HelloPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello Flutter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.flutter_dash, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text('Halo, nama saya Ramsay Abelson!', style: TextStyle(fontSize: 24)),
            Text('NIM: 20240801042'),
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void _tambah() => setState(() => _count++);

  void _kurang() => setState(() {
        if (_count > 0) _count--;
      });

  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Saya'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$_count',
          style: const TextStyle(
            fontSize: 48,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'kurang',
            onPressed: _kurang,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'reset',
            onPressed: _reset,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'tambah',
            onPressed: _tambah,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}