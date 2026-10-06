import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

class Komentar {
  final int id;
  final String name;
  final String email;
  final String body;

  const Komentar({
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }
}

class PostService {
  static const _base = 'https://jsonplaceholder.typicode.com';

  static Future<List<dynamic>> _getList(String path) async {
    final response = await http
        .get(Uri.parse('$_base$path'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${response.statusCode})');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  static Future<List<Post>> ambilPosts() async {
    final data = await _getList('/posts');
    return data.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Komentar>> ambilKomentar(int postId) async {
    final data = await _getList('/posts/$postId/comments');
    return data
        .map((e) => Komentar.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Postingan',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const PostPage(),
    );
  }
}

class ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Terjadi kesalahan:\n$error',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = PostService.ambilPosts();
  }

  void _muatUlang() {
    setState(() {
      _future = PostService.ambilPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _muatUlang),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _muatUlang);
          }
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final p = data[i];
              return ListTile(
                title:
                    Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  p.body.replaceAll('\n', ' '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPostPage(post: p),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPostPage extends StatefulWidget {
  final Post post;

  const DetailPostPage({super.key, required this.post});

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  late Future<List<Komentar>> _future;

  @override
  void initState() {
    super.initState();
    _future = PostService.ambilKomentar(widget.post.id);
  }

  void _muatUlang() {
    setState(() {
      _future = PostService.ambilKomentar(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(title: Text('Postingan #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(post.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(post.body),
          const Divider(height: 32),
          Text('Komentar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FutureBuilder<List<Komentar>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return ErrorView(error: snapshot.error, onRetry: _muatUlang);
              }
              final komentar = snapshot.data!;
              if (komentar.isEmpty) {
                return const Text('Belum ada komentar');
              }
              return Column(
                children: komentar
                    .map(
                      (k) => Card(
                        child: ListTile(
                          title: Text(k.name),
                          subtitle: Text('${k.email}\n${k.body}'),
                          isThreeLine: true,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
