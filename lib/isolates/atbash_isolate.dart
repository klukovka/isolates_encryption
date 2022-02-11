import 'package:isolates_encryption/isolates/isolate_dto.dart';

class Atbash {
  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz';

  static void atbashEncryptIsolate(IsolateDto isolateDto) {
    isolateDto.sendPort.send(_encryptText(isolateDto.text));
  }

  static void atbashDecryptIsolate(IsolateDto isolateDto) {
    isolateDto.sendPort.send(_decryptText(isolateDto.text));
  }

  static String _reverce(String inputText) {
    var reversedText = '';

    final chars = inputText.split('');
    for (final char in chars) {
      reversedText = char + reversedText;
    }

    return reversedText;
  }

  static String _encryptDecrypt(
    String text,
    String symbols,
    String cipher,
  ) {
    text = text.toLowerCase();

    var outputText = '';

    for (var i = 0; i < text.length; i++) {
      //поиск позиции символа в строке алфавита
      var index = symbols.indexOf(text[i]);
      if (index >= 0) {
        //замена символа на шифр
        outputText += cipher[index].toString();
      }
    }

    return outputText;
  }

  static String _encryptText(String plainText) {
    return _encryptDecrypt(plainText, _alphabet, _reverce(_alphabet));
  }

  static String _decryptText(String encryptedText) {
    return _encryptDecrypt(encryptedText, _reverce(_alphabet), _alphabet);
  }
}
