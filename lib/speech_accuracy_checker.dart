library speech_accuracy_checker;

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechAccuracyChecker {
  SpeechAccuracyChecker(this._speechResult);

  final SpeechToText _speechToText = SpeechToText();

  final void Function(SpeechRecognitionResult result)? _speechResult;

  startListening() {
    _speechToText.listen(onResult: _speechResult);
  }

  stopListening() {
    _speechToText.listen(onResult: _speechResult);
  }
}
