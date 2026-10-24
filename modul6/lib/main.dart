import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modul 6 - GridView & ListView',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const SemuaPercobaan(),
    );
  }
}

class SemuaPercobaan extends StatelessWidget {
  const SemuaPercobaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 6 - GridView & ListView'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ============================================
          // PERCOBAAN 1 - GridView
          // ============================================
          _judulBagian('Percobaan 1: GridView (4 kolom x 5 baris)'),
          Container(
            height: 250,
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List.generate(20, (index) {
                return Container(
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // ============================================
          // PERCOBAAN 2 - ListView
          // ============================================
          _judulBagian('Percobaan 2: ListView (list item statis)'),
          Container(
            height: 200,
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Container(
                  height: 40,
                  color: Colors.amber,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: const Center(child: Text('Item 1')),
                ),
                Container(
                  height: 40,
                  color: Colors.green,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: const Center(child: Text('Item 2')),
                ),
                Container(
                  height: 40,
                  color: Colors.blue,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: const Center(child: Text('Item 3')),
                ),
                Container(
                  height: 40,
                  color: Colors.red,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: const Center(child: Text('Item 4')),
                ),
                Container(
                  height: 40,
                  color: Colors.purple,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: const Center(child: Text('Item 5')),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ============================================
          // PERCOBAAN 3 - ListView.builder
          // ============================================
          _judulBagian('Percobaan 3: ListView.builder (dari data List)'),
          Container(
            height: 200,
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  height: 35,
                  color: Colors.primaries[index % Colors.primaries.length],
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Center(
                    child: Text(
                      'Data ke-${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ============================================
          // TUGAS - Fetch API Game
          // ============================================
          _judulBagian('TUGAS: API Game (freetogame.com)'),
          Container(
            height: 400,
            color: Colors.white,
            child: const GameListScreen(),
          ),
        ],
      ),
    );
  }

  Widget _judulBagian(String teks) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// ============================================
// CLASS: GameListScreen untuk TUGAS API
// ============================================
class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  late Future<List<dynamic>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _fetchGames();
  }

  // Fungsi untuk ambil data dari API
  Future<List<dynamic>> _fetchGames() async {
    final response = await http.get(
      Uri.parse('https://www.freetogame.com/api/games'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _gamesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error: ${snapshot.error}\n\nPastikan internet aktif!',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Tidak ada data'),
          );
        }

        final games = snapshot.data!.take(15).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index % Colors.primaries.length],
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  game['title'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${game['genre'] ?? '-'} | ${game['platform'] ?? '-'}',
                ),
                trailing: const Icon(Icons.videogame_asset),
              ),
            );
          },
        );
      },
    );
  }
}