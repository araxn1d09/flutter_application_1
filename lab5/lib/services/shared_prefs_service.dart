import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;
  SharedPrefsService._internal();

  static const String _fullNameKey = 'full_name';
  static const String _genderKey = 'gender';
  static const String _agreedToTermsKey = 'agreed_to_terms';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveFullName(String fullName) async {
    final prefs = await _prefs;
    await prefs.setString(_fullNameKey, fullName);
  }

  Future<String?> getFullName() async {
    final prefs = await _prefs;
    return prefs.getString(_fullNameKey);
  }

  Future<void> saveGender(String gender) async {
    final prefs = await _prefs;
    await prefs.setString(_genderKey, gender);
  }

  Future<String?> getGender() async {
    final prefs = await _prefs;
    return prefs.getString(_genderKey);
  }

  Future<void> saveAgreedToTerms(bool agreed) async {
    final prefs = await _prefs;
    await prefs.setBool(_agreedToTermsKey, agreed);
  }

  Future<bool?> getAgreedToTerms() async {
    final prefs = await _prefs;
    return prefs.getBool(_agreedToTermsKey);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}