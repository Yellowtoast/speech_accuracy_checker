const int korBegin = 44032;
const int korEnd = 55203;
const int chosungBase = 588;
const int jungsungBase = 28;
const int jaumBegin = 12593;
const int jaumEnd = 12622;
const int moumBegin = 12623;
const int moumEnd = 12643;

List<String> chosungList = [
  'ㄱ',
  'ㄲ',
  'ㄴ',
  'ㄷ',
  'ㄸ',
  'ㄹ',
  'ㅁ',
  'ㅂ',
  'ㅃ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅉ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ'
];

List<String> jungsungList = [
  'ㅏ',
  'ㅐ',
  'ㅑ',
  'ㅒ',
  'ㅓ',
  'ㅔ',
  'ㅕ',
  'ㅖ',
  'ㅗ',
  'ㅘ',
  'ㅙ',
  'ㅚ',
  'ㅛ',
  'ㅜ',
  'ㅝ',
  'ㅞ',
  'ㅟ',
  'ㅠ',
  'ㅡ',
  'ㅢ',
  'ㅣ'
];

List<String> jongsungList = [
  ' ',
  'ㄱ',
  'ㄲ',
  'ㄳ',
  'ㄴ',
  'ㄵ',
  'ㄶ',
  'ㄷ',
  'ㄹ',
  'ㄺ',
  'ㄻ',
  'ㄼ',
  'ㄽ',
  'ㄾ',
  'ㄿ',
  'ㅀ',
  'ㅁ',
  'ㅂ',
  'ㅄ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ'
];

List<String> jaumList = [
  'ㄱ',
  'ㄲ',
  'ㄳ',
  'ㄴ',
  'ㄵ',
  'ㄶ',
  'ㄷ',
  'ㄸ',
  'ㄹ',
  'ㄺ',
  'ㄻ',
  'ㄼ',
  'ㄽ',
  'ㄾ',
  'ㄿ',
  'ㅀ',
  'ㅁ',
  'ㅂ',
  'ㅃ',
  'ㅄ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅉ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ'
];

List<String> moumList = [
  'ㅏ',
  'ㅐ',
  'ㅑ',
  'ㅒ',
  'ㅓ',
  'ㅔ',
  'ㅕ',
  'ㅖ',
  'ㅗ',
  'ㅘ',
  'ㅙ',
  'ㅚ',
  'ㅛ',
  'ㅜ',
  'ㅝ',
  'ㅞ',
  'ㅟ',
  'ㅠ',
  'ㅡ',
  'ㅢ',
  'ㅣ'
];

String compose(String chosung, String jungsung, String jongsung) {
  int charCode = korBegin +
      chosungBase * chosungList.indexOf(chosung) +
      jungsungBase * jungsungList.indexOf(jungsung) +
      jongsungList.indexOf(jongsung);
  return String.fromCharCode(charCode);
}

List<String>? decompose(String c) {
  if (!characterIsKorean(c)) return null;
  int i = c.codeUnitAt(0);
  if (jaumBegin <= i && i <= jaumEnd) return [c, ' ', ' '];
  if (moumBegin <= i && i <= moumEnd) return [' ', c, ' '];

  // decomposition rule
  i -= korBegin;
  int cho = i ~/ chosungBase;
  int jung = (i - cho * chosungBase) ~/ jungsungBase;
  int jong = (i - cho * chosungBase - jung * jungsungBase);
  return [chosungList[cho], jungsungList[jung], jongsungList[jong]];
}

bool characterIsKorean(String c) {
  int i = c.codeUnitAt(0);
  return ((korBegin <= i && i <= korEnd) ||
      (jaumBegin <= i && i <= jaumEnd) ||
      (moumBegin <= i && i <= moumEnd));
}

int levenshtein(String s1, String s2, {bool debug = false}) {
  if (s1.length < s2.length) return levenshtein(s2, s1, debug: debug);

  if (s2.isEmpty) return s1.length;

  List<int> previousRow =
      List<int>.generate(s2.length + 1, (int index) => index);

  for (int i = 0; i < s1.length; i++) {
    List<int> currentRow = [i + 1];

    for (int j = 0; j < s2.length; j++) {
      int insertions = previousRow[j + 1] + 1;
      int deletions = currentRow[j] + 1;
      int substitutions = previousRow[j] + (s1[i] != s2[j] ? 1 : 0);
      currentRow.add([insertions, deletions, substitutions]
          .reduce((a, b) => a < b ? a : b));
    }

    if (debug) print(currentRow.sublist(1));

    previousRow = currentRow;
  }

  return previousRow.last;
}

