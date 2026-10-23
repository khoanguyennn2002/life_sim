import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'generators/character_generator.dart';

void main() => runApp(const LifeApp());

class LifeApp extends StatelessWidget {
  const LifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test life sim',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const CreateCharacterScreen(),
    );
  }
}

class CreateCharacterScreen extends StatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  static const String _name = 'Minh An';
  static const int _birthYear = 2026;

  late GeneratedLife _life;

  @override
  void initState() {
    super.initState();
    // Lần đầu dùng seed cố định để kết quả luôn giống nhau khi kiểm thử.
    _life = CharacterGenerator.generate(
      seed: DateTime.now().millisecondsSinceEpoch,
      name: _name,
      birthYear: _birthYear,
    );
    // Dữ liệu ẩn chỉ in ra console, không đưa lên giao diện.
    if (kDebugMode) debugPrint(_life.toDebugString());
  }

  @override
  Widget build(BuildContext context) {
    // UI chỉ đọc các trường được phép hiển thị từ Character.
    // Tuyệt đối không truy cập _life.family hay các trường *Potential ở đây.
    final c = _life.character;

    final stats = <(String, int, Color)>[
      ('Sức khỏe', c.health, Colors.red),
      ('Hạnh phúc', c.happiness, Colors.amber),
      ('Trí tuệ', c.intelligence, Colors.blue),
      ('Năng lực', c.ability, Colors.green),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Test life sim')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Năm sinh: ${c.birthYear}'),
              Text('Tuổi: ${c.age}'),
              const SizedBox(height: 24),
              for (final s in stats) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(s.$1), Text('${s.$2}/100')],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: s.$2 / 100,
                  minHeight: 10,
                  color: s.$3,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 16),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tạo lại nhân vật'),
                  onPressed: () {
                    setState(() {
                      _life = CharacterGenerator.generate(
                        seed: DateTime.now().millisecondsSinceEpoch,
                        name: _name,
                        birthYear: _birthYear,
                      );
                    });
                    if (kDebugMode) debugPrint(_life.toDebugString());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
