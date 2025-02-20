import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_word/ocr_word.dart';

class OcrParagraph {
  const OcrParagraph({required this.boundingBox, required this.words, required this.confidence});

  final OcrBoundingBox boundingBox;
  final List<OcrWord> words;
  final double confidence;

  String toParagraph() => words.fold(
        '',
        (prev, current) =>
            current.symbols.length == 1 && [':', '.', ','].contains(current.symbols.first.character)
                ? '$prev${current.toWord()}'
                : '$prev ${current.toWord()}',
      );
}
