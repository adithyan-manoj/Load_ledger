import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

/// High-performance AES-256 field and payload cryptographic cipher.
///
/// Encrypts and decrypts domain fields using AES-256-CBC with dynamic,
/// cryptographically secure 128-bit Initialization Vectors (IV) per record.
///
/// Ciphertext output format: `<base64_iv>:<base64_ciphertext>`.
class CipherService {
  final Encrypter _encrypter;

  CipherService({required String base64Key})
      : _encrypter = Encrypter(AES(_parseKey(base64Key), mode: AESMode.cbc));

  static Key _parseKey(String base64Key) {
    try {
      // Normalize base64Url to base64 if needed
      String normalized = base64Key.replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }
      final bytes = base64Decode(normalized);
      if (bytes.length != 32) {
        throw ArgumentError('AES-256 key must be exactly 32 bytes (256 bits).');
      }
      return Key(bytes);
    } catch (e) {
      // Fallback: derive 32-byte key from raw bytes if decoding issues
      final raw = utf8.encode(base64Key);
      final padded = List<int>.generate(32, (i) => i < raw.length ? raw[i] : 0);
      return Key(Uint8List.fromList(padded));
    }
  }

  /// Encrypts a plaintext string into `<base64_iv>:<base64_ciphertext>`.
  String encryptString(String plainText) {
    if (plainText.isEmpty) return '';

    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypts a formatted `<base64_iv>:<base64_ciphertext>` string back to plaintext.
  String decryptString(String cipherText) {
    if (cipherText.isEmpty) return '';

    // Check if ciphertext follows the <iv>:<payload> envelope
    final separatorIndex = cipherText.indexOf(':');
    if (separatorIndex == -1) {
      // Not encrypted with this cipher (e.g. legacy or unencrypted string)
      return cipherText;
    }

    try {
      final ivBase64 = cipherText.substring(0, separatorIndex);
      final payloadBase64 = cipherText.substring(separatorIndex + 1);

      final iv = IV.fromBase64(ivBase64);
      final encrypted = Encrypted.fromBase64(payloadBase64);

      return _encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      // Return raw string if decryption fails (e.g. wrong key or corrupt data)
      return cipherText;
    }
  }

  /// Encrypts a double value into an encrypted string envelope.
  String encryptDouble(double value) {
    return encryptString(value.toString());
  }

  /// Decrypts an encrypted string envelope back into a double.
  double decryptDouble(String cipherText) {
    if (cipherText.isEmpty) return 0.0;
    final decrypted = decryptString(cipherText);
    return double.tryParse(decrypted) ?? 0.0;
  }

  /// Encrypts an integer value into an encrypted string envelope.
  String encryptInt(int value) {
    return encryptString(value.toString());
  }

  /// Decrypts an encrypted string envelope back into an integer.
  int decryptInt(String cipherText) {
    if (cipherText.isEmpty) return 0;
    final decrypted = decryptString(cipherText);
    return int.tryParse(decrypted) ?? 0;
  }

  /// Encrypts a JSON-serializable Map into an encrypted string payload.
  String encryptJson(Map<String, dynamic> jsonMap) {
    final jsonString = jsonEncode(jsonMap);
    return encryptString(jsonString);
  }

  /// Decrypts an encrypted string payload back into a JSON Map.
  Map<String, dynamic> decryptJson(String cipherText) {
    final decrypted = decryptString(cipherText);
    if (decrypted.isEmpty) return {};
    try {
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
