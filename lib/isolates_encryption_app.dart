import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:isolates_encryption/isolates/atbash_isolate.dart';
import 'package:isolates_encryption/isolates/caesar_cipher_isolate.dart';

import 'isolates/vigenere_cipher_isolate.dart';

class IsolatesEncryptionApp extends StatelessWidget {
  const IsolatesEncryptionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _atbashEncrypt() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
        Atbash.atbashEncryptIsolate,
        AtbashIsolateDto(
          receivePort.sendPort,
          _textController.text,
        ));
    receivePort.listen((message) {
      _showSnackBar(message);
    });
  }

  void _atbashDecrypt() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
        Atbash.atbashDecryptIsolate,
        AtbashIsolateDto(
          receivePort.sendPort,
          _textController.text,
        ));
    receivePort.listen((message) {
      _showSnackBar(message);
    });
  }

  void _caesarCipherEncrypt() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
        CaesarCipherIsolate.caesarCipherEncryptIsolate,
        CaesarCipherIsolateDto(
          receivePort.sendPort,
          _textController.text,
          2,
        ));
    receivePort.listen((message) {
      _showSnackBar(message);
    });
  }

  void _caesarCipherDecrypt() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
        CaesarCipherIsolate.caesarCipherDecryptIsolate,
        CaesarCipherIsolateDto(
          receivePort.sendPort,
          _textController.text,
          2,
        ));
    receivePort.listen((message) {
      _showSnackBar(message);
    });
  }

  void _vigenereCipherEncrypt() async {
    final receivePort = ReceivePort();
    final vigenereCipher = VigenereCipherIsolate();

    await Isolate.spawn(
      vigenereCipherEncryptIsolate(vigenereCipher),
      VigenereCipherIsolateDto(
        receivePort.sendPort,
        _textController.text,
        'password',
      ),
    );

    receivePort.listen((message) {
      _showSnackBar(message);
    });
  }

  void _vigenereCipherDecrypt() async {
    final receivePort = ReceivePort();
    final vigenereCipher = VigenereCipherIsolate();

    await Isolate.spawn(
      vigenereCipherDecryptIsolate(vigenereCipher),
      VigenereCipherIsolateDto(
        receivePort.sendPort,
        _textController.text,
        'password',
      ),
    );

    receivePort.listen((message) {
      _showSnackBar(message);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EncryptionApp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAtbashButtons(),
            _buildCaesarCipherButtons(),
            _buildVigenereButtons(),
            TextField(
              controller: _textController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtbashButtons() {
    return Wrap(
      spacing: 12,
      children: [
        ElevatedButton(
          onPressed: _atbashEncrypt,
          child: const Text('Atbash Encrypt'),
        ),
        ElevatedButton(
          onPressed: _atbashDecrypt,
          child: const Text('Atbash Decrypt'),
        ),
      ],
    );
  }

  Widget _buildCaesarCipherButtons() {
    return Wrap(
      spacing: 12,
      children: [
        ElevatedButton(
          onPressed: _caesarCipherEncrypt,
          child: const Text('CaesarCipher Encrypt'),
        ),
        ElevatedButton(
          onPressed: _caesarCipherDecrypt,
          child: const Text('CaesarCipher Decrypt'),
        ),
      ],
    );
  }

  Widget _buildVigenereButtons() {
    return Wrap(
      spacing: 12,
      children: [
        ElevatedButton(
          onPressed: _vigenereCipherEncrypt,
          child: const Text('Vigenere Encrypt'),
        ),
        ElevatedButton(
          onPressed: _vigenereCipherDecrypt,
          child: const Text('Vigenere Decrypt'),
        ),
      ],
    );
  }
}
