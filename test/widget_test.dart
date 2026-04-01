import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jenkins_app/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App bisa dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.text('Flutter Jenkins + SQLite'), findsOneWidget);
  });
}
