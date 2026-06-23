import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import 'package:flutter/material.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const firstUserKey = "firstUser";
  static const profileCompleteKey = "profileComplete";
  static const verifiedKey = "verified";

  /// TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConstants.tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: ApiConstants.tokenKey);
  }

  /// FIRST USER
  static Future<void> saveFirstUser(bool value) async {
    await _storage.write(key: firstUserKey, value: value.toString());
  }

  static Future<bool> getFirstUser() async {
    final val = await _storage.read(key: firstUserKey);
    return val == 'true';
  }

  /// PROFILE COMPLETE
  static Future<void> saveProfileComplete(bool value) async {
    await _storage.write(key: profileCompleteKey, value: value.toString());
  }

  static Future<bool> getProfileComplete() async {
    final val = await _storage.read(key: profileCompleteKey);
    return val == 'true';
  }

  /// VERIFIED
  static Future<void> saveVerified(bool value) async {
    await _storage.write(key: verifiedKey, value: value.toString());
  }

  static Future<bool> getVerified() async {
    final val = await _storage.read(key: verifiedKey);
    return val == 'true';
  }

  /// IS AGENT
  static Future<void> saveIsAgent(bool value) async {
    await _storage.write(
      key: ApiConstants.isAgentKey,
      value: value.toString(), // true / false
    );
  }

  /// Gemini TOKEN
  static Future<void> saveGeminiToken(String token) async {
    await _storage.write(key: ApiConstants.geminiKey, value: token);
  }

  static Future<void> saveGeminiVersion(String version) async {
    await _storage.write(key: ApiConstants.geminiVersion, value: version);
  }

  static Future<String?> getGeminiToken() async {
    return await _storage.read(key: ApiConstants.geminiKey);
  }

  static Future<String?> getGeminiVersion() async {
    return await _storage.read(key: ApiConstants.geminiVersion);
  }

  /// OpenAi Token
  static Future<void> saveOpenAiToken(String token) async {
    await _storage.write(key: ApiConstants.OpenAiKey, value: token);
  }

  static Future<void> saveOpenAiVersion(String version) async {
    await _storage.write(key: ApiConstants.OpenAiVersion, value: version);
  }

  static Future<String?> getOpenAiToken() async {
    return await _storage.read(key: ApiConstants.OpenAiKey);
  }

  static Future<String?> getOpenAiVersion() async {
    return await _storage.read(key: ApiConstants.OpenAiVersion);
  }

  static Future<bool> getIsAgent() async {
    final value = await _storage.read(key: ApiConstants.isAgentKey);
    return value == 'true';
  }

  /// IS USER
  static Future<void> saveIsUser(bool value) async {
    await _storage.write(key: ApiConstants.isUserKey, value: value.toString());
  }

  static Future<bool> getIsUser() async {
    final value = await _storage.read(key: ApiConstants.isUserKey);
    return value == 'true';
  }

  /// IS AGENT - REMOVE
  static Future<void> removeIsAgent() async {
    await _storage.delete(key: ApiConstants.isAgentKey);
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: ApiConstants.tokenKey);
  }

  /// IS USER - REMOVE
  static Future<void> removeIsUser() async {
    await _storage.delete(key: ApiConstants.isUserKey);
  }

  /// LOGOUT
  static Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();

    // await AppSettings.clearUserType();
    //
    // context.go(Routes.login);
    // await AppSettings.initUserType();
  }
}
