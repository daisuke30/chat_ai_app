import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceAssistant(),
    );
  }
}

class VoiceAssistant extends StatefulWidget {
  @override
  _VoiceAssistantState createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  String _recognizedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Assistant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_recognizedText),
            ElevatedButton(
              onPressed: _listen,
              child: Text('Listen'),
            ),
            ElevatedButton(
              onPressed: _speak,
              child: Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _listen() async {
    if (!_speechToText.isListening) {
      bool available = await _speechToText.initialize(
        onError: (val) => print('onError: $val'),
        onStatus: (val) => print('onStatus: $val'),
      );
      if (available) {
        _speechToText.listen(
          onResult: (val) {
            setState(() {
              _recognizedText = val.recognizedWords;
            });
          },
          localeId: 'en_US',
        );
      }
    } else {
      _speechToText.stop();
    }
  }

  Future<void> _speak() async {
    await _flutterTts.speak(_recognizedText);
  }
}
