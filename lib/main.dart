import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Jenkins Demo',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _db = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await _db.getUsers();
    setState(() => _users = u);
  }

  Future<void> _add() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) return;
    await _db.insertUser({
      'name': _nameCtrl.text,
      'email': _emailCtrl.text,
      'created_at': DateTime.now().toIso8601String(),
    });
    _nameCtrl.clear();
    _emailCtrl.clear();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Jenkins + SQLite')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _add, child: const Text('Tambah')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder:
                  (_, i) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(_users[i]['name']),
                    subtitle: Text(_users[i]['email']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _db.deleteUser(_users[i]['id']);
                        await _load();
                      },
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
