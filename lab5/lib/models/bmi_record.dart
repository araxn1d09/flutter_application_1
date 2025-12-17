class BMIRecord {
  int? id;
  String fullName;
  String gender;
  double weight;
  double height;
  double bmi;
  String category;
  DateTime createdAt;

  BMIRecord({
    this.id,
    required this.fullName,
    required this.gender,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.createdAt,
  });

  // Конвертация в Map для БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Создание из Map из БД
  factory BMIRecord.fromMap(Map<String, dynamic> map) {
    return BMIRecord(
      id: map['id'],
      fullName: map['full_name'],
      gender: map['gender'],
      weight: map['weight'],
      height: map['height'],
      bmi: map['bmi'],
      category: map['category'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}