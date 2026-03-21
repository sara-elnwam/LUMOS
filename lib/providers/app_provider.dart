// lib/providers/app_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

// ============================================================
//  DATA MODELS
// ============================================================
class UserData {
  final String name;
  final String email;
  final String password; // stored as-is (demo only — hash in production)

  const UserData({
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserData.fromJson(Map<String, dynamic> j) => UserData(
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    password: j['password'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };
}

class MedicalProfile {
  final String sex;
  final String bloodType;
  final List<String> allergies;
  final List<String> medications;
  final List<String> diseases;

  const MedicalProfile({
    this.sex = '',
    this.bloodType = '',
    this.allergies = const [],
    this.medications = const [],
    this.diseases = const [],
  });

  bool get isEmpty =>
      sex.isEmpty &&
          bloodType.isEmpty &&
          allergies.isEmpty &&
          medications.isEmpty &&
          diseases.isEmpty;

  factory MedicalProfile.fromJson(Map<String, dynamic> j) => MedicalProfile(
    sex: j['sex'] ?? '',
    bloodType: j['blood_type'] ?? '',
    allergies: List<String>.from(j['allergies'] ?? []),
    medications: List<String>.from(j['medications'] ?? []),
    diseases: List<String>.from(j['diseases'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'sex': sex,
    'blood_type': bloodType,
    'allergies': allergies,
    'medications': medications,
    'diseases': diseases,
  };

  /// Compact JSON payload for QR code generation
  String toQrPayload(String userName) {
    return jsonEncode({
      'app': 'Lumos',
      'name': userName,
      'sex': sex,
      'blood': bloodType,
      'allergies': allergies.join(', '),
      'meds': medications.join(', '),
      'diseases': diseases.join(', '),
    });
  }
}

// ============================================================
//  APP PROVIDER
// ============================================================
class AppProvider extends ChangeNotifier {
  // ── Interaction mode ──────────────────────────────────────
  /// 'manual' | 'voice' | null (not yet chosen)
  String? _interactionMode;
  String? get interactionMode => _interactionMode;
  bool get isVoiceMode => _interactionMode == 'voice';

  // ── Language ──────────────────────────────────────────────
  String _langCode = 'en';
  String get langCode => _langCode;
  bool get isRTL => _langCode == 'ar';
  TextDirection get dir => isRTL ? TextDirection.rtl : TextDirection.ltr;

  // ── Voice gender ─────────────────────────────────────────
  String _voiceGender = 'female'; // 'male' | 'female'
  String get voiceGender => _voiceGender;

  // ── Auth state ───────────────────────────────────────────
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // ── User data ─────────────────────────────────────────────
  UserData? _user;
  UserData? get user => _user;

  // ── Medical profile ───────────────────────────────────────
  MedicalProfile _medical = const MedicalProfile();
  MedicalProfile get medical => _medical;

  // ── SharedPrefs keys ─────────────────────────────────────
  static const _kMode    = 'interaction_mode';
  static const _kLang    = 'lang_code';
  static const _kGender  = 'voice_gender';
  static const _kLogin   = 'is_logged_in';
  static const _kUser    = 'user_data';
  static const _kMedical = 'medical_profile';

  // ============================================================
  //  INIT — load everything from SharedPrefs
  // ============================================================
  Future<void> init() async {
    final p = await SharedPreferences.getInstance();

    _interactionMode = p.getString(_kMode);
    _langCode        = p.getString(_kLang)    ?? 'en';
    _voiceGender     = p.getString(_kGender)  ?? 'female';
    _isLoggedIn      = p.getBool(_kLogin)     ?? false;

    final userJson    = p.getString(_kUser);
    final medicalJson = p.getString(_kMedical);

    if (userJson != null) {
      try { _user = UserData.fromJson(jsonDecode(userJson)); } catch (_) {}
    }
    if (medicalJson != null) {
      try { _medical = MedicalProfile.fromJson(jsonDecode(medicalJson)); } catch (_) {}
    }

    notifyListeners();
  }

  // ============================================================
  //  SETTERS — each one persists immediately
  // ============================================================
  Future<void> setInteractionMode(String mode) async {
    _interactionMode = mode;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kMode, mode);
    notifyListeners();
  }

  Future<void> setLang(String code) async {
    if (_langCode == code) return;
    _langCode = code;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLang, code);
    notifyListeners();
  }

  Future<void> setVoiceGender(String gender) async {
    _voiceGender = gender;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kGender, gender);
    notifyListeners();
  }

  Future<void> saveUser(UserData data) async {
    _user = data;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kUser, jsonEncode(data.toJson()));
    notifyListeners();
  }

  Future<void> saveMedical(MedicalProfile data) async {
    _medical = data;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kMedical, jsonEncode(data.toJson()));
    notifyListeners();
  }

  Future<void> setLoggedIn(bool v) async {
    _isLoggedIn = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kLogin, v);
    notifyListeners();
  }

  /// Validates sign-in against stored user
  bool validateSignIn(String email, String password) {
    if (_user == null) return false;
    return _user!.email.trim().toLowerCase() == email.trim().toLowerCase() &&
        _user!.password == password;
  }

  /// Full logout — clears login flag but keeps profile data
  Future<void> logout() async {
    await setLoggedIn(false);
  }

  /// Convenience — translate a key using AppStrings
  String tr(String key) => AppStrings.get(_langCode, key);
}