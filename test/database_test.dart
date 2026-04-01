import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_jenkins_app/database_helper.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Insert user berhasil', () async {
    final db = DatabaseHelper();
    final id = await db.insertUser({
      'name': 'Budi',
      'email': 'budi@test.com',
      'created_at': DateTime.now().toIso8601String(),
    });
    expect(id, isPositive);
  });

  test('Get users tidak kosong', () async {
    final db = DatabaseHelper();
    final users = await db.getUsers();
    expect(users, isNotEmpty);
  });
}
