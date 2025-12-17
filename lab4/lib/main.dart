import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор ИМТ + Анкета',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // Данные формы
  final TextEditingController _nameController = TextEditingController();
  bool _agreeToTerms = false;

  // Калькулятор ИМТ
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _bmiResult = 0.0;
  String _bmiCategory = '';
  String _gender = 'мужской';

  // Политика конфиденциальности
  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Политика конфиденциальности'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Настоящая Политика регулирует порядок обработки медицинских данных.\n\n'
                '1. Собираемые данные:\n'
                '- ФИО пользователя\n'
                '- Вес, рост, пол\n'
                '- Результаты ИМТ\n\n'
                '2. Цели сбора:\n'
                '- Расчет индекса массы тела\n'
                '- Статистика здоровья\n'
                '- Персональные рекомендации\n\n'
                '3. Данные анонимизируются\n'
                '4. Не являются медицинским диагнозом\n\n'
                'Контакты: health@example.com',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey[100],
                child: const Text(
                  'Расчет ИМТ не заменяет консультацию врача',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  // Расчет ИМТ
  void _calculateBMI() {
    if (_weightController.text.isEmpty || _heightController.text.isEmpty) {
      _showMessage('Введите вес и рост');
      return;
    }

    try {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text) / 100; // см → м

      if (weight <= 0 || height <= 0) {
        _showMessage('Введите корректные значения');
        return;
      }

      double bmi = weight / (height * height);

      String category;
      Color color;

      if (bmi < 16) {
        category = 'Выраженный дефицит';
        color = Colors.red;
      } else if (bmi < 18.5) {
        category = 'Недостаточный вес';
        color = Colors.orange;
      } else if (bmi < 25) {
        category = 'Нормальный вес';
        color = Colors.green;
      } else if (bmi < 30) {
        category = 'Избыточный вес';
        color = Colors.orange;
      } else if (bmi < 35) {
        category = 'Ожирение 1 степени';
        color = Colors.red;
      } else if (bmi < 40) {
        category = 'Ожирение 2 степени';
        color = Colors.red[800]!;
      } else {
        category = 'Ожирение 3 степени';
        color = Colors.red[900]!;
      }

      setState(() {
        _bmiResult = bmi;
        _bmiCategory = category;
      });

      // Если согласен - показываем рекомендации
      if (_agreeToTerms && _nameController.text.isNotEmpty) {
        _showBMIRecommendations(bmi, category, color);
      }
    } catch (e) {
      _showMessage('Ошибка ввода данных');
    }
  }

  void _showBMIRecommendations(double bmi, String category, Color color) {
    String recommendation = '';

    if (bmi < 18.5) {
      recommendation = 'Рекомендуется увеличить калорийность питания';
    } else if (bmi < 25) {
      recommendation = 'Ваш вес в норме. Продолжайте в том же духе!';
    } else {
      recommendation = 'Рекомендуется увеличить физическую активность';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Результаты ИМТ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Пациент: ${_nameController.text}'),
            Text('Пол: $_gender'),
            const SizedBox(height: 10),
            Text('ИМТ: ${bmi.toStringAsFixed(1)}'),
            Text('Категория: $category', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Рекомендация: $recommendation', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            const Text(
              'Данные сохранены для статистики здоровья',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearCalculator() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = 0.0;
      _bmiCategory = '';
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор ИМТ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Раздел 1: Анкета
            const Text(
              'Анкета пациента',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // ФИО
            const Text('ФИО:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Введите ваше ФИО',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Выбор пола
            const Text('Пол:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Мужской'),
                    selected: _gender == 'мужской',
                    onSelected: (selected) {
                      setState(() {
                        _gender = 'мужской';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Женский'),
                    selected: _gender == 'женский',
                    onSelected: (selected) {
                      setState(() {
                        _gender = 'женский';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Согласие на обработку
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: GestureDetector(
                    onTap: _showPrivacyPolicy,
                    child: const Text(
                      'Согласен на обработку медицинских данных',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Кнопка политики
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _showPrivacyPolicy,
                icon: const Icon(Icons.medical_services_outlined, size: 18),
                label: const Text('Политика конфиденциальности'),
              ),
            ),
            const SizedBox(height: 30),

            // Разделитель
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 20),

            // Раздел 2: Калькулятор ИМТ
            const Text(
              'Калькулятор индекса массы тела (ИМТ)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Вес
            const Text('Вес (кг):', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Например: 70.5',
                suffixText: 'кг',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Рост
            const Text('Рост (см):', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Например: 175',
                suffixText: 'см',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Результат ИМТ
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Ваш индекс массы тела:',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _bmiResult > 0 ? _bmiResult.toStringAsFixed(1) : '--',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    if (_bmiCategory.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        _bmiCategory,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Шкала ИМТ
            const Text('Шкала ИМТ:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.green,
                    Colors.orange,
                    Colors.red,
                  ],
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('<16', style: TextStyle(color: Colors.white)),
                  ),
                  Text('18.5', style: TextStyle(color: Colors.white)),
                  Text('25', style: TextStyle(color: Colors.white)),
                  Text('30', style: TextStyle(color: Colors.white)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('>40', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Дефицит', style: TextStyle(fontSize: 12)),
                const Text('Норма', style: TextStyle(fontSize: 12)),
                const Text('Ожирение', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 25),

            // Кнопки
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateBMI,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Рассчитать ИМТ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: _clearCalculator,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Очистить'),
                  ),
                ),
              ],
            ),

            // Информация о согласии
            if (_agreeToTerms && _nameController.text.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 200, 230, 201)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.health_and_safety, color: Colors.green, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Данные ИМТ будут сохранены для ${_nameController.text}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    if (_bmiResult < 16) return Colors.red;
    if (_bmiResult < 18.5) return Colors.orange;
    if (_bmiResult < 25) return Colors.green;
    if (_bmiResult < 30) return Colors.orange;
    return Colors.red;
  }
}