import 'package:flutter/material.dart';
import '../services/shared_prefs_service.dart';
import '../database/database_helper.dart';
import '../models/bmi_record.dart';
import 'history_screen.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // Контроллеры
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Переменные состояния
  String _gender = 'мужской';
  bool _agreeToTerms = false;
  double _bmiResult = 0.0;
  String _bmiCategory = '';
  bool _isLoading = true;

  // Сервисы
  final SharedPrefsService _prefsService = SharedPrefsService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Загрузка сохраненных данных
  Future<void> _loadSavedData() async {
    try {
      final savedName = await _prefsService.getFullName();
      final savedGender = await _prefsService.getGender();
      final savedAgreement = await _prefsService.getAgreedToTerms();

      setState(() {
        if (savedName != null) _nameController.text = savedName;
        if (savedGender != null) _gender = savedGender;
        _agreeToTerms = savedAgreement ?? false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Сохранение данных в SharedPreferences
  Future<void> _saveUserData() async {
    if (_nameController.text.isNotEmpty) {
      await _prefsService.saveFullName(_nameController.text);
    }
    await _prefsService.saveGender(_gender);
    await _prefsService.saveAgreedToTerms(_agreeToTerms);
  }

  // Расчет ИМТ
  Future<void> _calculateBMI() async {
    if (_weightController.text.isEmpty || _heightController.text.isEmpty) {
      _showMessage('Введите вес и рост');
      return;
    }

    if (_nameController.text.isEmpty) {
      _showMessage('Введите ФИО');
      return;
    }

    if (!_agreeToTerms) {
      _showMessage('Необходимо согласие на обработку данных');
      return;
    }

    try {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text) / 100;

      if (weight <= 0 || height <= 0) {
        _showMessage('Введите корректные значения');
        return;
      }

      double bmi = weight / (height * height);
      String category = _getBMICategory(bmi);
      Color categoryColor = _getCategoryColor(bmi);

      // Сохраняем пользовательские данные
      await _saveUserData();

      // Сохраняем запись в БД
      final record = BMIRecord(
        fullName: _nameController.text,
        gender: _gender,
        weight: weight,
        height: height * 100, // сохраняем в см
        bmi: bmi,
        category: category,
        createdAt: DateTime.now(),
      );

      await _dbHelper.insertRecord(record);

      setState(() {
        _bmiResult = bmi;
        _bmiCategory = category;
      });

      // Показываем результат
      _showResultDialog(bmi, category, categoryColor);
    } catch (e) {
      _showMessage('Ошибка ввода данных');
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 16) return 'Выраженный дефицит';
    if (bmi < 18.5) return 'Недостаточный вес';
    if (bmi < 25) return 'Нормальный вес';
    if (bmi < 30) return 'Избыточный вес';
    if (bmi < 35) return 'Ожирение 1 степени';
    if (bmi < 40) return 'Ожирение 2 степени';
    return 'Ожирение 3 степени';
  }

  Color _getCategoryColor(double bmi) {
    if (bmi < 16) return Colors.red;
    if (bmi < 18.5) return Colors.orange;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  void _showResultDialog(double bmi, String category, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Результат расчета ИМТ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ФИО: ${_nameController.text}'),
            Text('Пол: $_gender'),
            const SizedBox(height: 10),
            Text('ИМТ: ${bmi.toStringAsFixed(1)}'),
            Text('Категория: $category', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Данные сохранены в базу данных', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToHistory();
            },
            child: const Text('История'),
          ),
        ],
      ),
    );
  }

  void _navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  void _clearForm() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmiResult = 0.0;
      _bmiCategory = '';
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Политика конфиденциальности'),
        content: const SingleChildScrollView(
          child: Text(
            'Мы сохраняем ваши данные для:\n\n'
            '1. Расчетов ИМТ\n'
            '2. Статистики здоровья\n'
            '3. Персональных рекомендаций\n\n'
            'Данные хранятся локально на вашем устройстве.\n'
            'Вы можете очистить историю в любое время.',
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

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор ИМТ'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToHistory,
            tooltip: 'История расчетов',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Анкета
            const Text('Анкета пациента', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // ФИО
            const Text('ФИО:', style: TextStyle(fontWeight: FontWeight.w500)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Введите ваше ФИО',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Пол
            const Text('Пол:', style: TextStyle(fontWeight: FontWeight.w500)),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Мужской'),
                    selected: _gender == 'мужской',
                    onSelected: (selected) => setState(() => _gender = 'мужской'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Женский'),
                    selected: _gender == 'женский',
                    onSelected: (selected) => setState(() => _gender = 'женский'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Согласие
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _showPrivacyPolicy,
                    child: const Text('Согласен на обработку персональных данных'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _showPrivacyPolicy,
              icon: const Icon(Icons.privacy_tip_outlined, size: 18),
              label: const Text('Политика конфиденциальности'),
            ),
            const SizedBox(height: 30),

            // Калькулятор
            const Divider(),
            const SizedBox(height: 20),
            const Text('Калькулятор ИМТ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Вес
            const Text('Вес (кг):', style: TextStyle(fontWeight: FontWeight.w500)),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Например: 70.5',
                suffixText: 'кг',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Рост
            const Text('Рост (см):', style: TextStyle(fontWeight: FontWeight.w500)),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Например: 175',
                suffixText: 'см',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 25),

            // Результат
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Text('Ваш ИМТ:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(
                      _bmiResult > 0 ? _bmiResult.toStringAsFixed(1) : '--',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    if (_bmiCategory.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        _bmiCategory,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(_bmiResult),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Рассчитать ИМТ', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: _clearForm,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Очистить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}