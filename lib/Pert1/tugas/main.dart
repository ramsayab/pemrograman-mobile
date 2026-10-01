import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Perkenalan',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kartu Perkenalan'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.account_circle, size: 120, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Ramsay',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('NIM: 20240801042', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('Jurusan: Teknik Informatika', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Hobi: Main Game', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}