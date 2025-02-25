import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_symbol/ocr_symbol.dart';

class OcrWord {
  const OcrWord({
    required this.boundingBox,
    required this.symbols,
    required this.confidence,
  });

  final OcrBoundingBox boundingBox;
  final List<OcrSymbol> symbols;
  final double confidence;

  OcrWord map(
    OcrBoundingBox Function(OcrBoundingBox) boundingBoxFunction,
    List<OcrSymbol> Function(List<OcrSymbol>) symbolsFunction,
    double Function(double) confidenceFunction,
  ) => OcrWord(
    boundingBox: boundingBoxFunction(boundingBox),
    symbols: symbolsFunction(symbols),
    confidence: confidenceFunction(confidence),
  );

  String toWord() =>
      symbols.fold('', (prev, current) => prev + current.character);
}
