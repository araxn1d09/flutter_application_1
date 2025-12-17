import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ИМТ Калькулятор',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SimpleBmiCalculator(), // Используем упрощенную версию
    );
  }
}

class SimpleBmiCalculator extends StatefulWidget {
  const SimpleBmiCalculator({super.key});

  @override
  State<SimpleBmiCalculator> createState() => _SimpleBmiCalculatorState();
}

class _SimpleBmiCalculatorState extends State<SimpleBmiCalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _agreement = false;
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ИМТ Калькулятор (Гаар Максим ИСТУ 22-1)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Вес (кг)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Рост (м)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreement,
                  onChanged: (value) => setState(() => _agreement = value ?? false),
                ),
                const Text('Согласие на обработку данных'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('РАССЧИТАТЬ'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                _result,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  void _calculate() {
    if (!_agreement) {
      setState(() => _result = 'Необходимо согласие!');
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || height <= 0) {
      setState(() => _result = 'Введите корректные данные!');
      return;
    }

    final bmi = weight / (height * height);
    setState(() => _result = 'ИМТ: ${bmi.toStringAsFixed(2)}');
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}