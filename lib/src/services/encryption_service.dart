import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  late encrypt.Encrypter _encrypter;
  late encrypt.IV _iv;
  late String _hmacKey;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    String? key = prefs.getString('encryption_key');
    String? iv = prefs.getString('encryption_iv');
    String? hmacKey = prefs.getString('hmac_key');

    if (key == null || iv == null || hmacKey == null) {
      // Generate new keys if they don't exist
      final newKey = encrypt.Key.fromSecureRandom(32);
      final newIv = encrypt.IV.fromSecureRandom(16);
      final newHmacKey = encrypt.Key.fromSecureRandom(32);
      
      key = newKey.base64;
      iv = newIv.base64;
      hmacKey = newHmacKey.base64;
      
      await prefs.setString('encryption_key', key);
      await prefs.setString('encryption_iv', iv);
      await prefs.setString('hmac_key', hmacKey);
    }

    _encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(key)));
    _iv = encrypt.IV.fromBase64(iv);
    _hmacKey = hmacKey;
    _isInitialized = true;
  }

  String _generateHmac(String data) {
    final hmac = Hmac(sha256, base64Decode(_hmacKey));
    final digest = hmac.convert(utf8.encode(data));
    return base64Encode(digest.bytes);
  }

  bool _verifyHmac(String data, String hmac) {
    return _generateHmac(data) == hmac;
  }

  Map<String, dynamic> encryptDataWithHmac(String data) {
    if (!_isInitialized) {
      throw Exception('EncryptionService not initialized');
    }
    final encryptedData = _encrypter.encrypt(data, iv: _iv).base64;
    final hmac = _generateHmac(encryptedData);
    return {
      'data': encryptedData,
      'hmac': hmac,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  String decryptDataWithHmac(Map<String, dynamic> encryptedData) {
    if (!_isInitialized) {
      throw Exception('EncryptionService not initialized');
    }
    
    final data = encryptedData['data'] as String;
    final hmac = encryptedData['hmac'] as String;
    final timestamp = encryptedData['timestamp'] as int;
    
    // Verify data integrity
    if (!_verifyHmac(data, hmac)) {
      throw Exception('Data integrity check failed');
    }
    
    // Optional: Check if data is too old (e.g., older than 24 hours)
    final dataAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (dataAge > 24 * 60 * 60 * 1000) {
      throw Exception('Data is too old');
    }
    
    return _encrypter.decrypt64(data, iv: _iv);
  }

  Map<String, dynamic> encryptMap(Map<String, dynamic> data) {
    final encryptedMap = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is String) {
        final encrypted = encryptDataWithHmac(value);
        encryptedMap[key] = jsonEncode(encrypted);
      } else if (value is Map<String, dynamic>) {
        encryptedMap[key] = jsonEncode(encryptMap(value));
      } else if (value is List) {
        encryptedMap[key] = jsonEncode(value.map((item) {
          if (item is String) {
            return jsonEncode(encryptDataWithHmac(item));
          } else if (item is Map<String, dynamic>) {
            return jsonEncode(encryptMap(item));
          }
          return item;
        }).toList());
      } else {
        encryptedMap[key] = value;
      }
    });
    return encryptedMap;
  }

  Map<String, dynamic> decryptMap(Map<String, dynamic> encryptedData) {
    final decryptedMap = <String, dynamic>{};
    encryptedData.forEach((key, value) {
      if (value is String) {
        try {
          final encrypted = jsonDecode(value) as Map<String, dynamic>;
          if (encrypted.containsKey('data') && encrypted.containsKey('hmac')) {
            decryptedMap[key] = decryptDataWithHmac(encrypted);
          } else {
            decryptedMap[key] = value;
          }
        } catch (e) {
          decryptedMap[key] = value;
        }
      } else if (value is Map<String, dynamic>) {
        decryptedMap[key] = decryptMap(value);
      } else if (value is List) {
        decryptedMap[key] = value.map((item) {
          if (item is String) {
            try {
              final encrypted = jsonDecode(item) as Map<String, dynamic>;
              if (encrypted.containsKey('data') && encrypted.containsKey('hmac')) {
                return decryptDataWithHmac(encrypted);
              }
            } catch (e) {
              return item;
            }
          } else if (item is Map<String, dynamic>) {
            return decryptMap(item);
          }
          return item;
        }).toList();
      } else {
        decryptedMap[key] = value;
      }
    });
    return decryptedMap;
  }
} 