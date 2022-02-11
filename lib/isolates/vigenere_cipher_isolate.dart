import 'dart:isolate';

class VigenereCipherIsolateDto {
  final SendPort sendPort;
  final String text;
  final String password;

  VigenereCipherIsolateDto(
    this.sendPort,
    this.text,
    this.password,
  );
}

class VigenereCipherIsolate {
  static const String defaultAlphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";

  late final String letters;

  VigenereCipherIsolate([String? alphabet]) {
    letters = alphabet ?? defaultAlphabet;
  }

  static String _getRepeatKey(String s, int n) {
    var p = s;
    while (p.length < n) {
      p += p;
    }

    return p.substring(0, n);
  }

  String _vigenere(String text, String password, [bool encrypting = true]) {
    var gamma = _getRepeatKey(password, text.length);
    var retValue = '';
    var q = letters.length;

    for (int i = 0; i < text.length; i++) {
      var letterIndex = letters.indexOf(text[i]);
      var codeIndex = letters.indexOf(gamma[i]);
      if (letterIndex < 0) {
        retValue += text[i].toString();
      } else {
        retValue +=
            letters[(q + letterIndex + ((encrypting ? 1 : -1) * codeIndex)) % q]
                .toString();
      }
    }

    return retValue;
  }

  String encrypt(String plainMessage, String password) =>
      _vigenere(plainMessage, password);

  String decrypt(String encryptedMessage, String password) =>
      _vigenere(encryptedMessage, password, false);
}

Function(VigenereCipherIsolateDto) vigenereCipherEncryptIsolate(
  VigenereCipherIsolate vigenereCipher,
) {
  return (isolateDto) {
    isolateDto.sendPort.send(
      vigenereCipher.encrypt(isolateDto.text, isolateDto.password),
    );
  };
}

Function(VigenereCipherIsolateDto) vigenereCipherDecryptIsolate(
  VigenereCipherIsolate vigenereCipher,
) {
  return (isolateDto) {
    isolateDto.sendPort.send(
      vigenereCipher.decrypt(isolateDto.text, isolateDto.password),
    );
  };
}