double jamoLevenshtein(String s1, String s2, {bool debug = false}) {
  if (s1.length < s2.length) return jamoLevenshtein(s2, s1, debug: debug);

  if (s2.isEmpty) return s1.length.toDouble();

  double substitutionCost(String c1, String c2) {
    if (c1 == c2) return 0;
    return levenshtein(decompose(c1)!.join(), decompose(c2)!.join()) / 3;
  }

  List<double> previousRow =
      List<double>.generate(s2.length + 1, (int index) => index.toDouble());

  for (int i = 0; i < s1.length; i++) {
    List<double> currentRow = [i + 1.0];

    for (int j = 0; j < s2.length; j++) {
      double insertions = previousRow[j + 1] + 1.0;
      double deletions = currentRow[j] + 1.0;
      double substitutions = previousRow[j] + substitutionCost(s1[i], s2[j]);
      currentRow.add([insertions, deletions, substitutions]
          .reduce((a, b) => a < b ? a : b));
    }

    if (debug) {
      print(currentRow
          .sublist(1)
          .map((double v) => v.toStringAsFixed(3))
          .toList());
    }

    previousRow = currentRow;
  }

  return previousRow.last;
}

double jamoSimilarityPercentage(String s1, String s2) {
  int maxLen = s1.length > s2.length ? s1.length : s2.length;
  double distance = jamoLevenshtein(s1, s2);
  return ((maxLen - distance) / maxLen) * 100;
}

String convertTextToKorean(String text) {
  // 숫자를 한글로 변환하는 함수
  String numberToKorean(int number) {
    if (number == 0) {
      return '영';
    }

    List<String> units = [
      '',
      '십',
      '백',
      '천',
      '만',
      '십만',
      '백만',
      '천만',
      '억',
      '십억',
      '백억',
      '천억',
      '조',
      '십조',
      '백조',
      '천조',
      '경',
      '십경',
      '백경',
      '천경'
    ];
    List<String> digits = ['영', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

    List<int> numList = [];
    while (number > 0) {
      numList.add(number % 10);
      number ~/= 10;
    }

    String result = '';
    for (int i = numList.length - 1; i >= 0; i--) {
      int digit = numList[i];
      if (digit != 0) {
        result += digits[digit];
        result += units[i];
      }
    }

    return result;
  }

  // 텍스트에서 숫자 부분을 한글로 변환하는 함수
  String replaceNumberWithKorean(String text) {
    String result = '';
    String currentNumber = '';
    bool isNumber = false;

    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(text[i])) {
        currentNumber += text[i];
        isNumber = true;
      } else {
        if (isNumber) {
          result += numberToKorean(int.parse(currentNumber));
          currentNumber = '';
          isNumber = false;
        }
        result += text[i];
      }
    }
    if (isNumber) {
      result += numberToKorean(int.parse(currentNumber));
    }

    return result;
  }

  return replaceNumberWithKorean(text);
}

class SpecialCharToSpeech {
  final String specialChar;
  final String speech;

  SpecialCharToSpeech({required this.specialChar, required this.speech});
}

String convertSpecialCharsToKorean(
  String text,
  List<SpecialCharToSpeech>? specialCharToSpeech,
) {
  // 특수 기호를 한글로 변환하는 함수
  Map<String, String> specialCharsToKorean = {
    '%': '퍼센트',
    '-': '다시',
  };
  if (specialCharToSpeech != null && specialCharToSpeech.isNotEmpty) {
    specialCharsToKorean.addAll(
      {for (var v in specialCharToSpeech) v.specialChar: v.speech},
    );
  }

  String result = '';
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    if (specialCharsToKorean.containsKey(char)) {
      result += specialCharsToKorean[char] ?? '';
    } else {
      result += char;
    }
  }
  return result;
}

void main() {
  String s1 = '자가격리자는1층에서체크인합니다';
  String s2 = '삭가격리여는일층에너샤크인갑니다';
  // String s2 = '작아경니자는일층애서채크잉함닝당';

  s1 = convertTextToKorean(s1);
  s1 = convertSpecialCharsToKorean(s1, [
    SpecialCharToSpeech(specialChar: '%', speech: '퍼센트'),
    SpecialCharToSpeech(specialChar: '-', speech: '다시')
  ]);

  final result = jamoSimilarityPercentage(convertTextToKorean(s1), s2);
  print(result);
}
