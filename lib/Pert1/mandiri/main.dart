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

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void _tambah() => setState(() => _count++);

  // Latihan 4: cegah angka negatif
  void _kurang() => setState(() {
        if (_count > 0) _count--;
      });

  // Latihan 3: reset ke 0
  void _reset() => setState(() => _count = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latihan 1: ubah warna AppBar dan teks
      appBar: AppBar(
        title: const Text('Counter Saya'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$_count',
          style: const TextStyle(fontSize: 48, color: Colors.deepPurple),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Latihan 2: tombol kurang
          FloatingActionButton(
            heroTag: 'kurang',
            onPressed: _kurang,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          // Latihan 3: tombol reset
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
