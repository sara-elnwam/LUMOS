// lib/services/medical_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class MedicalAPIService {
  static const String baseUrl = 'http://lumos-api.runasp.net';
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Authorization': 'Bearer $token',
    };
  }


  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Account/change-password'),
        headers: {
          ...await _getAuthHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        }),
      );

      debugPrint('[ChangePassword] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('[ChangePassword] Password changed successfully');
        return true;
      } else if (response.statusCode == 400) {
        debugPrint('[ChangePassword] Bad request: ${response.body}');
        return false;
      } else if (response.statusCode == 401) {
        debugPrint('[ChangePassword] Unauthorized - token may be invalid');
        return false;
      } else {
        debugPrint('[ChangePassword] Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('[ChangePassword] Exception: $e');
      return false;
    }
  }


  static Future<Map<String, dynamic>?> getMedicalProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/MedicalProfile/get-profile'),
        headers: await _getAuthHeaders(),
      );
      debugPrint('[MedicalProfile] GET Status: ${response.statusCode}');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('[MedicalProfile] GET Error: $e');
      return null;
    }
  }

  static Future<bool> updateMedicalProfile({
    required int gender,
    required int bloodType,
    double height = 0,
    double weight = 0,
    String notes = '',
    String drPhone = '',
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/api/MedicalProfile/update-profile'),
      );
      request.headers.addAll(await _getAuthHeaders());

      request.fields['Gender'] = gender.toString();
      request.fields['BloodType'] = bloodType.toString();
      request.fields['Height'] = height.toString();
      request.fields['Weight'] = weight.toString();
      request.fields['Notes'] = notes;
      request.fields['DrPhone'] = drPhone;

      final response = await request.send();
      final body = await response.stream.bytesToString();
      debugPrint('[MedicalProfile] UPDATE Status: ${response.statusCode}');
      debugPrint('[MedicalProfile] UPDATE Body: $body');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[MedicalProfile] UPDATE Error: $e');
      return false;
    }
  }

  static Future<List<String>> getAllergies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/Allergies/Get-allergies'),
        headers: await _getAuthHeaders(),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List data = jsonDecode(response.body);
        return data.map((e) => e['name'] as String).toList();
      }
      return [];
    } catch (e) {
      debugPrint('[Allergies] GET Error: $e');
      return [];
    }
  }

  static Future<bool> addAllergy(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Allergies/allergies'),
        headers: {
          ...await _getAuthHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[Allergies] ADD Error: $e');
      return false;
    }
  }


  static Future<List<String>> getMedications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/Medications/Get-medications'),
        headers: await _getAuthHeaders(),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List data = jsonDecode(response.body);
        return data.map((e) => e['name'] as String).toList();
      }
      return [];
    } catch (e) {
      debugPrint('[Medications] GET Error: $e');
      return [];
    }
  }

  static Future<bool> addMedication(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Medications/medications'),
        headers: {
          ...await _getAuthHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[Medications] ADD Error: $e');
      return false;
    }
  }


  static Future<List<String>> getChronicDiseases() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ChromicDiseases/Get-chronic-diseases'),
        headers: await _getAuthHeaders(),
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List data = jsonDecode(response.body);
        return data.map((e) => e['name'] as String).toList();
      }
      return [];
    } catch (e) {
      debugPrint('[ChronicDiseases] GET Error: $e');
      return [];
    }
  }

  static Future<bool> addChronicDisease(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ChromicDiseases/chronic-diseases'),
        headers: {
          ...await _getAuthHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name}),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ChronicDiseases] ADD Error: $e');
      return false;
    }
  }


  static int genderToInt(String? gender) {
    if (gender == null) return 0;
    switch (gender.toLowerCase()) {
      case 'male': return 0;
      case 'female': return 1;
      default: return 0;
    }
  }

  static String genderFromInt(int? value) {
    if (value == null) return 'male';
    switch (value) {
      case 0: return 'male';
      case 1: return 'female';
      default: return 'male';
    }
  }

  static int bloodTypeToInt(String? bloodType) {
    if (bloodType == null) return 0;
    const types = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];
    final index = types.indexOf(bloodType);
    return index >= 0 ? index : 0;
  }

  static String bloodTypeFromInt(int? value) {
    if (value == null) return 'A+';
    const types = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];
    return value >= 0 && value < types.length ? types[value] : 'A+';
  }
}