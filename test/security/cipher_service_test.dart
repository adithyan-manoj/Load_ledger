import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/security/cipher_service.dart';

void main() {
  group('CipherService AES-256 Tests', () {
    late CipherService cipher;
    const testKey = 'YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXoxMjM0NTY='; // Valid 32-byte base64

    setUp(() {
      cipher = CipherService(base64Key: testKey);
    });

    test('encrypts and decrypts strings correctly', () {
      const originalText = 'Prasanth - Kollam HPO - Member #121';
      final cipherText = cipher.encryptString(originalText);

      expect(cipherText, isNot(originalText));
      expect(cipherText.contains(':'), isTrue); // <iv>:<payload>

      final decrypted = cipher.decryptString(cipherText);
      expect(decrypted, originalText);
    });

    test('generates unique IVs for identical plaintexts (semantic security)', () {
      const plaintext = 'Confidential Loan Balance: ₹150,000';
      final cipher1 = cipher.encryptString(plaintext);
      final cipher2 = cipher.encryptString(plaintext);

      // Even with same text, ciphertexts must differ due to random IVs
      expect(cipher1, isNot(cipher2));

      // But both decrypt to the exact original plaintext
      expect(cipher.decryptString(cipher1), plaintext);
      expect(cipher.decryptString(cipher2), plaintext);
    });

    test('encrypts and decrypts floating-point numbers accurately', () {
      const originalDouble = 7084.50;
      final cipherText = cipher.encryptDouble(originalDouble);

      final decrypted = cipher.decryptDouble(cipherText);
      expect(decrypted, originalDouble);
    });

    test('encrypts and decrypts integer values accurately', () {
      const originalInt = 150005;
      final cipherText = cipher.encryptInt(originalInt);

      final decrypted = cipher.decryptInt(cipherText);
      expect(decrypted, originalInt);
    });

    test('encrypts and decrypts structured JSON maps', () {
      final originalMap = {
        'member_no': '121',
        'account_no': '02/25-26',
        'principal_outstanding': 150005.0,
        'base_emi': 7084.0,
      };

      final encrypted = cipher.encryptJson(originalMap);
      final decrypted = cipher.decryptJson(encrypted);

      expect(decrypted['member_no'], '121');
      expect(decrypted['account_no'], '02/25-26');
      expect(decrypted['principal_outstanding'], 150005.0);
      expect(decrypted['base_emi'], 7084.0);
    });

    test('handles empty inputs and unencrypted strings gracefully', () {
      expect(cipher.encryptString(''), '');
      expect(cipher.decryptString(''), '');

      // Plaintext without ':' is returned as-is
      expect(cipher.decryptString('Plaintext string'), 'Plaintext string');
    });
  });
}

