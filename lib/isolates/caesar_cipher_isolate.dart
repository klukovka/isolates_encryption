import 'dart:isolate';

class CaesarCipherIsolateDto {
  final SendPort sendPort;
  final String text;
  final int key;

  CaesarCipherIsolateDto(
    this.sendPort,
    this.text,
    this.key,
  );
}

class CaesarCipherIsolate {
  static const _alphabet =
      'abcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';

  static void caesarCipherEncryptIsolate(CaesarCipherIsolateDto isolateDto) {
    isolateDto.sendPort.send(_encrypt(isolateDto.text, isolateDto.key));
  }

  static void caesarCipherDecryptIsolate(CaesarCipherIsolateDto isolateDto) {
    isolateDto.sendPort.send(_decrypt(isolateDto.text, isolateDto.key));
  }

  static String _codeEncode(String text, int k) {
    var fullAlfabet = _alphabet + _alphabet.toLowerCase();
    var letterQty = fullAlfabet.length;
    var retVal = '';
    for (int i = 0; i < text.length; i++) {
      var c = text[i];
      var index = fullAlfabet.indexOf(c);
      if (index < 0) {
        retVal += c.toString();
      } else {
        var codeIndex = (letterQty + index + k) % letterQty;
        retVal += fullAlfabet[codeIndex];
      }
    }

    return retVal;
  }

  static String _encrypt(String plainMessage, int key) =>
      _codeEncode(plainMessage, key);

  static String _decrypt(String encryptedMessage, int key) =>
      _codeEncode(encryptedMessage, -key);
}
