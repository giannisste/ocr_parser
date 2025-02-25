import '../ocr_bounding_box/ocr_bounding_box.dart';

class OcrSymbol {
  const OcrSymbol({
    required this.boundingBox,
    required this.character,
    required this.confidence,
  });

  final OcrBoundingBox boundingBox;
  final String character;
  final double confidence;

  OcrSymbol mapBoundingBox(
    OcrBoundingBox Function(OcrBoundingBox) boundingBoxFunction,
  ) => OcrSymbol(
    boundingBox: boundingBoxFunction(boundingBox),
    character: character,
    confidence: confidence,
  );
}
