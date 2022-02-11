import 'dart:isolate';

class IsolateDto {
  final SendPort sendPort;
  final String text;

  IsolateDto(this.sendPort, this.text);
}
